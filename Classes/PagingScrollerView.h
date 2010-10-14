//
//  PageScrollerView.h
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageView;
@protocol PagingScrollerDelegate;
@interface PagingScrollerView : UIView <UIScrollViewDelegate>{
	UIScrollView *pagingScrollView;
	UIPageControl *pageControll;
	id <PagingScrollerDelegate> delegate;
	
	NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	NSUInteger pageControllDisplayPages;
	
	NSUInteger currentPageNumber; //current page (in the context of the scroll-view) being displayed
	NSUInteger pageControlStartPage; //the page number which the first page of page control maps.
}
@property(nonatomic, retain) UIScrollView *pagingScrollView;
@property(nonatomic, retain) UIPageControl *pageControll;
@property(nonatomic, retain) id delegate;
@property(assign) NSUInteger pageControllDisplayPages;
- (void)displayPage;
- (CGSize)contentSizeForPagingScrollView;
- (NSUInteger)pageCount;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (UIView *)dataViewAtIndex:(NSUInteger)index ;
- (PageView *)dequeueRecycledPage;
- (void)configurePage:(PageView *)page forIndex:(NSUInteger)index;
- (void)displayPageOfIndex:(NSUInteger)index;
- (void)setMaxPagesNumberInPageControl:(NSUInteger)totalPage;
- (void)updatePageCount;
@end

@protocol PagingScrollerDelegate
@required
- (NSUInteger)pageCount;
- (PageView*)createViewOfPage:(NSUInteger)page;
- (UIView *)dataViewAtIndex:(NSUInteger)index;

@end

