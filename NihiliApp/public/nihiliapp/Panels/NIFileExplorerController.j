@import <AppKit/CPWindowController.j>

@import "NIFileExplorerPanel.j"



var SharedFileExplorerController = nil;

@implementation NIFileExplorerController : CPWindowController
{
	//NIFTPConnection _connection @accessors(readoly);
	
	@outlet CPOutlineTable _fileExplorerTable(property=fileExplorerTable);
	CPArray _dataSource;
	VOConnection _connection;
	
	CPSet _connections;
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
		[_fileExplorerTable setIndentationMarkerFollowsDataView:NO];
		[_fileExplorerTable setDataSource:self];
		[_fileExplorerTable setDelegate:self];
		[_fileExplorerTable setTarget:self];
		[_fileExplorerTable setDoubleAction:@selector(doubleClickAction:)];

		_connections = [[CPSet alloc] init];
		
		var tf = [[self window] headerTextField];
		[tf setTarget:self];
		[tf setAction:@selector(setPreviousConnection:)];
	}
	return self;
}

/*
	Przekazany obiekt połączenia jest inicjonowany
*/
- (void)setConnection:(VOConnection)aConnection
{
	console.log(aConnection, [aConnection UID]);
	_connection = aConnection;
	
	[_connections addObject:[aConnection copy]];
	
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:aConnection];
	[ftp action:@"ls" delegate:self selector:@selector(didReciveData:)];

	[[self window] orderFront:self];
}

- (void)previousConnection
{
	CPLog.info(@"[_connections count]: " + [_connections count]);
	
	
	if (![_connections count])
		return;
		
	var en = [_connections objectEnumerator];	
	// [en nextObject];
	var conn;
	
	while(conn = [en nextObject])
	{
		if (conn != _connection) {
			console.log('!=');
			console.log(conn);
			break;
		} else {
			console.log('==');
			console.log(conn);
		}
	}
	
	console.log(conn);
	
	return conn;
}

- (void)setPreviousConnection:(id)aSender
{
	CPLog.info(@"setPreviousConnection: GO");
	var conn = [self previousConnection];
	if (conn) {
		CPLog.error(@"!!!!!");
		[self setConnection:conn];
	}
		
}


@end


/*
	Kategoria reprezentująca
*/
@implementation NIFileExplorerController (CPOutlineDataSource)

- (id)outlineView:(CPOutlineView)anOutlineView  child:(int)aChild  ofItem:(id)anItem
{
	if (!anItem)
		return [_dataSource objectAtIndex:aChild];

	// metoda outlineView:isItemExpandable: zadbała
	// o to by dojśc do tego miejsca ;)
	if (![anItem valueForKey:@"childrens"])
	{
		// tworzenie pustej tablicy
		[anItem setValue:[[CPArray alloc] init] forKey:@"childrens"];

		// ustawienie ktalogu jaki ma zostać wylistowany
		[_connection setPathname:[anItem valueForKey:@"pathname"]];

		// inicjowanie pobierania asynchronicznego danych
		var ftp = [NIFTPApi sharedApi];
		[ftp setConnection:_connection];
		[ftp action:@"ls" delegate:self selector:@selector(didReciveChildData:) userInfo:anItem];
	}

	// jako że dane są pobierane asynchonicznie
	// w tym miejscu tworzę "pusty wypełniacz" obiektu,
	// który po wczytaniu ashynch. danych zostanie zastąpiony :)
	var childrens = [anItem valueForKey:@"childrens"];
	if ([[childrens count] isEqualToNumber:aChild])
	{
		// tworzenie "pustego wypełniacza" dla wiersza tabeli .(0_0).
		var item = [anItem copy];
		[item setValue:@"Wczytuję..." forKey:@"filename"];
		[item setValue:nil forKey:@"files"];
		[item setValue:nil forKey:@"filetype"];
		[childrens addObject:item];
	}

	return [childrens objectAtIndex:aChild];
}

-(BOOL)outlineView:(CPOutlineView)anOutlineView isItemExpandable:(id)anItem
{
	if (!anItem)
		return NO;

	// rezszeżalne są tylko katalogi, które mają jakieś pliki w sobie...
	return [anItem valueForKey:@"filetype"] == "DIR" && [anItem valueForKey:@"files"] > 0;
}

