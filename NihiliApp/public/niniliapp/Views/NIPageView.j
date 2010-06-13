@import <AppKit/CPView.j>

/*
	Okno wy‍świetla listę podstron (danej strony WWW) do edycji.
	
	Przypadki użycia:
	- TODO: uzytkownik klika na wyraną podstronę co powoduje zmianę w edytorze strony
	- TODO: możliwość usunięcia podstrony
	- TODO: możliwość dodania podstrony
	- TODO: możliwość zmiany nazwy podstrony
	- TODO: możliwośc zmiany ustawień podstrony
*/
@implementation NIPageView : CPView
{}

- (id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
		// Okno bedzie się rozszerzać w wysokości i szerokości
		[self setAutoresizingMask:CPViewHeightSizable];	

		[self setBackgroundColor: [CPColor colorWithHexString:@"dce2e6"]];
		
		var buttonBarHeight = 25;

		// utworzenie paska z przyciskami na samym dole okna widoku
		var buttonBar = [[CPButtonBar alloc] 
							initWithFrame:CGRectMake(0, 
  												     CGRectGetHeight(aFrame) - buttonBarHeight,
												     CGRectGetWidth(aFrame), 
												     buttonBarHeight)];

		// gdy okno będzie zmieniało rozmiar buttonBar zawsze na dole :)
		[buttonBar setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
		[self addSubview:buttonBar];

		var popUpButton = [CPButtonBar actionPopupButton];
		[popUpButton addItemWithTitle:@"Ustawienia"];
		[popUpButton addItemWithTitle:@"Zmień nazwę"];

		var buttons = [
			[CPButtonBar plusButton],
			[CPButtonBar minusButton],
			popUpButton
		];

		[buttonBar setButtons:buttons];
	}

	return self;
}

@end
