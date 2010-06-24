@import <AppKit/CPWindowController.j>

@import "NIFileExplorerPanel.j"
@import "../Models/NIFTPConnection.j"


var SharedFileExplorerController = nil;

@implementation NIFileExplorerController : CPWindowController
{
	//NIFTPConnection _connection @accessors(readoly);
	
	@outlet CPOutlineTable fileExplorerTable;
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
		fileExplorerTable = [fileExplorerPanel fileExplorerTable];
		[fileExplorerTable setDataSource:self];
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
	console.log(@"start 1", aServer);
	_dataSource = [
		{
			'filename':"Pierwszy plik 1"
		},
		{
			'filename':"Drugi plik"
		},
		{
			'filename':"Trzeci plik"
		}
	];
	
	[fileExplorerTable reloadData];
	console.log(@"end 1");

	var conn = [NIFTPConnection connectionToServer:aServer username:anUsername password:aPassword];
	[conn setConnectionType:"ftp"];
	[conn connectionWithDelegate:self];
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
		//console.log("child", _dataSource[aChild]);
		
		// TODO: Dodać obwiniecie rekordu z CPObject?
		
		// TODO: natywny objekt JS ma problem z description
//		console.log([_dataSource[aChild] description]);
		
//		var object = [[NIFileExplorerObject alloc] initWithObject:_dataSource[aChild]];
		return _dataSource[aChild]["filename"];
//		return object;
		
//		return null;
	}
		

//	return anItem.childrens[aChild];
}

-(BOOL)outlineView:(CPOutlineView)anOutlineView  isItemExpandable:(id)anItem
{
	console.log("isItemExpandable", anItem, !!anItem.files);
//	if (!anItem)
		return NO;

	return !!anItem.files;
}

- (int)outlineView:(CPOutlineView)anOutlineView  numberOfChildrenOfItem:(id)anItem
{
	console.log("numberOfChildrenOfItem", anItem);
	if (!anItem)
	{
		console.log("numberOfChildrenOfItem", [_dataSource count]);
		return [_dataSource count];
	}
		
//	return anItem.childrens.length;
}

- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	console.log("objectValueForTableColumn", aColumn, anItem);
	var identifier = [aColumn identifier];
	console.log("objectValueForTableColumn-identifer:", identifier);
	
	return anItem;
//	return _dataSource[anItem];
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
	data = [data objectFromJSON];
	console.log("didReceiveData",data);
	if (data.status != @"SUCCESS")
	{
		return;	
	}

// CPTree ??
	_dataSource = data.result;
	
//	_dataSource = [
//		@"Raz",
//		@"Dwa",
//		@"Trzy",
////		[CPObject new],
////		[CPObject new]

////		[CPTreeNode treeNodeWithRepresentedObject:{
////			type: "DIR",
////			name: "httpdocs",
////			path: "Ścieżka dostępu do pliku",
////			info: {
////				group:"root"
////			}
////		}]
//	];
	console.log("_dataSource", _dataSource);
	[fileExplorerTable reloadData];
//	[outlineView expandItem:nil expandChildren:NO];
}

// Called when the URL has finished loading.
-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
	console.log("connectionDidFinishLoading");
}

@end
