@import <AppKit/CPPanel.j>

var ToolbarItemUndo = "ToolbarItemUndo",
	ToolbarItemRedo = "ToolbarItemRedo";

/*
	Okno wyświetla grafikę i wszystkie zmiany na niej dokonywane.
*/
@implementation NIImagePanel : CPPanel
{
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(50,50,400,400) 
							styleMask:CPClosableWindowMask];
	if(self)
	{
		// Utwórz pasek nawigacyjny
		var toolbar = [[CPToolbar alloc] initWithIdentifier:"Navigation"];
			[toolbar setDelegate:self];
			[toolbar setVisible:YES];
			
		[self setToolbar:toolbar];
	}
	return self;
}

@end

/*
	Kategotia odpowiada za zbudowanie Paska narzędzi
*/
@implementation NIImagePanel (ToolbarItems)
/*
    Wszystkie elementy, które są dostępne na pasku narzędzi.
    Kolejnośc elementów określa ich kolejność występowania na pasku narzędzi.
*/
-(CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)toolbar
{
	// mogę zstowować [].. ale w ramach nauki Objective-J wybieram ten sposób
	return new [CPArray arrayWithObjects: CPToolbarFlexibleSpaceItemIdentifier,
										  ToolbarItemUndo,
										  ToolbarItemRedo,
										  CPToolbarFlexibleSpaceItemIdentifier];
}

/*
    Elementy, które będa wyświetlane na pasku narzędzi.
 */  
-(CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)toolbar
{
	// mogę zstowować [].. ale w ramach nauki Objective-J wybieram ten sposób
	return new [CPArray arrayWithObjects: ToolbarItemUndo,
										  ToolbarItemRedo,
										  CPToolbarFlexibleSpaceItemIdentifier];
}

/*
    Tworzenie elemtnów paska narzędi.


    Cappuccino implementuje jeszcze domyślne kilka innych elemtnów,
    które można utworzyć za w nastęþujący sposób:
    
       CPToolbarItem _standardItemWithItemIdentifier 
    
    Elementy zdefiniowane i zaimplementowane:

       - CPToolbarSeparatorItemIdentifier		- separator ([2,100000])
       - CPToolbarSpaceItemIdentifier 			- pojedyńczy element
       - CPToolbarFlexibleSpaceItemIdentifier:  - płynny separator (rozszerza pasek na szerokość [32, 100000])

	Elementy zdefiniowane ale nie zaimplementowane:

	   - CPToolbarShowColorsItemIdentifier
       - CPToolbarShowFontsItemIdentifier
	   - CPToolbarCustomizeToolbarItemIdentifier
	   - CPToolbarPrintItemIdentifier
*/
- (CPToolbarItem)toolbar:(CPToolbar)toolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	var item = [CPToolbarItem _standardItemWithItemIdentifier:itemIdentifier];
	if (nil === item)
	{
		item = [[CPToolbarItem alloc] initWithItemIdentifier:ToolbarItemUndo];
	}

	switch(itemIdentifier)
	{
		case ToolbarItemUndo:
			[item setLabel:@"Cofinij"];
			[item setToolTip:@"Cofnij zmiany"];
			
			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/undo.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/undo_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemRedo:
			[item setLabel:@"Ponów"];
			[item setToolTip:@"Ponów zmiany"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/redo.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/redo_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;
	}

	return item;
}
@end