@import <AppKit/CPWindowController.j>

@import "NISitePanel.j"
@import "NIFileExplorerController.j"
@import "../Controllers/NIApiController.j"
@import "../Models/NIFTPApi.j"

//@import "../Models/NIFTPConnection.j"
@import "../Models/VOConnection.j"

var SharedSIPanelController = nil;

/*
	Łaczenie interakcji widok, apikacja, server
	Odpowiada za:
	- tworzenie, edycję, usunięcie nowych stron
	- wyświetlanie strukóry katalogów na serwerze
*/
@implementation NISitePanelController : CPWindowController
{
	VOConnection _connection;
}

+ (id)sharedController
{
	if (!SharedSIPanelController)
		SharedSIPanelController = [[NISitePanelController alloc] init];

	return SharedSIPanelController;
}

- (id)init
{
	self = [super initWithWindow:[[NISitePanel alloc] init]];

	if (self)
	{
		[[self window] orderFront:self];
	}
	return self;
}

/*

*/
- (void)addSite:(id)sender
{

}

/*

*/
- (void)editSite:(id)sender
{

}

/*

*/
- (void)deleteSite:(id)sender
{

}

/*
	Otwiera okno wybierania katalogu!
*/
- (void)choseDirectory:(id)sender
{
	[[NIFileExplorerController sharedController] 
				setConnection:[self connection]
				 	   target:[[self window] filepathField] 
				 	   action:@selector(setStringValue:)];
}

/*
	Sprawź połączenie
*/
- (void)testConnection:(id)sender
{
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:[self connection]];
	[ftp testWithDelegate:self selector:@selector(connectionTestComplite:)];
}

// jeżeli jest
- (void)connectionTestComplite:(CPResponse)aResponse
{
	console.log(aResponse);
//	console.log([aResponse objectFromJSON]);
//	aResponse = [aResponse objectFromJSON];
	var alert = [[CPAlert alloc] init];
	[alert setMessageText:[aResponse objectForKey:@"status"]];
	
	if ([aResponse objectForKey:@"status"] == "SUCCESS")
		[alert setAlertStyle:CPInformationalAlertStyle];
	else  
		[alert setAlertStyle:CPWarningAlertStyle];
	
	[alert runModal];
	
//	console.log(aResponse);
}

/*
	Ustawia obiekt połączenia
*/
- (void)setConnection:(VOConnection)aConnection
{
	if (!aConnection) {
		_connection = nil;
		return;
	}

	if (_connection == aConnection)
		return;

	[[[self window] serverField]   setStringValue:aConnection server];
	[[[self window] usernameField] setStringValue:aConnection username];
	[[[self window] passwordField] setStringValue:aConnection password];
	[[[self window] pathnameField] setStringValue:aConnection pathname];
//	[[[self window] protocolField] setStringValue:aConnection protocol];
	
	_connection = aConnection;
}

/*
	Pobierz obiekt połączenia.
	- Obiekt jeżeli był wcześniej ustawiony jest zwracany
	  jako obiekt referencyjny a nie jako nowy obiekt!
*/
- (VOConnection)connection
{
	if (!_connection)
		_connection = [[VOConnection alloc] init];

	[_connection setServer:   [[[self window] serverField] stringValue]];
	[_connection setUsername: [[[self window] usernameField] stringValue]];
	[_connection setPassword: [[[self window] passwordField] stringValue]];
	[_connection setPathname: [[[self window] pathnameField] stringValue]];
	[_connection setProtocol: [[[[self window] protocolField] selectedItem] title]];
	
	return _connection;
}

@end
