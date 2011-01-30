@import <AppKit/CPWindow.j>
@import <AppKit/CPSplitView.j>


@import "NIProjectWindowNavigatorView.j";

var NIProjectWindow_leftPanelWidth = 150;

/*
	Widok projektu, połączenia z stroną.
	Okno projekt składa się:
	- lewy panel nawigatora
	- prawy panel z contentem 
*/
@implementation NIProjectWindow : CPWindow
{
	
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,800,400) 
						     styleMask:CPTitledWindowMask | CPClosableWindowMask | CPResizableWindowMask];

	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Otwarty projekt"];

		var splitView = [[CPSplitView alloc] initWithFrame: CGRectMake(CGRectGetMinX(frame),
																	   CGRectGetMinY(frame),
																	   CGRectGetWidth(frame), 
																	   CGRectGetMaxY(frame)-100)];

			[splitView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
			[splitView setIsPaneSplitter:YES];

		var navigatorView = [[NIProjectWindowNavigatorView alloc] initWithFrame: CGRectMake(CGRectGetMinX([splitView frame]),
																				 			CGRectGetMinY([splitView frame]),
																							CGRectGetWidth([splitView frame]), 
																							CGRectGetHeight([splitView frame]))];
			// [navigatorView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
			
			[splitView addSubview: navigatorView];
			[splitView setButtonBar:[navigatorView buttonBar] forDividerAtIndex:0];
		
			[splitView addSubview: [CPButton buttonWithTitle:@"Test2"]];
		
		[contentView addSubview: splitView];
	}
	
	return self;
}

@end