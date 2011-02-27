@import <AppKit/CPView.j>
@import <AppKit/CPButton.j>
@import <AppKit/CPButtonBar.j>
@import <AppKit/CPScrollView.j>

// @import <AppKit/CPTabView.j>

// TODO: Wyciągnąć od wsólnego pliku konfiguracyjnego
var NIProjectWindow_buttonBarHeight = 24;

@implementation NIProjectWindowEditor : CPView
{
	CPButtonBar buttonBar @accessors(readonly);
	CPButton saveButton @accessors(readonly);
	NITextView textView @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame
{
	if(self = [super initWithFrame:aFrame])
	{
		// var tabView = [[CPTabView alloc] initWithFrame:CGRectMake(0, 0, 
		// 																CGRectGetWidth([self frame]), 
		// 																CGRectGetHeight([self frame]) - NIProjectWindow_buttonBarHeight)];
		// 	[tabView setTabViewType:CPTopTabsBezelBorder];
		// 	[tabView layoutSubviews];
		// 	[tabView setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
		// 	
		// var webView = [[CPView alloc] initWithFrame:CPRectMakeZero()];
		// 
		// var editTabItem = [[CPTabViewItem alloc] initWithIdentifier:@"item"];
		// 	[editTabItem setLabel:@"Web"];
		// 	[editTabItem setView:webView];
		// 	
		// [tabView addTabViewItem:editTabItem];
		// [self addSubview:tabView];

		// Podgląd contentu
		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, 
																		CGRectGetWidth([self frame]), 
																		CGRectGetHeight([self frame]) - NIProjectWindow_buttonBarHeight)];

			[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
			[scrollView setHasHorizontalScroller: YES];


		textView = [[NITextView alloc] initWithFrame:[scrollView frame]];
		[scrollView setDocumentView:textView];
		[self addSubview:scrollView];
		
		
		// Buttonbar
		buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, 
																  CGRectGetHeight([self frame]) - NIProjectWindow_buttonBarHeight,
																  CGRectGetWidth([self frame]), 
																  NIProjectWindow_buttonBarHeight)];

		[buttonBar setAutoresizingMask: CPViewWidthSizable | CPViewMinYMargin];

		saveButton = [CPButton buttonWithTitle:@"Zapisz"];

		// Opcje
		optionsButton = [CPButtonBar actionPopupButton];		
			var item = [[CPMenuItem alloc] init];
				[item setTitle:@"Włącz kolorowanie składni"];
				[item setTag:@"highlight"];
			[optionsButton addItem:item];	
		
		var buttons = [
			saveButton,
			optionsButton
		];

		[buttonBar setButtons:buttons];
		[self addSubview:buttonBar];
	}
	return self;
}

@end