- (int)outlineView:(CPOutlineView)anOutlineView numberOfChildrenOfItem:(id)anItem
{
	if (!anItem)
		return [_dataSource count];

	// tylko katalog ale to jest już załatwione 
	// w @see outlineView:isItemExpandable:
	
	// Sprawdzanie czy klucz "childrens" istnieje,
	// umożliwia stworzenie małej sztuczki z wyświetleniem tylko
	// jednego wierszu z tekste "Wczytuje..." (pusty wypełniacz)
	return !![anItem valueForKey:@"childrens"] ? [anItem valueForKey:@"files"] : 1;
}

- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	var identifier = [aColumn identifier];
	return [anItem valueForKey:identifier];
}

@end     




@import "NIFileExplorerFileDataView.j"


@implementation NIFileExplorerController (CPOutlineDelegate)   

- (CPView)outlineView:(CPOutlineView)theOutlineView dataViewForTableColumn:(CPTableColumn)theTableColumn item:(id)anItem
{
    var identifier = [theTableColumn identifier],
		dataView;

	switch (identifier)
	{
		case @"filename":
			dataView = [[NIFileExplorerFileDataView alloc] init];
			
			CPLog.debug(@"Generowanie dataView:");
			CPLog.debug([anItem valueForKey:@"filetype"]);
			
			switch([anItem valueForKey:@"filetype"])
			{
				// ikona jako folder
				case @"DIR":
					CPLog.debug("Ikona katalogu:" + [anItem valueForKey:@"filetype"]);
					[dataView setFiletype:@"folder"];
				break;
				
				// ikona jako rotujący wskaźnik pracy :)
				case nil:
					CPLog.fatal("Ikona wskaźnika pracy");
					[dataView setFiletype:@"spinner" withImageExtension:@"gif"];
				break;
			}
		break;

		default:
			dataView = [theTableColumn dataView];
	}

	return dataView;
}

@end


@import "NIPreviewController.j"


@implementation NIFileExplorerController (TargetActionAndNotifications)   

- (void)doubleClickAction:(CPOutlineView)theOutlineView
{
	var row = [theOutlineView itemAtRow:[theOutlineView selectedRow]];
	
	if ([row valueForKey:@"filetype"] == 'FILE')
	{
		CPLog.debug(@"Wczytaj plik");
		
		var preview = [NIPreviewController sharedController];
		[preview setConnection:_connection];
	} else {
		CPLog.debug(@"Przeładuj katalog");
		// dodać klonowanie noweo obiektu
		[self setConnection:[_connection copy]];
		
		CPLog.debug(@"Ustawiam nagłówek");

		[[self window] setHeaderText:[row valueForKey:@"filename"]];
	}
}

- (id)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var outlineView = [aNotification object];
	var item = [outlineView itemAtRow:[outlineView selectedRow]];
	
	
	CPLog.debug(@"outlineViewSelectionDidChange:");
	CPLog.debug([item valueForKey:@"pathname"])
	
	[_connection setPathname:[item valueForKey:@"pathname"]];
}

@end



/*
	Kategoria zawiera metody do których są delegowane odpowiedzi
	z serwera. Więcej szczegółów @see NIFTPApi.
*/
@implementation NIFileExplorerController (NIFTPApiDelegate)

/*
	Delegacja do tej metody jest ustalona 
	w NIFileExplorerController @see setConnection:
*/
- (void)didReciveData:(CPDictionary)aResponse
{
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		_dataSource = [aResponse valueForKey:@"result"];
		[_fileExplorerTable reloadData];
	}
}

/*
	Delegacja do tej metody jest ustalona 
	NIFileExplorerController @see outlineView:child:ofItem:
*/
- (void)didReciveChildData:(CPDictionary)aResponse
{
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		var item = [aResponse valueForKey:@"userInfo"];
		[item setValue:[aResponse valueForKey:@"result"] forKey:@"childrens"];
		[_fileExplorerTable reloadData];
	}
	
}

// /*
// 	Delegacja do tej metody jest ustalona 
// 	NIFileExplorerController @see outlineView:child:ofItem:
// */
// - (void)didReciveContentFileData:(CPDictionary)aResponse
// {
// 	CPLog.debug(@"didReciveContentFileData:");
// 	
// 	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
// 	{
// 		CPLog.debug([aResponse valueForKey:@"result"]);
// 	} else {
// 		[[NIAlert alertWithResponse:aResponse] runModal];
// 	}
// }

@end