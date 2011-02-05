@import <AppKit/CPWindowController.j>
@import "NIOpenWindow.j"

@import "../Models/NIConnectionsApi.j"

@import "NIProjectWindow/NIProjectWindowController.j"

@import "../Models/VOConnection.j"

var SharedNIOpenWindowController = nil;

@implementation NIOpenWindowController : CPWindowController
{
	CPTableView _tableView;
	CPDictionary _dataSource;
}

+ (NIOpenWindowController)sharedController
{
	if (!SharedNIOpenWindowController)
		SharedNIOpenWindowController = [[NIOpenWindowController alloc] init];

	return SharedNIOpenWindowController;
}

- (id)init
{
	var openWindow = [[NIOpenWindow alloc] init];
	if(self = [super initWithWindow: openWindow])
	{
		_tableView = [openWindow tableView];   
		[_tableView setDataSource:self];
		[_tableView setDelegate:self];
		[_tableView setTarget:self];
		[_tableView setDoubleAction:@selector(doubleClickAction:)];
		
		var plusButton = [openWindow plusButton];
			[plusButton setTarget:self];
			[plusButton setAction:@selector(createNewConnection:)];
			
		var minusButton = [openWindow plusButton];
			[minusButton setTarget:self];
			[minusButton setAction:@selector(deleteSelectedConnection:)];
		
		var penButton = [openWindow penButton];
			[penButton setTarget:self];
			[penButton setAction:@selector(editSelectedConnection:)];

		var popUpButton = [openWindow popUpButton];
			[popUpButton setTarget:self];
			[popUpButton setAction:@selector(actionFromPopUp:)];

		[openWindow orderFront:self];
		
		
		var connections = [NIConnectionsApi sharedApi];
			[connections action:@"list" delegate:self selector:@selector(didReciveData:)];
	}
	return self;
}

@end


/*
	Kategoria reprezentująca
*/
@implementation NIOpenWindowController (CPTableDataSource)

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [_dataSource count]
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(id)aColumn row:(int)aRow
{
	var identifier = [aColumn identifier];
	var anItem = _dataSource[aRow];
	// var anItem = [_dataSource valueForKey:aRow];
	return [anItem valueForKey:identifier];
}

@end


/*
	Kategoria zawiera metody do których są delegowane odpowiedzi
	z serwera. Więcej szczegółów @see NIFTPApi.
*/
@implementation NIOpenWindowController (NIFTPApiDelegate)

/*
	Delegacja do tej metody jest ustalona 
	w NIFileExplorerController @see setConnection:
*/
- (void)didReciveData:(CPDictionary)aResponse
{
	//CPLog.info('Otrzymałem dane: didReciveData');
	//CPLog.info(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		_dataSource = [aResponse valueForKey:@"result"];
		[_tableView reloadData];
	}
}

- (void)didSaveData:(CPDictionary)aResponse
{
	//CPLog.info('Otrzymałem dane: didSaveData');
	//CPLog.info(aResponse);
	
	[[NIAlert alertWithResponse:aResponse] runModal];
	
	// TODO: przebudowa danych po stronie JS
	var connections = [NIConnectionsApi sharedApi];
		[connections action:@"list" delegate:self selector:@selector(didReciveData:)];
}

- (void)didAddData:(CPDictionary)aResponse
{
	//CPLog.info('Otrzymałem dane: didSaveData');
	//CPLog.info(aResponse);
	
	[[NIAlert alertWithResponse:aResponse] runModal];
	
	// TODO: przebudowa danych po stronie JS
	var connections = [NIConnectionsApi sharedApi];
		[connections action:@"list" delegate:self selector:@selector(didReciveData:)];
}

@end;


@implementation NIOpenWindowController (TargetActionAndNotifications)   

/*
	Akcje wykonywane po wybraniu akcji z rozwijanego menu
*/
- (void)actionFromPopUp:(CPPopupButton)anPopupButton
{
	switch([anPopupButton selectedTag])
	{
		case 'add':
			[self createNewConnection:nil];
			break;
			
		case 'edit':
			[self editSelectedConnection:nil];
			break;

		case 'delete':
			break;
	}
}

