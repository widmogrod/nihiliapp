@import <AppKit/CPWindowController.j>

@import "NIFileExplorerPanel.j"



var SharedFileExplorerController = nil;

@implementation NIFileExplorerController : CPWindowController
{
	//NIFTPConnection _connection @accessors(readoly);
	
	@outlet CPOutlineTable _fileExplorerTable(property=fileExplorerTable);
	CPArray _dataSource;
}

+ (NIFileExplorerController)sharedController
{
	if (!SharedFileExplorerController)
		SharedFileExplorerController = [[NIFileExplorerController alloc] init];

	return SharedFileExplorerController;
}

- (id)init
{
	var fileExplorerPanel = [[NIFileExplorerPanel alloc] init];
	self = [super initWithWindow:fileExplorerPanel];

	if (self)
	{
		_fileExplorerTable = [fileExplorerPanel fileExplorerTable];
		[_fileExplorerTable setDataSource:self];
		[_fileExplorerTable setDelegate:self];
	}
	return self;
}

/*
	Przekazany obiekt połączenia jest inicjonowany
*/
- (void)setConnection:(VOConnection)aConnection
{
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:aConnection];
	[ftp action:@"ls" delegate:self selector:@selector(didReciveData:)];

	[[self window] orderFront:self];
}

- (void)didReciveData:(CPDictionary)aResponse
{
	console.log("didReciveData", aResponse);
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		_dataSource = [aResponse valueForKey:@"result"];
		[_fileExplorerTable reloadData];
	}
	
}

- (void)outlineViewSelectionDidChange:(id)sender
{
	console.log("outlineViewSelectionDidChange:");
}

@end

@implementation NIFileExplorerObject : CPObject
{
	CPString _filename @accessors(readonly, property=filename);
}

- (id)initWithObject:(Object)anObject
{
	_filename = anObject.filename;
}

- (CPString)description
{
	return _filename;
}

@end

/*
	Kategoria reprezentująca
*/
@implementation NIFileExplorerController (CPOutlineDataSource)

- (id)outlineView:(CPOutlineView)anOutlineView  child:(int)aChild   ofItem:(id)anItem
{
	console.log("child", aChild, anItem);

	if (!anItem)
	{
		return [_dataSource objectAtIndex:aChild];
	}

	// TODO: napisać dzieciątka ;)
//	return anItem.childrens[aChild];
}

-(BOOL)outlineView:(CPOutlineView)anOutlineView  isItemExpandable:(id)anItem
{
	console.log("isItemExpandable", anItem, [anItem valueForKey:@"filetype"] == "DIR" && [anItem valueForKey:@"filesize"] > 0);

	if (!anItem)
		return NO;

	// rezszeżalne są tylko katalogi, które mają jakieś pliki w sobie...
	return [anItem valueForKey:@"filetype"] == "DIR" && [anItem valueForKey:@"filesize"] > 0;
}

- (int)outlineView:(CPOutlineView)anOutlineView  numberOfChildrenOfItem:(id)anItem
{
	console.log("numberOfChildrenOfItem", anItem);

	if (!anItem)
		return [_dataSource count];

	// tylko katalog ale to jest już załatwione 
	// w @see outlineView:isItemExpandable:
	return [anItem valueForKey:@"filesize"];
}

- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	var identifier = [aColumn identifier];
	return [anItem valueForKey:identifier];
}

- (id)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var outlineView = [aNotification object];
	var item = [outlineView itemAtRow:[outlineView selectedRow]];
	
	console.log("outlineViewSelectionDidChange", item, [outlineView selectedRow]);
}

@end
