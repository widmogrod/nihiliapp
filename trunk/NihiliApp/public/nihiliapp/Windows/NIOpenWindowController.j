@import <AppKit/CPWindowController.j>
@import "NIOpenWindow.j"

@import "../Models/NIConnectionsApi.j"

@implementation NIOpenWindowController : CPWindowController
{
	CPTableView _tableView;
	CPDictionary _dataSource;
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
	CPLog.info('Otrzymałem dane: didReciveData');
	CPLog.info(aResponse);
	
	if ([aResponse valueForKey:@"status"] == @"SUCCESS")
	{
		_dataSource = [aResponse valueForKey:@"result"];
		[_tableView reloadData];
	}
}

@end;


@implementation NIOpenWindowController (TargetActionAndNotifications)   

- (void)doubleClickAction:(CPTableView)aTableView
{
	var row = _dataSource[[aTableView selectedRow]];
	// var row = [_dataSource valueForKey:[aTableView selectedRow]];
	
	var connection = [[VOConnection alloc] init];
		[connection setServer: [row valueForKey:@"server"]];
		[connection setUsername: [row valueForKey:@"username"]];
		[connection setPassword: [row valueForKey:@"password"]];
		[connection setProtocol: [row valueForKey:@"protocol"]];
		[connection setPathname: [row valueForKey:@"pathname"]];
		
	var sitePanelController = [NISitePanelController sharedController];
		[sitePanelController setConnection:connection];
}

@end