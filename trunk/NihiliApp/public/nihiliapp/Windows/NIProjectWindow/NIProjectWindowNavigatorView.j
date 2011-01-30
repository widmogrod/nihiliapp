@import <AppKit/CPButton.j>
@import <AppKit/CPButtonBar.j>
@import <AppKit/CPOutlineView.j>
@import <AppKit/CPScrollView.j>

@import "../../NIButton.j"

var NIProjectWindow_buttonBarHeight= 24;

@implementation NIProjectWindowNavigatorView : CPView
{
	CPButtonBar buttonBar @accessors(readonly);
	CPButton plusButton @accessors(readonly);
	CPPopupButton optionsButton @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame
{
	if(self = [super initWithFrame:aFrame])
	{	
		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, 
																		CGRectGetWidth([self frame]), 
															 			CGRectGetHeight([self frame]) - NIProjectWindow_buttonBarHeight)];

			[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
			[scrollView setHasHorizontalScroller: NO];

		var navigatorTable = [[CPOutlineView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth([scrollView frame]), 
																				  CGRectGetHeight([scrollView frame]))];

			[navigatorTable setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

			// zapewnia rozszeżenie sie pierwszej kolumny!
			[navigatorTable setColumnAutoresizingStyle:CPTableViewFirstColumnOnlyAutoresizingStyle];
			// ustaw styl podświetlania rekordu
			[navigatorTable setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleSourceList];

			[navigatorTable setVerticalMotionCanBeginDrag:NO];
			[navigatorTable setAllowsMultipleSelection:NO];

			[navigatorTable setRowHeight:20.0];

			// tworzenie kolumny "Nazwa pliku"
			var column = [[CPTableColumn alloc] initWithIdentifier:"filename"];
				[[column headerView] setStringValue:"Nazwa"]; 
			
			[navigatorTable addTableColumn:column];
			[navigatorTable setOutlineTableColumn:column];

		[scrollView setDocumentView:navigatorTable];
		[self addSubview:scrollView];
		
		
		
		buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, 
																  CGRectGetHeight([self frame]) - NIProjectWindow_buttonBarHeight,
																  CGRectGetWidth([self frame]), 
																  NIProjectWindow_buttonBarHeight)];

		[buttonBar setAutoresizingMask: CPViewWidthSizable | CPViewMinYMargin];

		// +
		plusButton = [NIButton plusButton];

		// Opcje
		optionsButton = [CPButtonBar actionPopupButton];		
			var item = [[CPMenuItem alloc] init];
				[item setTitle:@"Edytuj"];
				[item setTag:@"edit"];
			[optionsButton addItem:item];
		
			var item = [[CPMenuItem alloc] init];
				[item setTitle:@"Usuń"];
				[item setTag:@"delete"];
			[optionsButton addItem:item];		
		
		var buttons = [
			plusButton,
			optionsButton
		];

		[buttonBar setButtons:buttons];
		[self addSubview:buttonBar];
	}
	return self;
}

@end