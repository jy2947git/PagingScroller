//
//  PagingScrollerAppDelegate.h
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemoViewController;
@interface PagingScrollerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	DemoViewController *vc;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) DemoViewController *vc;

@end

