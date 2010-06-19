@import <AppKit/CPPanel.j>


@implementation NIFileExplorerPanel : CPPanel
{
	CPOutlineView fileExplorerTable @accessors(readonly);
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

		[self setTitle:@"Przeglądaj plik"];
		[self center];
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];

		fileExplorerTable = [[CPOutlineView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
																   								   
		//[fileExplorerTable setDelegate:self];
		[fileExplorerTable setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
		[fileExplorerTable setRowHeight:26.0];
//		[fileExplorerTable setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
//		[fileExplorerTable setVerticalMotionCanBeginDrag:YES];
		
			var column = [[CPTableColumn alloc] initWithIdentifier:"path"];
			[[column headerView] setStringValue:"Nazwa katalogu"];

			[column setWidth:220.0];
			[column setMinWidth:220.0];
			[column setEditable:NO];
			[column setDataView:[CPTextField new]];
			[fileExplorerTable addTableColumn:column];
			[fileExplorerTable setOutlineTableColumn:column];
			
			
//			[fileExplorerTable addTableColumn:[[CPTableColumn alloc] initWithIdentifier:@"Two"]];

		[contentView addSubview:fileExplorerTable];
		
//		[tableView sizeLastColumnToFit];
//		[fileExplorerTable setDataSource: [OutlineDataSource new]];
//		[fileExplorerTable expandItem:nil expandChildren:NO];
	}
	return self;
}

@end
