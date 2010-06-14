@import <AppKit/CPWindow.j>

var SharedOpenWindow = nil;

/*
	Okno otwierania stron internetowych, 
	za jego pomocą można wywołać następujące akcje:
	- TODO: dodawanie nowego projektu
	- TODO: usuwanie istniejącego projektu
	- TODO: zarządzanie usawieniami projektu
	- TODO: zmiana nazwy projektu
	- TODO: zmiana kolejności projektów
*/
@implementation NIOpenWindow : CPWindow
{}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,500,350) styleMask:CPTitledWindowMask | CPClosableWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Otwórz projekt"]

		var buttonBarHeight = 25;

		var buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - buttonBarHeight,
																	 CGRectGetWidth(frame), buttonBarHeight)];

		[contentView addSubview:buttonBar];

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

+ (id)sharedOpenWindow
{
	if (!SharedOpenWindow)
		SharedOpenWindow = [[NIOpenWindow alloc] init];

	return SharedOpenWindow;
}

@end
