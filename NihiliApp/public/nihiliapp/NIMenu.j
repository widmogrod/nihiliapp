@import <AppKit/CPMenu.j>

@implementation NIMenu : CPMenu
{
}

- (id)initWithDelegate:(id)delegate
{
	// taki tytuł zapewnia że menu zostanie dodane odrazu do applikacji?
	// alegdy będzie z pliku cib
	self = [self initWithTitle:@"CPMainMenu"];
	// zatem dodajemy do aplikacji
	[[CPApplication sharedApplication] setMainMenu:self];
	
	[self setDelegate:delegate];
	
	// W tej wersji Cappuccino nie ma rużnicy czy wywołam NIMenu czy CPMenu i tak zadziała
	// pobieważ te popcje są traktowane jako "single"

	// ustawia tytuł na pasku menu
	// to będzie ustawiane podczas utworzenia dokumentu
	//[NIMenu setMenuBarTitle:@"Takkkk"];

	// menu widoczne
	[NIMenu setMenuBarVisible:YES];

	// ustawia ikonę przy tytule na pasku menu
	// to będzie ustawiane wzależnoścu ot typu dokumentu
	// teraz jest domyślnie
	var image = [[CPImage alloc] initWithContentsOfFile:"Resources/menu_bar_icon.png" size:CPSizeMake(16,16)];
	[NIMenu setMenuBarIconImage: image];

	// FIXME: We should implement autoenabling.
	[self setAutoenablesItems:NO];

	// dodaj elemenmty

	var bundle = [CPBundle bundleForClass:[CPApplication class]],
	    newMenuItem = [[CPMenuItem alloc] initWithTitle:@"Nowy" action:@selector(newDocument:) keyEquivalent:@"N"];

	[newMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/New.png"] size:CGSizeMake(16.0, 16.0)]];
	[newMenuItem setAlternateImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/NewHighlighted.png"] size:CGSizeMake(16.0, 16.0)]];

	[self addItem:newMenuItem];
	
	var openMenuItem = [[CPMenuItem alloc] initWithTitle:@"Otwórz" action:@selector(openDocument:) keyEquivalent:@"O"];
	
	[openMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/Open.png"] size:CGSizeMake(16.0, 16.0)]];
	[openMenuItem setAlternateImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/OpenHighlighted.png"] size:CGSizeMake(16.0, 16.0)]];
	
	[self addItem:openMenuItem];
	
	var saveMenu = [[CPMenu alloc] initWithTitle:@"Zapisz"],
	    saveMenuItem = [[CPMenuItem alloc] initWithTitle:@"Zapisz" action:@selector(saveDocument:) keyEquivalent:nil];
	
	[saveMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/Save.png"] size:CGSizeMake(16.0, 16.0)]];
	[saveMenuItem setAlternateImage:[[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPApplication/SaveHighlighted.png"] size:CGSizeMake(16.0, 16.0)]];        
	
	[saveMenu addItem:[[CPMenuItem alloc] initWithTitle:@"Zapisz" action:@selector(saveDocument:) keyEquivalent:@"S"]];
	[saveMenu addItem:[[CPMenuItem alloc] initWithTitle:@"Zapisz jako" action:@selector(saveDocumentAs:) keyEquivalent:nil]];
	
	[saveMenuItem setSubmenu:saveMenu];
	
	[self addItem:saveMenuItem];
	
	var editMenuItem = [[CPMenuItem alloc] initWithTitle:@"Edycja" action:nil keyEquivalent:nil],
	    editMenu = [[CPMenu alloc] initWithTitle:@"Edycja"],
	    
	    undoMenuItem = [[CPMenuItem alloc] initWithTitle:@"Cofnij" action:@selector(undo:) keyEquivalent:CPUndoKeyEquivalent],
	    redoMenuItem = [[CPMenuItem alloc] initWithTitle:@"Ponów" action:@selector(redo:) keyEquivalent:CPRedoKeyEquivalent];

	[undoMenuItem setKeyEquivalentModifierMask:CPUndoKeyEquivalentModifierMask];
	[redoMenuItem setKeyEquivalentModifierMask:CPRedoKeyEquivalentModifierMask];
	
	[editMenu addItem:undoMenuItem];
	[editMenu addItem:redoMenuItem];
	
	[editMenu addItem:[[CPMenuItem alloc] initWithTitle:@"Wytnij" action:@selector(cut:) keyEquivalent:@"X"]],
	[editMenu addItem:[[CPMenuItem alloc] initWithTitle:@"Skopiuj" action:@selector(copy:) keyEquivalent:@"C"]],
	[editMenu addItem:[[CPMenuItem alloc] initWithTitle:@"Wklej" action:@selector(paste:) keyEquivalent:@"V"]];

	[editMenuItem setSubmenu:editMenu];
	
	[self addItem:editMenuItem];
 
	var helpMenuItem = [[CPMenuItem alloc] initWithTitle:@"Pomoc" action:nil keyEquivalent:nil],
	    helpMenu = [[CPMenu alloc] initWithTitle:@"Pomoc"],

	    aboutMenuItem = [[CPMenuItem alloc] initWithTitle:@"O programie" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@"O"];

	// akcja docelowa jest przekierowywana do CPApplication,
	// która ma zaimplementowaną metodę generującą panel "O programie"
	[aboutMenuItem setTarget:[CPApplication sharedApplication]];

	[helpMenu addItem:aboutMenuItem];
	[helpMenuItem setSubmenu:helpMenu];
	[self addItem:helpMenuItem];

	[self addItem:[CPMenuItem separatorItem]];

	var loginMenuItem = [[CPMenuItem alloc] initWithTitle:@"Logowanie" action:@selector(login:) keyEquivalent:nil];
	[self addItem:loginMenuItem];

	return self;
}

@end
