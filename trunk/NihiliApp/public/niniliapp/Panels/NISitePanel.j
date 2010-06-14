@import <AppKit/CPPanel.j>

var SharedSitePanel = nil;

/*
	Panel strony - zarządza danymi strony|projektu tj.
	- FTP
	- nazwa użytkownika
	- hasło użytkownika
	- katalog aplikacji!
*/
@implementation NISitePanel : CPPanel
{
	CPTextField hostnameField;
	CPTextField usernameField;
	CPTextField passwordField;
	
	CPTableView tableView;
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,300,400) 
							styleMask:CPDocModalWindowMask |
									  CPClosableWindowMask |
									  CPHUDBackgroundWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];

		var fieldHeight = 29;

		usernameField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame) + 10, 
																	  CGRectGetMinY(frame) + 10,
																	  CGRectGetWidth(frame)-20,
																	  fieldHeight)];
		[usernameField setEditable:YES];
		[usernameField setBezeled:YES];
		[contentView addSubview:usernameField];

		var usernameFrame = [usernameField frame];
		
		passwordField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(usernameFrame), 
																	  CGRectGetMinY(usernameFrame) + 10 + fieldHeight,
																	  CGRectGetWidth(usernameFrame),
																	  fieldHeight)];

		var passwordFrame = [passwordField frame];

		tableView = [[CPTableView alloc]  initWithFrame:CGRectMake(CGRectGetMinX(passwordFrame), 
																	CGRectGetMinY(passwordFrame) + 10 + fieldHeight,
																	CGRectGetWidth(passwordFrame),
																	100)];
																   								   
		[tableView setDelegate:self];
		[tableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
		[tableView setRowHeight:26.0];
		[tableView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
		[tableView setVerticalMotionCanBeginDrag:YES];
		
			var column = [[CPTableColumn alloc] initWithIdentifier:"path"];
			[[column headerView] setStringValue:"Katalog"];

			[column setWidth:220.0];
			[column setMinWidth:220.0];
			[column setEditable:YES];
			[column setDataView:[TreeView new]];
			[tableView addTableColumn:column];

		[contentView addSubview:tableView];
		
//		[tableView sizeLastColumnToFit];
		[tableView setDataSource: [TreeDataSource new]];

		[passwordField setEditable:YES];
		[passwordField setBezeled:YES];
		[contentView addSubview:passwordField];

		var loginButton = [CPButton buttonWithTitle:"Zaloguj"];
		//[loginButton setFont:[CPFont systemFontOfSize:18]];
		//[loginButton setDefaultButton:YES];
		//[loginButton setBezelStyle:CPHUDBezelStyle];
		//[loginButton setThemeState:CPBackgroundButtonMask];
		[loginButton setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
		[loginButton sizeToFit];
		// ustaw położenie w lewym dolnym roku!
		[loginButton setFrameOrigin:CGPointMake(CGRectGetMinX(frame) + 10, 
												CGRectGetMaxY(frame) - 30 - CGRectGetHeight([loginButton frame]))];
		[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
		[loginButton setAction:@selector(login:)];
		[loginButton setTarget:self];
		[contentView addSubview:loginButton];
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

+ (id)sharedPanel
{
	if (!SharedSitePanel)
		SharedSitePanel = [[NISitePanel alloc] init];

	return SharedSitePanel;
}

- (BOOL)canBecomeMainWindow
{
	return YES;
}

@end

@implementation TreeDataSource : CPObject
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

@implementation TreeView : CPView
{
	CPTextField textField;
}

- (id)init
{
	self = [super initWithFrame:CGRectMake(0,0,23,100)];
	
	if (self)
	{
		textField = [[CPTextField alloc] initWithFrame:[self frame]];
		[textField setStringValue:@"tak"];
		[textField setEditable:YES];
		[textField setBezeled:YES];
		[self addSubview:textField];
	}

	return self;
}

- (void)setObjectValue:(Object)anObject
{
    [textField setStringValue:anObject.name];
//    [lockView setHidden:!anObject["private"]];
}
