@import <AppKit/CPWindowController.j>

@import "../../Models/NIFTPApi.j"
@import "NIProjectWindow.j"


var SharedNIProjectWindowController = nil;

@implementation NIProjectWindowController : CPWindowController
{
	CPArray _dataSource;
	VOConnection _connection;
	CPOutlineView navigatorTable @accessors(readonly);
	NIProjectWindowEditor editorView @accessors(readonly);
	// NITextView textView @accessors(readonly);
}

+ (NIProjectWindowController)sharedController
{
	if (!SharedNIProjectWindowController)
		SharedNIProjectWindowController = [[NIProjectWindowController alloc] init];

	return SharedNIProjectWindowController;
}


- (id)init
{
	var projectWindow = [[NIProjectWindow alloc] init];
	self = [super initWithWindow:projectWindow];

	if (self)
	{
		var navigatorView = [projectWindow navigatorView];
		
		navigatorTable = [navigatorView navigatorTable];
		editorView = [projectWindow editorView];
		
		var saveButton = [editorView saveButton];
			[saveButton setTarget:self];
			[saveButton setAction:@selector(performSave:)];

		[navigatorTable setIndentationMarkerFollowsDataView:NO];
		[navigatorTable setDataSource:self];
		[navigatorTable setDelegate:self];
		[navigatorTable setTarget:self];
		[navigatorTable setDoubleAction:@selector(doubleClickAction:)];
	}

	return self;
}

/*
	Przekazany obiekt połączenia jest inicjonowany
*/
- (void)setConnection:(VOConnection)aConnection
{
	_connection = aConnection;

	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:aConnection];
	[ftp action:@"ls" delegate:self selector:@selector(didReciveData:)];

	[[self window] orderFront:self];
}

@end



/*
	Kategoria reprezentująca CPOutlineDataSource 
*/
@implementation NIProjectWindowController (CPOutlineDataSource)

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



@import "../../Panels/NIFileExplorerFileDataView.j"
// @import "NIFileExplorerFileDataView.j"


@implementation NIProjectWindowController (CPOutlineDelegate)   

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




@implementation NIProjectWindowController (TargetActionAndNotifications)   

- (void)doubleClickAction:(CPOutlineView)theOutlineView
{
	var row = [theOutlineView itemAtRow:[theOutlineView selectedRow]];
	
	if ([row valueForKey:@"filetype"] == 'FILE')
	{
		CPLog.debug(@"Wczytaj plik");
		
		[_connection setPathname:[row valueForKey:@"pathname"]];
		
		// wczytaj nowe dane
		var ftp = [NIFTPApi sharedApi];
		[ftp setConnection:_connection];
		[ftp action:@"get" delegate:self selector:@selector(didReciveContentFileData:)];
		
	} else {
		
		var um = [[self window] undoManager];	
		[um registerUndoWithTarget:self selector:@selector(setConnection:) object:[_connection copy]];
		
		// dodać klonowanie noweo obiektu
		[_connection setPathname:[row valueForKey:@"pathname"]];
		[self setConnection:_connection];
	}
}

- (id)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var outlineView = [aNotification object];
	var item = [outlineView itemAtRow:[outlineView selectedRow]];
	
	
	CPLog.debug(@"outlineViewSelectionDidChange:");
	CPLog.debug([item valueForKey:@"pathname"])
	
	// [_connection setPathname:[item valueForKey:@"pathname"]];
}

- (void)performSave:(id)sender
{
	[sender setTitle:@"Zapisuję..."];
	
	[_connection setContent: [[[self editorView] textView] objectValue]];
	
	var ftp = [NIFTPApi sharedApi];
	[ftp setConnection:_connection];
	[ftp action:@"put" delegate:self selector:@selector(didSaveContentData:)];

	[[self window] orderFront:self];
}

@end



/*
	Kategoria zawiera metody do których są delegowane odpowiedzi
	z serwera. Więcej szczegółów @see NIFTPApi.
*/
@implementation NIProjectWindowController (NIFTPApiDelegate)

/*
	Delegacja do tej metody jest ustalona 
	w NIFileExplorerController @see setConnection:
*/
- (void)didReciveData:(CPDictionary)aResponse
{
	CPLog.debug([self class] + @"didReciveData");
	CPLog.debug(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		_dataSource = [aResponse valueForKey:@"result"];
		[[self navigatorTable] reloadData];
	}
	else if ([aResponse valueForKey:@"status"] == @"FAILURE")
	{
		[[NIAlert alertWithResponse: aResponse] runModal];
		[[self window] close];
	}
}

/*
	Delegacja do tej metody jest ustalona 
	NIFileExplorerController @see outlineView:child:ofItem:
*/
- (void)didReciveChildData:(CPDictionary)aResponse
{
	CPLog.debug([self class] + @"didReciveChildData");
	CPLog.debug(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		var item = [aResponse valueForKey:@"userInfo"];
		[item setValue:[aResponse valueForKey:@"result"] forKey:@"childrens"];
		[[self navigatorTable] reloadData];
	}
	
}

/*
	
*/
- (void)didReciveContentFileData:(CPDictionary)aResponse
{
	CPLog.debug([self class] + @"didReciveContentFileData:");
	CPLog.debug(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		[[[self editorView] textView] setObjectValue:[aResponse valueForKey:@"result"]];
	} else {
		[[NIAlert alertWithResponse:aResponse] runModal];
	}
}

- (void)didSaveContentData:(CPDictionary)aResponse
{
	CPLog.debug([self class] + @"didSaveContentData:");
	CPLog.debug(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		[[[self editorView] saveButton] setTitle:@"Zapisz"];
	} else {
		[[NIAlert alertWithResponse:aResponse] runModal];
	}
}

@end