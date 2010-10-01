@import <AppKit/CPWindowController.j>

@import "NIPreviewPanel.j"
@import "../Models/NIFTPApi.j"
@import "../Models/VOConnection.j"
@import "NIAlert.j"

var SharedNIPreviewController = nil;

@implementation NIPreviewController : CPWindowController
{
	VOConnection _connection;
}

+ (id)sharedController
{
	if (!SharedNIPreviewController)
		SharedNIPreviewController = [[NIPreviewController alloc] init];

	return SharedNIPreviewController;
}

- (id)init
{
	self = [super initWithWindow:[[NIPreviewPanel alloc] init]];

	if (self)
	{

	}
	return self;
}

- (void)setConnection:(VOConnection)aConnection
{	
	_connection = aConnection;

	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:_connection];
	[ftp action:@"get" delegate:self selector:@selector(didReciveContentFileData:)];

	[[self window] orderFront:self];
}

/*
	Delegacja do tej metody jest ustalona 
	NIFileExplorerController @see outlineView:child:ofItem:
*/
- (void)didReciveContentFileData:(CPDictionary)aResponse
{
	CPLog.debug(@"didReciveContentFileData:");
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		var result = [aResponse valueForKey:@"result"];
		[[[self window] textarea] setObjectValue:result]
	} else {
		[[NIAlert alertWithResponse:aResponse] runModal];
	}
}

@end