/*
	Edycja dwukrotnie klikniętego wiersza na liście zapisanych połączeń FTP
	- pobierz dane z wiersza
	- otwórz panel NISitePanel z pobranymi danymi
	- personalizacja przyciksu "action" znajdującego się w NISitePanel
	
	INFO: działanie prawie identyczne z @see [self editSelectedConnection:]
*/
- (void)doubleClickAction:(CPTableView)aTableView
{
	var row = _dataSource[[_tableView selectedRow]],
		connection = [[VOConnection alloc] initWithDictionary:row];
		
	var projectController = [NIProjectWindowController sharedController];
		[projectController setConnection:connection];
	
	// var row = _dataSource[[aTableView selectedRow]];
	// 
	// var connection = [[VOConnection alloc] initWithDictionary:row];
	// 
	// var sitePanelController = [NISitePanelController sharedController];
	// 	[sitePanelController setConnection:connection];
	// 
	// var actionButton = [CPButton buttonWithTitle:@"Zapisz"];
	// 	[actionButton setTarget:self];
	// 	[actionButton setAction:@selector(updateConnection:)];
	// 	
	// [sitePanelController setActionButton:actionButton];
}

/*
	Edycja zaznaczonego wiersza na liście zapisanych połączeń FTP
	- pobierz dane z wiersza
	- otwórz panel NISitePanel z pobranymi danymi
	- personalizacja przyciksu "action" znajdującego się w NISitePanel
	
	INFO: działanie prawie identyczne z @see [self doubleClickAction:]
*/
- (void)editSelectedConnection:(CPButton)aSender
{
	var row = _dataSource[[_tableView selectedRow]],
		connection = [[VOConnection alloc] initWithDictionary:row];

	var sitePanelController = [NISitePanelController sharedController];
		[sitePanelController setConnection:connection];

	var actionButton = [CPButton buttonWithTitle:@"Edytuj"];
		[actionButton setTarget:self];
		[actionButton setAction:@selector(updateConnection:)];

	[sitePanelController setActionButton:actionButton];
}

/*
	Tworzenia nowego połączenia.
	- otwórz panel NISitePanel z pobranymi danymi
	- personalizacja przyciksu "action" znajdującego się w NISitePanel
*/
- (void)createNewConnection:(CPButton)aSender
{
	var connection = [[VOConnection alloc] init];

	var sitePanelController = [NISitePanelController sharedController];
		[sitePanelController setConnection:connection];
		
	var actionButton = [CPButton buttonWithTitle:@"Dodaj"];
		[actionButton setTarget:self];
		[actionButton setAction:@selector(insertConnection:)];

	[sitePanelController setActionButton:actionButton];
}

/*
	Usuń zaznaczoną stronę
	- sprawdź czy są zaznaczone rekordy
	- otwiera panel potwierdzenia	
	- po kliknięciu OK - strona zostanie usunięta
*/
- (void)deleteSelectedConnection:(CPButton)aSender
{
	
}

/*
	Panel zapisu nowego połączenia
*/
- (void)updateConnection:(CPButton)aSender
{
	var connections = [NIConnectionsApi sharedApi];
	var sitePanelController = [NISitePanelController sharedController];
	
	CPLog.info("updateConnection:");
	CPLog.debug([[sitePanelController connection] id]);
	
	[connections setConnection: [sitePanelController connection]];
	[connections action:@"edit" delegate:self selector:@selector(didSaveData:)];
}

/*
	Akcja wywoływana po kliknięciu "Zapisz"
	w panelu "Nowe połączenie"
*/
- (void)insertConnection:(CPButton)aSender
{
	var connections = [NIConnectionsApi sharedApi];
	var sitePanelController = [NISitePanelController sharedController];
	
	CPLog.info("insertConnection:");
	CPLog.debug([[sitePanelController connection] id]);
	
	[connections setConnection: [sitePanelController connection]];
	[connections action:@"add" delegate:self selector:@selector(didAddData:)];
}

@end