/*
 * AppController.j
 * niniliapp
 *
 * Created by You on June 13, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Windows/NILoginWindow.j"
@import "Windows/NIOpenWindow.j"
@import "Panels/NILoginPanel.j"
@import "Views/NIPageView.j"
@import "NIMenu.j"

/*
	Zmienne globale dla aplikacji
*/ 
NIPageViewWidth = 200.0;

// gdy jest wykorzystywane menu główne całość strony spada o 29px
// dlatego trzeba o tą wartość modyfikować gówne bloki strony!
NIMenubarHeight = 29.0; 

var ToolbarItemUndo = "ToolbarItemUndo",
	ToolbarItemRedo = "ToolbarItemRedo",
	ToolbarItemAddText = "ToolbarItemAddText",
	ToolbarItemAddImage = "ToolbarItemAddImage",
	ToolbarItemAlignLeft = "ToolbarItemAlignLeft",
	ToolbarItemAlignCenter = "ToolbarItemAlignCenter",
	ToolbarItemAlignRight = "ToolbarItemAlignRight",
	ToolbarItemPreview = "ToolbarItemPreview",
	ToolbarItemOrder = "ToolbarItemOrder";

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView],
        bounds = [contentView bounds];

    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

    [label setStringValue:@"Hello World!"];
    [label setFont:[CPFont boldSystemFontOfSize:24.0]];

    [label sizeToFit];

    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setCenter:[contentView center]];

    [contentView addSubview:label];

    [theWindow orderFront:self];
    
    // Menu główne applikacji
    var mainMenu = [[NIMenu alloc] initWithDelegate:self];
    //[[CPApplication sharedApplication] setMainMenu:mainMenu];
    
    // Panel po lewej stronie
    var pageView = [[NIPageView alloc] initWithFrame:CGRectMake(0,0,
    															NIPageViewWidth,
    															CGRectGetHeight(bounds) - NIMenubarHeight)];
    [contentView addSubview:pageView];


    
    var loginWindow = [NILoginWindow sharedLoginWindow];
    [loginWindow makeKeyAndOrderFront:self];
    
    var loginPanel = [NILoginPanel sharedLoginPanel];
    [loginPanel makeKeyAndOrderFront:self];
    
    
    var openWindow = [NIOpenWindow sharedOpenWindow];
    [openWindow orderFront:self];
    
	var toolbar = [[CPToolbar alloc] initWithIdentifier:"Photos"]
    
    //we tell the toolbar that we want to be its delegate and attach it to theWindow
    [toolbar setDelegate:self];
	[toolbar setVisible:YES];
	[theWindow setToolbar:toolbar];

    [theWindow orderFront:self];
}

@end


@implementation AppController (ToolbarItems)
/*
    Wszystkie elementy, które są dostępne na pasku narzędzi.
    Kolejnośc elementów określa ich kolejność występowania na pasku narzędzi.
*/
-(CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)toolbar
{
	// mogę zstowować [].. ale w ramach nauki Objective-J wybieram ten sposób
	return new [CPArray arrayWithObjects: ToolbarItemUndo,
										  ToolbarItemRedo,

										  CPToolbarFlexibleSpaceItemIdentifier,
										  
										  ToolbarItemAddText,
										  ToolbarItemAddImage,

										  CPToolbarSpaceItemIdentifier,

										  ToolbarItemAlignLeft,
										  ToolbarItemAlignCenter,
										  ToolbarItemAlignRight,
										  
										  CPToolbarFlexibleSpaceItemIdentifier,
										  
										  ToolbarItemPreview,
										  
										  CPToolbarSpaceItemIdentifier,
										  
										  ToolbarItemOrder];
}

/*
    Elementy, które będa wyświetlane na pasku narzędzi.
 */  
-(CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)toolbar
{
	// mogę zstowować [].. ale w ramach nauki Objective-J wybieram ten sposób
	return new [CPArray arrayWithObjects: ToolbarItemUndo,
										  ToolbarItemRedo,

										  ToolbarItemAddText,
										  ToolbarItemAddImage,
										  
										  ToolbarItemPreview,
										  ToolbarItemOrder,
										  
										  ToolbarItemAlignLeft,										  
										  ToolbarItemAlignCenter,
										  ToolbarItemAlignRight,

										  CPToolbarFlexibleSpaceItemIdentifier,
										  CPToolbarSpaceItemIdentifier];
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

		case ToolbarItemAddText:
			[item setLabel:@"Dodaj tekst"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/add_text.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/add_text_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemAddImage:
			[item setLabel:@"Dodaj grafikę"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/add_image.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/add_image_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemPreview:
			[item setLabel:@"Podgląd"];
			[item setToolTip:@"Zobacz projekt w orginalnych rozmiarach"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/preview.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/preview_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemOrder:
			[item setLabel:@"Zamów"];
			[item setToolTip:@"Zamów ten projekt pieczątki"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/order.png" size:CPSizeMake(32, 32)],
				imageAlternate = [[CPImage alloc] initWithContentsOfFile:"Resources/order_alternate.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemAlignLeft:
			[item setLabel:@"Do lewej"];
			[item setToolTip:@"Wyrównaj do lewej"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/align_left.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			//[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemAlignCenter:
			[item setLabel:@"Wyśrodkuj"];
			[item setToolTip:@"Wyśrodkuj"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/align_center.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			//[item setAlternateImage:imageAlternate];
			break;

		case ToolbarItemAlignRight:
			[item setLabel:@"Do prawej"];
			[item setToolTip:@"Wyrównaj do prawej"];

			var image = [[CPImage alloc] initWithContentsOfFile:"Resources/align_right.png" size:CPSizeMake(32, 32)];
			
			[item setImage:image];
			//[item setAlternateImage:imageAlternate];
			break;

	}

	return item;
}
@end
