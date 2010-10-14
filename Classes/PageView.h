//
//  PageView.h
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView {
    UIView        *dataView;
    NSUInteger     index;
}
@property (assign) NSUInteger index;
@property (nonatomic, retain) UIView        *dataView;

- (void)displayDataView:(UIView *)_dataView;
@end
