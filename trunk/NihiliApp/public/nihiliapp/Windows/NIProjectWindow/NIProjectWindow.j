@import <AppKit/CPWindow.j>

@import "NIProjectWindowNavigatorView.j";
@import "NIProjectWindowEditor.j";
@import "../../NITextView.j"



var NIProjectWindow_leftPanelWidth = 210;

/*
	Widok projektu, połączenia z stroną.
	Okno projekt składa się:
	- lewy panel nawigatora
	- prawy panel z contentem 
*/
@implementation NIProjectWindow : CPWindow
{
	NIProjectWindowNavigatorView navigatorView @accessors(readonly);
	NIProjectWindowEditor editorView @accessors(readonly);
	// NITextView textView @accessors(readonly);
}

- (id)init
{
	self = [super initWithContentRect:CGRectMakeZero()
						     styleMask:CPBorderlessBridgeWindowMask];

	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Otwarty projekt"];

		var splitView = [[CPSplitView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(frame), 
																	   		 CGRectGetHeight(frame))];

			[splitView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
			[splitView setIsPaneSplitter:YES];

		// Nawigator
		navigatorView = [[NIProjectWindowNavigatorView alloc] initWithFrame: CGRectMakeZero()];
		[splitView addSubview: navigatorView];
		[splitView setButtonBar:[navigatorView buttonBar] forDividerAtIndex:0];

		// Edytor
		editorView = [[NIProjectWindowEditor alloc] initWithFrame: CGRectMakeZero()];
		[splitView addSubview: editorView];
		//[splitView setButtonBar:[editorView buttonBar] forDividerAtIndex:0];
		
		[splitView setPosition:NIProjectWindow_leftPanelWidth ofDividerAtIndex:0];
		
		[contentView addSubview: splitView];
	}
	
	return self;
}

@end