@import <AppKit/CPWindowController.j>

@import "NIFileExplorerPanel.j"
@import "../Models/NIFTPConnection.j"


var SharedFileExplorerController = nil;

@implementation NIFileExplorerController : CPWindowController
{
	//NIFTPConnection _connection @accessors(readoly);
	
	@outlet CPOutlineTable fileExplorerTable;
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
		fileExplorerTable = [fileExplorerPanel fileExplorerTable];

		[fileExplorerPanel orderFront:self];
	}
	return self;
}

/*
	Ustaw dane do połączenia z serwerem
*/
- (void) connectToServer:(CPString)aServer 
			   username:(CPString)anUsername 
			   password:(CPString)aPassword 
//			   	   path:(CPStrong)aPath
{
	[[NIFTPConnection connectionToServer:aServer username:anUsername password:aPassword] connectionWithDelegate:self];
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
		console.log("child", array[aChild]);
		return array[aChild];
	}
		

	return anItem.childrens[aChild];
}

-(BOOL)outlineView:(CPOutlineView)anOutlineView  isItemExpandable:(id)anItem
{
	console.log("isItemExpandable", anItem);
	if (!anItem)
		return NO;

	return !!anItem.childrens;
}

- (int)outlineView:(CPOutlineView)anOutlineView  numberOfChildrenOfItem:(id)anItem
{
	console.log("numberOfChildrenOfItem", anItem);
	if (!anItem)
	{
		console.log("numberOfChildrenOfItem", array.length);
		return array.length;
	}
		
	return anItem.childrens.length;
}

- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	console.log("objectValueForTableColumn", aColumn, anItem);
	return array[anItem];
}

@end

/*
	Kategoria reprezentująca
*/
@implementation NIFileExplorerController (CPURLConnection)

// Called when the connection encounters an error.
-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
	console.log("didFailWithError");
}

// Called when the connection receives a response.
-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
	console.log("didReceiveResponse");
}

// Called when the connection has received data.
-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	console.log("didReceiveData",data);
	if (data.status != @"SUCCESS")
	{
		return;	
	}

//	/_dataSource = data.response;
//	[fileExplorerTable reloadData];
}

// Called when the URL has finished loading.
-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
	console.log("connectionDidFinishLoading");
}

@end
