@import <AppKit/CPWindowController.j>

@import "NIAlert.j"
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

		var testConnection = [[VOConnection alloc] init];
		[testConnection setServer:@"ftp.widmogrod.info"];
		[testConnection setUsername:@"widmogrod"];
		[testConnection setPassword:@"for6ba!"];
		[self setConnection:testConnection];
		
	}
	return self;
}

- (void)setActionButton:(CPButton)aButton
{
	[[self window] setActionButton:aButton];
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
	Do tej metody jest wysyłana wiadomość z @see NISitePanel 
	w celu sprawdzenia czy podane dane są poprane
*/
- (void)testConnection:(id)sender
{
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:[self connection]];
	[ftp action:@"test" delegate:self selector:@selector(testConnectionComplite:)];
}

/*
	Zakończone testowanie połączenia
*/
- (void)testConnectionComplite:(CPResponse)aResponse
{
//	if ([aResponse objectForKey:@"status"] == "FAILURE")
		[[NIAlert alertWithResponse:aResponse] runModal];
}

/*
	Do tej metody jest wysyłana wiadomość z @see NISitePanel 
	by włączyć panel, który umożłiwi wskazanie głównego katalog na serwerze
*/
- (void)choseDirectory:(id)sender
{
	var fileExplorer = [NIFileExplorerController sharedController];
//	[fileExplorer setShowFiles:NIFileExplorerShowDir]; 	// ustawienie flagi pokazu tylko katalogi
	[fileExplorer setConnection:[self connection]];		// przekaż obiekt połączenia
//	[fileExplorer setDelegate:self];
}

- (void)choseDirectoryComplite:(FileInfoVO)aFileInfo
{
	[[[self window] pathnameField] setStringValue:[aFileInfo]];
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

		CPLog.info("[aConnection id]");
		CPLog.info([aConnection id]);

	[[[self window] serverField]   setStringValue:[aConnection server]];
	[[[self window] usernameField] setStringValue:[aConnection username]];
	[[[self window] passwordField] setStringValue:[aConnection password]];
	[[[self window] pathnameField] setStringValue:[aConnection pathname]];
//	[[[self window] protocolField] setStringValue:aConnection protocol];
	
	_connection = aConnection;
	
	[[self window] orderFront:self];
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

		CPLog.info("[_connection id]");
		CPLog.info([_connection id]);


	[_connection setServer:   [[[self window] serverField] stringValue]];
	[_connection setUsername: [[[self window] usernameField] stringValue]];
	[_connection setPassword: [[[self window] passwordField] stringValue]];
	[_connection setPathname: [[[self window] pathnameField] stringValue]];
	[_connection setProtocol: [[[[self window] protocolField] selectedItem] title]];
	
	return _connection;
}

@end
