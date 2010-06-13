@import <AppKit/CPWindowController.j>



@implementation NIPageWindowController : CPWindowController
{}

- (void) init
{
	// Utwórz okno bez obramowań
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
												styleMask:CPBorderlessWindowMask];
												
		[theWindow setContentView:[[NIPageView alloc] init]];

	var contentView = [theWindow contentView];

	self = [super initWithWindow:theWindow];
	if (self)
	{
		// Pobierz wymiary okna przeglądarki
		var platformBounds = [[theWindow platformWindow] nativeContentRect];

		// Pozycjonowaniue CPWindow w odpowiednim miejscu
		[theWindow setFrameOrigin:CGPointMake(0,0 + NIMenubarHeight)];
		[theWindow setFrameSize:CGSizeMake(NIPageViewWidth, 
										   CGRectGetHeight(platformBounds) - NIMenubarHeight)];


		// Okno bedzie się rozszerzać w wysokości i szerokości
		[theWindow setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];	

		// elementy potrzebne tylko by wyróżnić...
		[contentView setBackgroundColor:[CPColor greenColor]];
	}
	
	return self;
}

/*
	Zestaw elementów wchodzących w skład SIDocument
*/
- (CPSet)elements
{
	var elements = [[self document] elements];
	if (!elements)
	{
		elements = [CPSet set];
	}

	return elements;
}

/*
	Zwracanie zestawu elementów, które są zaznaczone
*/
- (CPSet)selectedElements
{
	var selectedElements = [[self document] selectedElements];
	if (!selectedElements)
	{
		selectedElements = [CPSet set];
	}

	return selectedElements;
}
@end
