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
{
	CPTextField usernameField;
	CPTextField passwordField;
}

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

		var fieldHeight = 50;

		usernameField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame) + 10, 
																	  CGRectGetMinY(frame) + 10,
																	  CGRectGetWidth(frame)-10,
																	  fieldHeight)];
		[usernameField setEditable:YES];
		[usernameField setBezeled:YES];
		[contentView addSubview:usernameField];

		var usernameFrame = [usernameField frame];
		
		passwordField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(usernameFrame), 
																	  CGRectGetMinY(usernameFrame) + 10 + fieldHeight,
																	  CGRectGetWidth(usernameFrame),
																	  fieldHeight)];
		[passwordField setEditable:YES];
		[passwordField setBezeled:YES];
		[contentView addSubview:passwordField];

		var loginButton = [CPButton buttonWithTitle:"Zaloguj"];
		[loginButton setDefaultButton:YES];
		// ustaw położenie w lewym dolnym roku!
		[loginButton setFrameOrigin:CGPointMake(CGRectGetMinX(frame) + 10, 
												CGRectGetMaxY(frame) - 10 - CGRectGetHeight([loginButton frame]))];
		[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin ];
		[loginButton setAction:@selector(login:)];
		[loginButton setTarget:self];
		[contentView addSubview:loginButton];
	}
	
	return self;
}

- (id)login:(id)sender
{
	console.log([usernameField stringValue]);
	console.log([passwordField stringValue]);
	[self close];
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
