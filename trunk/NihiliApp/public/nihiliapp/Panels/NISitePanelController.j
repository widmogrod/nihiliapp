@import <AppKit/CPWindowController.j>

@import "NISitePanel.j"
@import "NIFileExplorerController.j"
@import "../Controllers/NIApiController.j"
@import "../Models/NIFTPConnection.j"
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
	[[[self window] protocolField] setStringValue:aConnection protocol];
	
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

	[connection setServer:   [[[self window] serverField] stringValue]];
	[connection setUsername: [[[self window] usernameField] stringValue]];
	[connection setPassword: [[[self window] passwordField] stringValue]];
	[connection setPathname: [[[self window] pathnameField] stringValue]];
	[connection setProtocol: [[[self window] protocolField] stringValue]];
	
	return _connection = nil;;
}

@end
