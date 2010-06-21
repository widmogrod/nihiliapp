@import <AppKit/CPPanel.j>


@implementation NIFileExplorerPanel : CPPanel
{
	CPOutlineView _fileExplorerTable @accessors(readonly, property=fileExplorerTable);
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

		_fileExplorerTable = [[CPOutlineView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
																   								   
		//[_fileExplorerTable setDelegate:self];
		[_fileExplorerTable setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
		[_fileExplorerTable setRowHeight:26.0];
		[_fileExplorerTable setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
		[_fileExplorerTable setVerticalMotionCanBeginDrag:YES];
		
			var column = [[CPTableColumn alloc] initWithIdentifier:"filename"];
			[[column headerView] setStringValue:"Nazwa katalogu"];

			[column setWidth:220.0];
			[column setMinWidth:20.0];
//			[column setEditable:NO];
//			[column setDataView:[CPTextField new]];
			[_fileExplorerTable addTableColumn:column];
			[_fileExplorerTable setOutlineTableColumn:column];
			
			
//			[_fileExplorerTable addTableColumn:[[CPTableColumn alloc] initWithIdentifier:@"Two"]];

		[contentView addSubview:_fileExplorerTable];
		//[column setWidth:CPRectGetWidth([_fileExplorerTable bounds])];
		
//		[tableView sizeLastColumnToFit];
//		[_fileExplorerTable setDataSource: [OutlineDataSource new]];
//		[_fileExplorerTable expandItem:nil expandChildren:NO];
	}
	return self;
	
//	
//	
// _outlineView = [[CPOutlineView alloc] initWithFrame:[contentView bounds]];
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
//    
//    [scrollView setDocumentView:_outlineView];
//    [theWindow setContentView:scrollView];

//    // [theWindow setContentView:_outlineView];

//    [theWindow orderFront:self];

//    
}

@end
