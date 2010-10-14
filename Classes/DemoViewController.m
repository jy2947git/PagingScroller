//
//  DemoViewController.m
//  PagingScroller
//
//  Created by jy2947 on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DemoViewController.h"
#import "PagingScrollerView.h"
#import "PageView.h"

@implementation DemoViewController
@synthesize scrollView, message;
#define page_control_NUMBER 5
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//
		
        // Custom initialization
		items = [[NSMutableArray alloc] init];
		
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	//load initial batch of data, this is import!!!!
	[self loadItemsFrom:0 to:page_control_NUMBER];
	PagingScrollerView *v = [[PagingScrollerView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
	self.scrollView=v;
	[v release];
	self.scrollView.delegate=self;
	[self.scrollView setMaxPagesNumberInPageControl:page_control_NUMBER];
	[self.view addSubview:self.scrollView];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[scrollView release];
	scrollView=nil;
	[message release];
	message=nil;
}


- (void)dealloc {
	[items release];
	[message release];
	[scrollView release];
    [super dealloc];
}
#pragma mark -
#pragma mark PagingScrollerAppDelegate
- (NSUInteger)pageCount{
	//TODO items is dynamic!!
//	NSLog(@"There is %i pages", MIN([items count], page_control_NUMBER));
	return [items count];
}
- (PageView*)createViewOfPage:(NSUInteger)page{
	PageView *view = [[[PageView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)] autorelease];
	return view;
}
- (UIView *)dataViewAtIndex:(NSUInteger)index{
	NSLog(@"dataViewAtIndex %i of %i", index, [items count]);
	if ([items count]==0) {
		if([self loadItemsFrom:0 to:page_control_NUMBER]){
			//
			message.text=[NSString stringWithFormat:@"no item yet, loading..."];
			[self.scrollView updatePageCount];
		}
	}else if ([items count]>index+1 && [items count]-index<3) {
		//close t end, load next batch
		if([self loadItemsFrom:[items count]  to:[items count]+page_control_NUMBER]){
			//
			[self.scrollView updatePageCount];
		}
	}else if([items count]<index+1){
		//load until data is within range
		while ([items count]<(index+1+page_control_NUMBER)) {
			if([self loadItemsFrom:[items count]  to:[items count]+page_control_NUMBER]){
				//
				[self.scrollView updatePageCount];
			}else {
				//no more from server, stop now!
				break;
			}
			
			
		}
		
	}
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width/2-50, self.scrollView.frame.size.height/2, 100, 20)] autorelease];
	if (index<[items count]) {
		label.text=[items objectAtIndex:index];
	}else {
		NSLog(@"come to end");
		label.text=@"No more!!!";
	}
	
	NSLog(@"return label with text %@", label.text);
	return label;
}
- (BOOL)loadItemsFrom:(NSUInteger)start to:(NSUInteger)end{
	if (end>page_control_NUMBER*4) {
		//4 batch we are done
		return NO;
	}
	message.text=[NSString stringWithFormat:@"loading data from %i to %i", start, end];
	for (int i=start; i<end; i++) {
		[items insertObject:[NSString stringWithFormat:@"Item %i",i] atIndex:i];
		NSLog(@"Items[%@]", items);
	}
	return YES;
}


@end
