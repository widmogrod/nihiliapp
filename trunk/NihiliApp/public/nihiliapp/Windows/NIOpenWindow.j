@import <AppKit/CPWindow.j>
@import <AppKit/CPTableView.j>
@import <AppKit/CPButton.j>
@import <AppKit/CPButtonBar.j>
@import "../NIButton.j"

var SharedOpenWindow = nil;

/*
	Okno otwierania stron internetowych, 
	za jego pomocą można wywołać następujące akcje:
	- TODO: dodawanie nowego projektu
	- TODO: usuwanie istniejącego projektu
	- TODO: zarządzanie usawieniami projektu
	- TODO: zmiana nazwy projektu
	- TODO: zmiana kolejności projektów
*/
@implementation NIOpenWindow : CPWindow
{
	CPButton plusButton @accessors;
	CPButton minusButton;
	CPButton penButton @accessors;
	CPPopUpButton popUpButton @accessors;
	
	CPTableView _tableView @accessors(getter=tableView);
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,500,350) styleMask:CPTitledWindowMask | CPClosableWindowMask | CPResizableWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Otwórz stronę internetową"];
		

		var buttonBarHeight = 25;
		
		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0,
																		CGRectGetWidth(frame), 
																		CGRectGetHeight(frame)  - buttonBarHeight)];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[scrollView setHasHorizontalScroller: NO];
		
		_tableView = [[CPTableView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		[_tableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		// zapewnia rozszeżenie sie pierwszej kolumny!
		[_tableView setColumnAutoresizingStyle:CPTableViewFirstColumnOnlyAutoresizingStyle];
		// ustaw styl podświetlania rekordu
		[_tableView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleSourceList];
		// ustaw linie poziomą rodzielającą poszczególne wiersze
		// [_tableView setGridStyleMask:CPTableViewSolidHorizontalGridLineMask];

		[_tableView setVerticalMotionCanBeginDrag:NO];
		[_tableView setAllowsMultipleSelection:NO];

		[_tableView setRowHeight:20.0];

			// tworzenie kolumny "Nazwa pliku"
			var column = [[CPTableColumn alloc] initWithIdentifier:"server"];
			[[column headerView] setStringValue:"Serwer"];
//			[column setWidth:220.0];
//			[column setMinWidth:20.0];
//			[column setMaxWidth: 200.0];
//			[column setEditable:NO];
			   
			// var dataview = [[CPTextField alloc] init];
			// 			[dataview setFont:[CPFont systemFontOfSize:99]];
			// 			[dataview setTextColor:[CPColor blueColor]]; 
			// 			[[column headerView] setDataView:dataview];   
			
			[_tableView addTableColumn:column];
			//[_tableView setOutlineTableColumn:column];
		
		
		[scrollView setDocumentView:_tableView];
		[contentView addSubview:scrollView];
		
		var buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - buttonBarHeight,
																	 CGRectGetWidth(frame), buttonBarHeight)];

		[buttonBar setAutoresizingMask: CPViewWidthSizable | CPViewMinYMargin];
		
		// Rozwijane menu
		popUpButton = [CPButtonBar actionPopupButton];
		
		var item = [[CPMenuItem alloc] init];
			[item setTitle:@"Dodaj"];
			[item setTag:@"add"];
		[popUpButton addItem:item];

		var item = [[CPMenuItem alloc] init];
			[item setTitle:@"Edytuj"];
			[item setTag:@"edit"];
		[popUpButton addItem:item];
		
		var item = [[CPMenuItem alloc] init];
			[item setTitle:@"Usuń"];
			[item setTag:@"delete"];
		[popUpButton addItem:item];

		
		// plusButton = [CPButtonBar plusButton];
		// minusButton = [CPButtonBar minusButton];

		var searchField = [[CPSearchField alloc] initWithFrame: CGRectMake(160,30,250,30)];
			[searchField setBordered: NO];
			[searchField setBezeled: NO];
			
		// var sliderField = [[CPSlider alloc] initWithFrame: CGRectMake(20,30,100,25)];
		// 		// [sliderField setBezeled:NO];
		// 		// [sliderField setBordered: NO];
		// 		[sliderField setMinValue:0];
		// 		[sliderField setMaxValue:100];
		// 		
		// 		var disclosureButton = [[CPDisclosureButton alloc] initWithFrame: CGRectMake(20, 60, 50, 25)];
		// 		[disclosureButton setTitle:@"Jka"];
		// 		
		// 		[contentView addSubview:disclosureButton];
		// 		
		// 		var popUpButton2 = [[CPPopUpButton alloc] initWithFrame: CGRectMake(20, 110, 50,50)];
		// 		[popUpButton2 addItemWithTitle:@"Jak się masz"];
		// 		
		// 		[contentView addSubview: popUpButton2];
		// 		
		// 		var segmentedControl = [[CPSegmentedControl alloc] initWithFrame: CGRectMake(0, 140, 200, 35)];
		// 		[segmentedControl setSegmentCount:2];
		// 		[segmentedControl setLabel:@"Lala" forSegment:0];
		// 		[segmentedControl setLabel:@"Bababa" forSegment:1];
		// 		
		// 		[contentView addSubview: segmentedControl];

		penButton = [NIButton penButton];
		plusButton = [NIButton plusButton];
		minusButton = [NIButton minusButton];

					
		var buttons = [
			plusButton,
			// minusButton,
			// penButton,
			popUpButton,
			searchField
			// sliderField
		];

		[buttonBar setButtons:buttons];
		[contentView addSubview:buttonBar];
		
		// [contentView addSubview:searchField];
		// [contentView addSubview:sliderField];
	}
	
	return self;
}

+ (id)sharedOpenWindow
{
	if (!SharedOpenWindow)
		SharedOpenWindow = [[NIOpenWindow alloc] init];

	return SharedOpenWindow;
}

@end

@implementation NIOpenWindow (Actions)

- (void)openSetting:(id)sender
{
	
}

- (void)rename:(id)sender
{
	
}

@end
