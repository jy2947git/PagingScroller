//
//  PagingScrollerView.m
//  PagingScrollerView
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PagingScrollerView.h"
#import "PageView.h"


#define PAGE_CONTROL_HEIGHT 30
#define PADDING_SPACE 2
#define DEFAULT_PAGE_NUMBER_IN_PAGE_CONTROL 5
@implementation PagingScrollerView
@synthesize pagingScrollView, pageControll, delegate, pageControllDisplayPages;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		//TODO Need to better setting here
		UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(PADDING_SPACE, PADDING_SPACE, frame.size.width-2*PADDING_SPACE, frame.size.height-PAGE_CONTROL_HEIGHT-PADDING_SPACE)];
		s.scrollsToTop=NO;
		s.directionalLockEnabled=YES;
		s.alwaysBounceHorizontal=YES;
		s.alwaysBounceVertical=NO;
		s.backgroundColor=[UIColor clearColor];
	
		self.pagingScrollView=s;
		
		[s release];
		[self addSubview:self.pagingScrollView];
		
		UIPageControl *p = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width/2-20, frame.size.height-PAGE_CONTROL_HEIGHT+PADDING_SPACE, 80, PAGE_CONTROL_HEIGHT)];
		p.defersCurrentPageDisplay=NO;
		self.pageControll=p;
		[p release];
		[self addSubview:self.pageControll];
		
		recycledPages = [[NSMutableSet alloc] init];
		visiblePages = [[NSMutableSet alloc] init];
		
		pagingScrollView.pagingEnabled = YES;
		pagingScrollView.backgroundColor = [UIColor clearColor];
		pagingScrollView.showsVerticalScrollIndicator = NO;
		pagingScrollView.showsHorizontalScrollIndicator = NO;
		pagingScrollView.delegate = self;
		

		//set the page control
		pageControllDisplayPages = DEFAULT_PAGE_NUMBER_IN_PAGE_CONTROL;
		self.pageControll.numberOfPages=DEFAULT_PAGE_NUMBER_IN_PAGE_CONTROL;
		[self.pageControll addTarget: self action:@selector(pageControllValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	[super drawRect:rect];
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];

	[self displayPage];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[pagingScrollView release];
	[pageControll release];
    [recycledPages release];
    [visiblePages release];
}

- (CGSize)contentSizeForPagingScrollView {
    // calculate the scrollview content size based on view-size and item count
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self pageCount], bounds.size.height);
}

- (void)updatePageCount{
	//this is called whenver the delegate/controller load more items
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];

}

- (NSUInteger)pageCount{
	//get current item total number
	return [delegate pageCount];
}

- (void)displayPage{
	//figure out which "current page" to display, call the delegate to get the "view" and add
	// Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [delegate pageCount] - 1);
    
    // Recycle no-longer-visible pages 
    for (PageView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        [self displayPageOfIndex:index];
    }    
	
}

- (void)displayPageOfIndex:(NSUInteger)index{
	if (![self isDisplayingPageForIndex:index]) {
		PageView *page = [self dequeueRecycledPage];
		if (page == nil) {
			page = [delegate createViewOfPage:0];
		}
		NSLog(@"configurePageforIndex %i", index);
		NSLog(@"current content size %i", self.pagingScrollView.contentSize.width);
		[self configurePage:page forIndex:index];
		
		[pagingScrollView addSubview:page];
		[visiblePages addObject:page];
		
	}
	currentPageNumber=index; //the last one will be the currentPage
	

}

- (PageView *)dequeueRecycledPage
{
    PageView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (PageView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
			
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(PageView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    

	[page displayDataView:[self dataViewAtIndex:index]];
}
#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
	NSLog(@"self.pagingScrollView.frame %i %i %i %i", self.pagingScrollView.frame.origin.x, self.pagingScrollView.frame.origin.y, self.pagingScrollView.frame.size.width, self.pagingScrollView.frame.size.height);
	CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (UIView *)dataViewAtIndex:(NSUInteger)index {
    return [delegate dataViewAtIndex:index];    
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self displayPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSLog(@"Currently displayed page is %i", currentPageNumber);
	//after scrolling, sync page-control
	pageControll.currentPage = ((int)currentPageNumber)%((int)pageControllDisplayPages);
	if (pageControll.currentPage==0) {
		pageControlStartPage = pageControlStartPage + pageControllDisplayPages;
	}
	NSLog(@"change page-control current page to %i, it is actually page #%i", pageControll.currentPage, pageControlStartPage+pageControll.currentPage);
}
#pragma mark -
#pragma mark UIPageControl event
- (void)pageControllValueChanged:(UIPageControl*)sender{
	NSLog(@"to display page %i which is actually %i", sender.currentPage, pageControlStartPage+pageControll.currentPage);
//	[self displayPageOfIndex:pageControlStartPage+pageControll.currentPage];
	CGRect targetContentFrame = [self frameForPageAtIndex:pageControlStartPage+pageControll.currentPage];
	[self.pagingScrollView setContentOffset:targetContentFrame.origin animated:YES];
}

- (void)setMaxPagesNumberInPageControl:(NSUInteger)totalPage{
	pageControllDisplayPages = totalPage;
	self.pageControll.numberOfPages=totalPage;
}
@end
