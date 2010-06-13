@import <AppKit/CPPanel.j>

var SharedLoginPanel = nil;

/*
	Panel logowania jest zawsze widoczny nad wszystkimi oknami.
	Jego funkcjonalność to:
	- TODO: nie można zamknąć okna bez poprawnego logowania
	- TODO: logowanie użytkownika
	- TODO: rejestrowanie nowego użytkownika
*/
@implementation NILoginPanel : CPPanel
{}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,400,200) styleMask:CPDocModalWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];

		var loginButton = [CPButton buttonWithTitle:"Zaloguj"];
		[loginButton setDefaultButton:YES];
		// ustaw położenie w lewym dolnym roku!
		[loginButton setFrameOrigin:CGPointMake(CGRectGetMinX(frame) + 10, CGRectGetMaxY(frame) - 10 - CGRectGetHeight([loginButton frame]))];
		[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin ];
		[contentView addSubview:loginButton];
	}
	
	return self;
}

+ (id)sharedLoginPanel
{
	if (!SharedLoginPanel)
		SharedLoginPanel = [[NILoginPanel alloc] init];

	return SharedLoginPanel;
}

- (BOOL)canBecomeMainWindow
{
	return YES;
}
@end
