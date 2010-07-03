@import <AppKit/CPPanel.j>

//var SharedSitePanel = nil;

var NISitePanelWidth = 400.0,
	NISitePanelHeight = 250.0,
	NISitePanelViewConntentSpacing = 10.0,
	
	NISitePanelVerticalFieldsSpacing = 10.0,
	NISitePanelHorizontalFieldsSpacing = 30.0
	
	NISitePanelLabelWight = 120.0,
	NISitePanelValueWight = NISitePanelWidth - NISitePanelLabelWight - (2 * NISitePanelViewConntentSpacing) - NISitePanelVerticalFieldsSpacing;
	
	NISitePanelLabelHeight = 30.0,
	NISitePanelValueHeight = 30.0;

/*
	Panel strony - zarządza danymi strony|projektu tj.
	- FTP
	- nazwa użytkownika
	- hasło użytkownika
	- katalog aplikacji!
*/
@implementation NISitePanel : CPPanel
{
	CPTextField _serverField @accessors(readonly, property=serverField);
	CPTextField _usernameField @accessors(readonly, property=usernameField);
	CPTextField _passwordField @accessors(readonly, property=passwordField);
	CPTextField	_pathnameField @accessors(readonly, property=pathnameField);
	CPTextField _protocolField @accessors(readonly, property=protocolField);
	
	CPTableView tableView;
	CPOutlineView outlineView;
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0, NISitePanelWidth, NISitePanelHeight) 
							styleMask:CPDocModalWindowMask |
									  CPClosableWindowMask |
									  CPHUDBackgroundWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self setTitle:@"Konfigurowanie połączenia"];
		[self center];
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];

		// Server
		var serverFieldLabel = [self _createLabelWithTitle:@"Nazwa serwera" frame:frame];
		[contentView addSubview:serverFieldLabel];

		_serverField = [self _createValueWithPlaceholderString:@"ftp.example.com (wymagane)" frame:frame];
		[contentView addSubview:_serverField];
		
		frame = [_serverField frame];

		
		// Nazwa użytkownika
		var usernameFieldLabel = [self _createLabelWithTitle:@"Nazwa użytkownika" frame:frame];
		[contentView addSubview:usernameFieldLabel];

		_usernameField = [self _createValueWithPlaceholderString:@"(wymagane)" frame:frame];
		[contentView addSubview:_usernameField];
		
		frame = [_usernameField frame];
		
		
		// Hasło
		var passwordFieldLabel = [self _createLabelWithTitle:@"Hasło" frame:frame];
		[contentView addSubview:passwordFieldLabel];

		_passwordField = [self _createValueWithPlaceholderString:@"" frame:frame];
		[_passwordField setSecure:YES];
		[contentView addSubview:_passwordField];
		
		frame = [_passwordField frame];
		
		
		// Katalog/ścieżka
		var pathnameFieldLabel = [self _createLabelWithTitle:@"Katalog/ścieżka" frame:frame];
		[contentView addSubview:pathnameFieldLabel];

		_pathnameField = [self _createValueWithPlaceholderString:@"" frame:frame];
		// mały odstęp od lewej - miejsce na przycisk "Wybierz katalog"
		[_pathnameField setFrameSize:CGSizeMake(CGRectGetWidth([_pathnameField frame]) - 60,
											   CGRectGetHeight([_pathnameField frame]))];
		[contentView addSubview:_pathnameField];

		frame = [_pathnameField frame];
		
		
		// Wybierz katalog
		var choseDirectoryButton = [CPButton buttonWithTitle:"Wybierz"];
		[choseDirectoryButton setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
		[choseDirectoryButton setFrameOrigin: CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
		[choseDirectoryButton setAction:@selector(choseDirectory:)]
		[choseDirectoryButton setTarget:[self windowController]];
		[contentView addSubview:choseDirectoryButton];
		

		// Protokuł
		var protocolFieldLabel = [self _createLabelWithTitle:@"Protokuł" frame:frame];
		[contentView addSubview:protocolFieldLabel];

		_protocolField = [[CPPopUpButton alloc] initWithFrame:[self _frameForValue:frame]];
		[_protocolField addItemWithTitle:@"FTP"];
		[_protocolField sizeToFit];
		[contentView addSubview:_protocolField];
		
		var checkButton = [CPButton buttonWithTitle:"Sprawdź połączenie"];
		//[loginButton setFont:[CPFont systemFontOfSize:18]];
//		[checkButton setDefaultButton:YES];
		//[loginButton setBezelStyle:CPHUDBezelStyle];
		//[loginButton setThemeState:CPBackgroundButtonMask];
//		[checkButton setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
		[checkButton sizeToFit];
		
		// ustaw położenie w lewym dolnym roku!
		[checkButton setFrameOrigin:CGPointMake(CGRectGetMaxX([contentView frame]) - CGRectGetWidth([checkButton frame]) - NISitePanelViewConntentSpacing, 
												CGRectGetMaxY([contentView frame]) - CGRectGetHeight([checkButton frame]) - 4 * NISitePanelViewConntentSpacing)];

		[checkButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
		[checkButton setAction:@selector(testConnection:)];
		[checkButton setTarget:[self windowController]];
		[contentView addSubview:checkButton];
		
		var checkFrame = [checkButton frame];

//		tableView = [[CPTableView alloc]  initWithFrame:CGRectMake(CGRectGetMinX(passwordFrame), 
//																	CGRectGetMinY(passwordFrame) + 10 + fieldHeight,
//																	CGRectGetWidth(passwordFrame),
//																	100)];
//																   								   
//		[tableView setDelegate:self];
//		[tableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
//		[tableView setRowHeight:26.0];
//		[tableView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
//		[tableView setVerticalMotionCanBeginDrag:YES];
//		
//			var column = [[CPTableColumn alloc] initWithIdentifier:"path"];
//			[[column headerView] setStringValue:"Katalog"];

//			[column setWidth:220.0];
//			[column setMinWidth:220.0];
//			[column setEditable:YES];
//			[column setDataView:[CPTextField new]];
//			[tableView addTableColumn:column];

////		[contentView addSubview:tableView];
//		
////		[tableView sizeLastColumnToFit];
//		[tableView setDataSource: [TableDataSource new]];

/////////////////////////////////////


//		outlineView = [[CPOutlineView alloc] initWithFrame:CGRectMake(CGRectGetMinX(checkFrame), 
//																	CGRectGetMinY(checkFrame) + 10 + fieldHeight,
//																	CGRectGetWidth(checkFrame),
//																	300)];
//																   								   
//		[outlineView setDelegate:self];
//		[outlineView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
//		[outlineView setRowHeight:26.0];
////		[outlineView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
////		[outlineView setVerticalMotionCanBeginDrag:YES];
//		
//			var column = [[CPTableColumn alloc] initWithIdentifier:"path"];
//			[[column headerView] setStringValue:"Katalog"];

//			[column setWidth:220.0];
//			[column setMinWidth:220.0];
//			[column setEditable:NO];
//			[column setDataView:[CPTextField new]];
//			[outlineView addTableColumn:column];
//			[outlineView setOutlineTableColumn:column];
//			
//			
////			[outlineView addTableColumn:[[CPTableColumn alloc] initWithIdentifier:@"Two"]];

//		[contentView addSubview:outlineView];
//		
////		[tableView sizeLastColumnToFit];
//		[outlineView setDataSource: [OutlineDataSource new]];
//		[outlineView expandItem:nil expandChildren:NO];

/////////////////////////////////////

//	_outlineView = [[CPOutlineView alloc] initWithFrame:[contentView bounds]];
//    
//    var column = [[CPTableColumn alloc] initWithIdentifier:@"One"];
//    [_outlineView addTableColumn:column];
//    [_outlineView setOutlineTableColumn:column];
//    
//    [_outlineView addTableColumn:[[CPTableColumn alloc] initWithIdentifier:@"Two"]];

//    [_outlineView registerForDraggedTypes:[CustomOutlineViewDragType]];
//    
//    [_outlineView setDataSource:self];
//    [_outlineView setAllowsMultipleSelection:YES];
//    [_outlineView expandItem:nil expandChildren:YES];
//	// [_outlineView setRowHeight:50.0];
//    // [_outlineView setIntercellSpacing:CPSizeMake(0.0, 10.0)]

/////////////////////////////////////



//		var loginButton = [CPButton buttonWithTitle:"Zaloguj"];
//		//[loginButton setFont:[CPFont systemFontOfSize:18]];
//		//[loginButton setDefaultButton:YES];
//		//[loginButton setBezelStyle:CPHUDBezelStyle];
//		//[loginButton setThemeState:CPBackgroundButtonMask];
//		[loginButton setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
//		[loginButton sizeToFit];
//		// ustaw położenie w lewym dolnym roku!
//		[loginButton setFrameOrigin:CGPointMake(CGRectGetMinX(frame) - 10, 
//												CGRectGetMaxY(frame) - 30 - CGRectGetHeight([loginButton frame]))];
//		[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
//		[loginButton setAction:@selector(login:)];
//		[loginButton setTarget:self];
//		[contentView addSubview:loginButton];
	}
	
	return self;
}


//numberOfRowsInTableView:
//tableView:objectValueForTableColumn:row:


- (id)login:(id)sender
{
	console.log([usernameField stringValue]);
	console.log([passwordField stringValue]);
	console.log([tableView selectedRow])
	[self close];
}

//+ (id)sharedPanel
//{
//	if (!SharedSitePanel)
//		SharedSitePanel = [[NISitePanel alloc] init];

//	return SharedSitePanel;
//}

- (BOOL)canBecomeMainWindow
{
	return YES;
}

@end



/*
	Kategoria zawiera methody pomocnicze
	do obliczania CGRect
*/
@implementation NISitePanel (FrameHelper)

/*
	Obliczanie położenia elementu z etykietą pola tekstowego.
	- jedyną zmienną jest wysokość
*/
- (CGRect)_frameForLabel:(CGRect)aFrame
{
	return CGRectMake(NISitePanelViewConntentSpacing, 
					  CGRectGetMinY(aFrame) + NISitePanelHorizontalFieldsSpacing,
					  NISitePanelLabelWight,
					  NISitePanelLabelHeight);
}

/*
	Obliczanie położenia elementu z wartością pola tekstowego
	- jedyną zmienną jest wysokość
*/
- (CGRect)_frameForValue:(CGRect)aFrame
{
	return CGRectMake(NISitePanelViewConntentSpacing + NISitePanelLabelWight + NISitePanelVerticalFieldsSpacing, 
					  CGRectGetMinY(aFrame) + NISitePanelHorizontalFieldsSpacing,
					  NISitePanelValueWight,
					  NISitePanelValueHeight);
}

@end


/*
	Kategoria grupuje metody tworzące elementy formularza
	- etykieta - CPTextField
	- wartość - CPTextField
*/
@implementation NISitePanel (TextFieldHelper)

/*!
	Tworzenie etykiety!
*/
- (void)_createLabelWithTitle:(CPString)aTitle frame:(CGRect)aFrame
{
	var label = [[CPTextField alloc] initWithFrame:[self _frameForLabel:aFrame]];

	[label setStringValue:aTitle];
	[label setTextColor:[CPColor whiteColor]];
	[label setAlignment:CPRightTextAlignment];
	
	return label;
}

/*!
	Tworzenie pola tekstowego o nazwie!
*/
- (void)_createValueWithPlaceholderString:(CPString)aPlaceholder frame:(CGRect)aFrame
{
	var label = [[CPTextField alloc] initWithFrame:[self _frameForValue:aFrame]];

	[label setEditable:YES];
	[label setBezeled:YES];
	[label setPlaceholderString:aPlaceholder];
	
	return label;
}

serverField = [[CPTextField alloc] initWithFrame:[self _frameForValue:frame]];
		

@end


@implementation TableDataSource : CPObject
{
	CPArray array;
}

- (id)init
{
	self = [super init];

	if (self)
	{
		array = [
			{name:"Pierwszy"},
			{name:"Drugi"},
			{name:"Trzeci"}
		];
	}
	
	return self;
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return array.length;
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(int)aColumn row:(int)aRow
{
	return array[aRow];
}

@end








@implementation OutlineDataSource : CPObject
{
	CPArray array;
}

- (id)init
{
	self = [super init];

	var o = [CPObject new];
	o.name = "asd";

	if (self)
	{
		array = [
			o,
			[CPObject new],
			[CPObject new]
//			{
//				info:"lalala",
//				name:"Pierwszy",
////				childrens: [
////					{name:"Drugi22", info:"lalala"},
////					{name:"Trzeci22", info:"lalala"}	
////				]
//			},
//			{name:"Drugi", info:"lalala"},
//			{name:"Trzeci", info:"lalala"}
		];
	}
	
	return self;
}

//- (int)numberOfRowsInTableView:(CPOutlineView)anOutlineView
//{
//	console.log("numberOfRowsInTableView", array.length);
//	return array.length;
//}

//- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(int)aColumn row:(int)aRow
//{
//	console.log("objectValueForTableColumn", aColumn, aRow);
//	return array[1];
//}

//- (id)outlineView:(CPOutlineView)theOutlineView child:(int)theIndex ofItem:(id)theItem
- (id)outlineView:(CPOutlineView)anOutlineView  child:(int)aChild   ofItem:(id)anItem
{
	console.log("child", aChild, anItem);
	if (!anItem)
	{
		console.log("child", array[aChild]);
		return array[aChild];
	}
		

	return anItem.childrens[aChild];
}

//-(BOOL)outlineView:(CPOutlineView)theOutlineView isItemExpandable:(id)theItem
-(BOOL)outlineView:(CPOutlineView)anOutlineView  isItemExpandable:(id)anItem
{
	console.log("isItemExpandable", anItem);
	if (!anItem)
		return NO;

	return !!anItem.childrens;
}

//- (int)outlineView:(CPOutlineView)theOutlineView numberOfChildrenOfItem:(id)theItem
- (int)outlineView:(CPOutlineView)anOutlineView  numberOfChildrenOfItem:(id)anItem
{
	console.log("numberOfChildrenOfItem", anItem);
	if (!anItem)
	{
		console.log("numberOfChildrenOfItem", array.length);
		return array.length;
	}
		
//	console.log("numberOfChildrenOfItem", anItem);
	return anItem.childrens.length;
//	return array.length;
}
//- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(CPTableColumn)theColumn byItem:(id)theItem
- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	console.log("objectValueForTableColumn", aColumn, anItem);
	return array[anItem];
}



//- (BOOL)outlineView:(CPOutlineView)anOutlineView writeItems:(CPArray)theItems toPasteboard:(CPPasteBoard)thePasteBoard
//{
//    return YES;
//}

//- (CPDragOperation)outlineView:(CPOutlineView)anOutlineView validateDrop:(id < CPDraggingInfo >)theInfo proposedItem:(id)theItem proposedChildIndex:(int)theIndex
//{
//    return CPDragOperationEvery;
//}

//- (BOOL)outlineView:(CPOutlineView)outlineView acceptDrop:(id < CPDraggingInfo >)theInfo item:(id)theItem childIndex:(int)theIndex
//{
//    return YES;
//}

//- (CPInteger)numberOfRowsInTableView:(CPTableView)anOutlineView
//{
//    return _outlineView._itemsForRows.length;
//}

//- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(CPInteger)aRow
//{
//    return [_outlineView._outlineViewDataSource outlineView:_outlineView objectValueForTableColumn:aTableColumn byItem:_outlineView._itemsForRows[aRow]];
//}




//if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:setObjectValue:forTableColumn:byItem:)])
//00145         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_setObjectValue_forTableColumn_byItem_;
//00146 
//00147     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:shouldDeferDisplayingChildrenOfItem:)])
//00148         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_shouldDeferDisplayingChildrenOfItem_;
//00149 
//00150     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:acceptDrop:item:childIndex:)])
//00151         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_acceptDrop_item_childIndex_;
//00152 
//00153     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:validateDrop:proposedItem:proposedChildIndex:)])
//00154         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_validateDrop_proposedItem_proposedChildIndex_;
//00155 
//00156     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:validateDrop:proposedRow:proposedDropOperation:)])
//00157         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_validateDrop_proposedRow_proposedDropOperation_;
//00158 
//00159     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:namesOfPromisedFilesDroppedAtDestination:forDraggedItems:)])
//00160         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_namesOfPromisedFilesDroppedAtDestination_forDraggedItems_;
//00161 
//00162     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:itemForPersistentObject:)])
//00163         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_itemForPersistentObject_;
//00164 
//00165     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:persistentObjectForItem:)])
//00166         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_persistentObjectForItem_;
//00167 
//00168     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:writeItems:toPasteboard:)])
//00169         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_writeItems_toPasteboard_;
//00170 
//00171     if ([_outlineViewDataSource respondsToSelector:@selector(outlineView:sortDescriptorsDidChange:)])
//00172         _implementedOutlineViewDataSourceMethods |= CPOutlineViewDataSource_outlineView_sortDescriptorsDidChange_;

@end









@implementation TreeView : CPView
{
	CPTextField textField;
}

- (id)init
{
	self = [super initWithFrame:CGRectMakeZero()];

	if (self)
	{
		textField = [[CPTextField alloc] initWithFrame:[self frame]];
		[textField setStringValue:@"tak"];
		[textField setEditable:NO];
		[textField setBezeled:YES];
		[self addSubview:textField];
	}

	return self;
}

- (void)setObjectValue:(Object)anObject
{
//	[self setNeedsDisplay:YES];
//	console.log([self frame],[textField frame]);
    [textField setStringValue:anObject.name];
//    [textField setFrame:[self frame]];
//    [textField sizeToFit];
//    [textField setNeedsDisplay:YES];
    
//	console.log([textField frame]);
//    [lockView setHidden:!anObject["private"]];
}
