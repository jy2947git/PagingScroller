//
//  PageView.m
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PageView.h"


@implementation PageView
@synthesize index, dataView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
//        //self.bouncesZoom = YES;
//        self.decelerationRate = UIScrollViewDecelerationRateFast;
//        self.delegate = self;  
//		self.backgroundColor=[UIColor redColor];
//		self.scrollsToTop=NO;
//		self.directionalLockEnabled=YES;
//		self.alwaysBounceHorizontal=YES;
//		self.alwaysBounceVertical=NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[dataView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
//    
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = dataView.frame;
//    
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//    
//    dataView.frame = frameToCenter;

}

#pragma mark -
#pragma mark Configure scrollView to display real data 

- (void)displayDataView:(UIView *)_dataView
{
    // clear the previous imageView
    [dataView removeFromSuperview];
    [dataView release];
    dataView = nil;
    
    // make a new UIImageView for the new image
	self.dataView=_dataView;
    [self addSubview:dataView];
    
//    self.contentSize = CGSizeMake(320, 480);
}

@end
