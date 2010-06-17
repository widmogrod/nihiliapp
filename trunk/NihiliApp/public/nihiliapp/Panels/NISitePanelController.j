@import <AppKit/CPWindowController.j>

@import "NISitePanel.j"
@import "../Controllers/NIApiController.j"

var SharedSIPanelController

/*
	Łaczenie interakcji widok, apikacja, server
	Odpowiada za:
	- tworzenie, edycję, usunięcie nowych stron
	- wyświetlanie strukóry katalogów na serwerze
*/
@implementation NISitePanelController : CPWindowController
{}

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
	Sprawź połączenie
*/
- (id)testConnection:(id)sender
{
	var hostname = [[[self window] hostnameField] stringValue],
		username = [[[self window] usernameField] stringValue],
		password = [[[self window] passwordField] stringValue];

	[[NIApiController sharedController] testConnectionToHost:hostname user:username pass:password];
}

@end


/*
	Źródło danych dla CPoutlineView wykorzystywane w NISitePanel
	- odpowiada za stworzenie drzewiastej stryktury danych katalogów (po stronie serwera)
*/
@implementation NISitePanelController (DataSource)
{}

- (id)outlineView:(CPOutlineView)anOutlineView  child:(int)aChild   ofItem:(id)anItem
{
	console.log("child", aChild, anItem);
	if (!anItem)
	{
		console.log("child", array[aChild]);
		return array[aChild];
	}
		

	return anItem.childrens[aChild];
}

//-(BOOL)outlineView:(CPOutlineView)theOutlineView isItemExpandable:(id)theItem
-(BOOL)outlineView:(CPOutlineView)anOutlineView  isItemExpandable:(id)anItem
{
	console.log("isItemExpandable", anItem);
	if (!anItem)
		return NO;

	return !!anItem.childrens;
}

//- (int)outlineView:(CPOutlineView)theOutlineView numberOfChildrenOfItem:(id)theItem
- (int)outlineView:(CPOutlineView)anOutlineView  numberOfChildrenOfItem:(id)anItem
{
	console.log("numberOfChildrenOfItem", anItem);
	if (!anItem)
	{
		console.log("numberOfChildrenOfItem", array.length);
		return array.length;
	}
		
//	console.log("numberOfChildrenOfItem", anItem);
	return anItem.childrens.length;
//	return array.length;
}
//- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(CPTableColumn)theColumn byItem:(id)theItem
- (id)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aColumn byItem:(id)anItem
{
	console.log("objectValueForTableColumn", aColumn, anItem);
	return array[anItem];
}

@end
