/*
 * AppController.j
 * niniliapp
 *
 * Created by You on June 13, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Windows/NIOpenWindow.j"
@import "Panels/NILoginPanel.j"

@import "Panels/NISitePanelController.j"

@import "Views/NIPageView.j"
@import "NIMenu.j"

@import "NIDocument.j"

//@import "Controllers/NIApiController.j"
@import "Panels/NIFileExplorerController.j"    

@import "Panels/NIPreviewPanel.j"

// @import "Bespin.j"
// @import <AppKit/CPPanel.j>
// @import <AppKit/CPWindowController.j>
/*
	Zmienne globale dla aplikacji
*/ 
NIPageViewWidth = 200.0;

// gdy jest wykorzystywane menu główne całość strony spada o 29px
// dlatego trzeba o tą wartość modyfikować gówne bloki strony!
NIMenubarHeight = 29.0; 

var ToolbarItemUndo = "ToolbarItemUndo",
	ToolbarItemRedo = "ToolbarItemRedo";

@implementation AppController : CPObject
{
	CPView contentView;
}

/*
	Nie otwieraj pustego dokumentu przy starcie aplikacji, najpierw autoryzacja!
*/
- (BOOL)applicationShouldOpenUntitledFile:(id)sender
{
	return NO;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    [theWindow orderFront:self];

	contentView = [theWindow contentView];    
	
	// var panel = [[NIPreviewPanel alloc] init];
	// [panel orderFront:self];
	
	// // var bespin = [[Bespin alloc] initWithFrame:CGRectMake(10,10,300,300)];   
	// var bespin = [[Bespin alloc] init];
	// [bespin setFrame:CGRectMake(0,0,200,100)];
	// [bespin setBackgroundColor:[CPColor redColor]];
	// [bespin setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	// // [contentView addSubview:bespin]; 
	// 
	// var panel = [[CPPanel alloc] initWithContentRect:(CGRectMake(200,20,200,100)) styleMask:CPClosableWindowMask | CPResizableWindowMask];
	// 
	// [[panel contentView] addSubview: bespin];
	// 
	// setTimeout(function (){
	// 	window.bespin.useBespin([panel contentView]);
	// }, 2000);
	// 
	// 
	// [panel orderFront:self];
	// 
	// var window = [[CPWindowController alloc] initWithWindow: panel];
	// // [window loadWindow];
    
    // dokonanie autoryzacji uzytkownika przed uruchomieniem aplikacji!
    // if (![[NIApiController sharedController] isAuthenticated])
    //     {
    	// [self login:self];
    // } else {
    	[self initApplicationView];
    // }
    
   // [[NIOpenWindow sharedOpenWindow] orderFront:self];
    
    [NISitePanelController sharedController];
}

- (void)initApplicationView
{
	// Aktywuj menu główne applikacji
    var mainMenu = [[NIMenu alloc] initWithDelegate:self];
    
    // // Utwórz pasek nawigacyjny
    // 	var toolbar = [[CPToolbar alloc] initWithIdentifier:"Navigation"];
    //     [toolbar setDelegate:self];
    // 	[toolbar setVisible:YES];
    // 	[theWindow setToolbar:toolbar];
	
	// var pageView = [[NIPageView alloc] initWithFrame:CGRectMake(0,0, NIPageViewWidth, CGRectGetHeight([contentView bounds]))];
	// 	[contentView addSubview:pageView];
}

@end

/*
	Kategoria obsługuje wiadomości akcj operacji na dokumencie
*/
@implementation AppController (MenuActions)

- (void)openDocument:(id)sender
{
	[[NIOpenWindow sharedOpenWindow] orderFront:self];
}

- (void)login:(id)sender
{
	var panel = [[NILoginPanel sharedLoginPanel] makeKeyAndOrderFront:self];
}

@end


/*
	Kategotia odpowiada za zbudowanie Paska narzędzi
*/
@implementation AppController (ToolbarItems)
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
