@import <AppKit/CPWindow.j>
@import <AppKit/CPSplitView.j>


@import "NIProjectWindowNavigatorView.j";
@import "../../NITextView.j"

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
		
		var splitView = [[CPSplitView alloc] initWithFrame: CGRectMake(0,
																	   0,
																	   CGRectGetWidth(frame), 
																	   CGRectGetHeight(frame))];

			[splitView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
			[splitView setIsPaneSplitter:YES];

		// Nawigator
		var navigatorView = [[NIProjectWindowNavigatorView alloc] initWithFrame: CGRectMakeZero()];
			
		[splitView addSubview: navigatorView];
		[splitView setButtonBar:[navigatorView buttonBar] forDividerAtIndex:0];
			
		// Podgląd contentu
		var textView = [[NITextView alloc] initWithFrame:CGRectMakeZero()];
		[splitView addSubview: textView];
	
		[splitView setPosition:NIProjectWindow_leftPanelWidth ofDividerAtIndex:0];
	
		[contentView addSubview: splitView];
	}
	
	return self;
}

@end