@import <AppKit/CPPanel.j>

@implementation FolderView : CPView 
{
	CPTextField  _textField;
}

- (void)setObjectValue:(CPString)aValue   
{                           
	console.log('666666');
	if (nil == _textField) {
		[CPTextField initWithTitle:aValue];
		[self addSubview:_textField];
	} else {
		[_textField setObjectValue:aValue];
	}
}

@end         

var FolderViewText = @"FolderViewText";

@implementation FolderView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self setObjectValue:[aCoder decodeObjectForKey:FolderViewText]];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_textField forKey:FolderViewText];
}

@end

@implementation NIFileExplorerPanel : CPPanel
{
	CPOutlineView _fileExplorerTable @accessors(readonly, property=fileExplorerTable);
	CPButton _okButton @accessors(readonly, property=okButton);
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,400,250) 
							styleMask:CPDocModalWindowMask |
									  CPClosableWindowMask |
									  CPHUDBackgroundWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self setTitle:@"Przeglądaj pliki"];
		[self center];
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];
		
		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame)  - 35)];

		_fileExplorerTable = [[CPOutlineView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
																   								   
		//[_fileExplorerTable setDelegate:self];

		// zapewnia rozszeżenie sie pierwszej kolumny!
		[_fileExplorerTable setColumnAutoresizingStyle:CPTableViewFirstColumnOnlyAutoresizingStyle];
		// ustaw styl podświetlania rekordu
		[_fileExplorerTable setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleSourceList];
//		// ustaw linie poziomą rodzielającą poszczególne wiersze
//		[_fileExplorerTable setGridStyleMask:CPTableViewSolidHorizontalGridLineMask];

		[_fileExplorerTable setVerticalMotionCanBeginDrag:NO];
		[_fileExplorerTable setAllowsMultipleSelection:NO];

		[_fileExplorerTable setRowHeight:16.0];

			// tworzenie kolumny "Nazwa pliku"
			var column = [[CPTableColumn alloc] initWithIdentifier:"filename"];
			[[column headerView] setStringValue:"Nazwa"];
//			[column setWidth:220.0];
//			[column setMinWidth:20.0];
//			[column setMaxWidth: 200.0];
//			[column setEditable:NO];
			   
			// var dataview = [[CPTextField alloc] init];
			// 			[dataview setFont:[CPFont systemFontOfSize:99]];
			// 			[dataview setTextColor:[CPColor blueColor]]; 
			// 			[[column headerView] setDataView:dataview];   
			
			[_fileExplorerTable addTableColumn:column];
			[_fileExplorerTable setOutlineTableColumn:column];    
			
			// tworzenie kolumny - "Rodzaj"
			// var column = [[CPTableColumn alloc] initWithIdentifier:"filetype"];
			// 			[[column headerView] setStringValue:"Rodzaj"];                              
			// 			[column setMinWidth:20.0];
			// 			[column setMaxWidth: 80.0];
			// 			[_fileExplorerTable addTableColumn:column];
			
//			[_fileExplorerTable addTableColumn:[[CPTableColumn alloc] initWithIdentifier:@"Two"]];
			
		[scrollView setDocumentView:_fileExplorerTable];
		[contentView addSubview:scrollView];

//		[_fileExplorerTable setDataSource: [OutlineDataSource new]];
//		[_fileExplorerTable expandItem:nil expandChildren:NO];

		_okButton = [CPButton buttonWithTitle:"OK"];
		//[loginButton setFont:[CPFont systemFontOfSize:18]];
		[_okButton setDefaultButton:YES];
		//[loginButton setBezelStyle:CPHUDBezelStyle];
		//[loginButton setThemeState:CPBackgroundButtonMask];
//		[_okButton setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
		[_okButton sizeToFit];

		var myButtonSize = [_okButton frame];
//		console.log(myButtonSize, CGRectGetHeight(myButtonSize),CGRectGetWidth(myButtonSize));

		// ustaw położenie w lewym dolnym roku!
		[_okButton setFrameOrigin:CGPointMake(CGRectGetMaxX(frame) - CGRectGetWidth(myButtonSize), 
												CGRectGetMaxY(frame) - 35 - CGRectGetHeight(myButtonSize))];
		[_okButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
//		[_okButton setAction:@selector(testConnection:)];
//		[_okButton setTarget:[self windowController]];
		[contentView addSubview:_okButton];	
	}
	return self;
}

@end
