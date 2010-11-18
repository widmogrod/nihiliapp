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
	
	// wyczyść dane w oknie
	[[[self window] textarea] setObjectValue:@""];
	
	// wczytaj nowe dane
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:_connection];
	[ftp action:@"get" delegate:self selector:@selector(didReciveContentFileData:)];

	[[self window] orderFront:self];
}

@end


/*
	Delegacje z @see NIFTPApi.
*/
@implementation NIPreviewController (ConnectionDelegations)

- (void)didReciveContentFileData:(CPDictionary)aResponse
{
	CPLog.debug(@"didReciveContentFileData:");
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		var result = [aResponse valueForKey:@"result"];
		[[[self window] textarea] setObjectValue:result];
	} else {
		[[NIAlert alertWithResponse:aResponse] runModal];
	}
}

- (void)didSaveContentData:(CPDictionary)aResponse
{
	CPLog.debug(@"didSaveContentData:");
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		[[[self window] plusButton] setTitle:@"Zapisz"];
	} else {
		[[NIAlert alertWithResponse:aResponse] runModal];
	}
}

@end


/*
	Implementacja logiki akcji dla kontrolera podglądu aplikacji.
*/
@implementation NIPreviewController (TargetAction)

- (void)performSave:(id)sender
{
	[sender setTitle:@"Zapisuję..."];
	
	[_connection setContent: 	[[[self window] textarea] objectValue]];
	
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:_connection];
	[ftp action:@"put" delegate:self selector:@selector(didSaveContentData:)];

	[[self window] orderFront:self];
}

@end