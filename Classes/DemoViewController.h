//
//  DemoViewController.h
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PagingScrollerView.h"

@interface DemoViewController : UIViewController <PagingScrollerDelegate>{
	PagingScrollerView *scrollView;
	NSMutableArray *items;
	UILabel *message;
}
@property(nonatomic, retain) IBOutlet PagingScrollerView *scrollView;
@property(nonatomic, retain) IBOutlet UILabel *message;
- (BOOL)loadItemsFrom:(NSUInteger)start to:(NSUInteger)end;
@end
