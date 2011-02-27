@import <AppKit/CPPanel.j>
@import <Foundation/CPTimer.j>

/*
	Panel logowania jest zawsze widoczny nad wszystkimi oknami.
	Jego funkcjonalność to:
	- TODO: nie można zamknąć okna bez poprawnego logowania
	- TODO: logowanie użytkownika
	- TODO: rejestrowanie nowego użytkownika
*/
@implementation NILoginPanel : CPPanel
{
	CPTextField emailField @accessors(readonly);
	CPTextField passwordField @accessors(readonly);
	CPButton loginButton @accessors(readonly);
}

- (id)init
{
	// CPDocModalWindowMask
	self = [super initWithContentRect:CGRectMake(0,0,300,120) styleMask:CPDocModalWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		// ukrywam okno przed uruchomieniem animacji
		// [self setValue: 0 forKey: @"alphaValue"];

		[self center];
		[self setFrameOrigin:CGPointMake(CGRectGetMinX([self frame]), 0)];
		// [self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];
		// [self setHasShadow:YES];
		// [self setBackgroundColor:[CPColor whiteColor]];
		
		
		// [self orderBack:self];
/*
		CPWindowShadowStyleStandard
	    CPWindowShadowStyleMenu
	    CPWindowShadowStylePanel
*/
		// [self setShadowStyle:CPWindowShadowStyleMenu];
// console.log([self representedURL]);
		var fieldHeight = 29;

		emailField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame) + 10, 
																	  CGRectGetMinY(frame) + 10,
																	  CGRectGetWidth(frame)-20,
																	  fieldHeight)];
		[emailField setEditable:YES];
		[emailField setBezeled:YES];
		[emailField setPlaceholderString:@"Adres e-mail"];
		// [emailField setAlignment:CPRightTextAlignment];		
		[contentView addSubview:emailField];

		var usernameFrame = [emailField frame];
		
		passwordField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(usernameFrame), 
																	  CGRectGetMinY(usernameFrame) + 20 + fieldHeight/2,
																	  CGRectGetWidth(usernameFrame),
																	  fieldHeight)];
		[passwordField setEditable:YES];
		[passwordField setBezeled:YES];
		[passwordField setPlaceholderString:@"Hasło"];
		[contentView addSubview:passwordField];

		loginButton = [CPButton buttonWithTitle:"Zaloguj"];
		// ustaw położenie w lewym dolnym roku!
		[loginButton setFrameOrigin:CGPointMake(CGRectGetMaxX(frame) - 20 - CGRectGetWidth([loginButton frame]), 
												CGRectGetMaxY(frame) - 10 - CGRectGetHeight([loginButton frame]))];
		[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin ];
		// [loginButton setAction:@selector(openDocument:)];
		// [loginButton setTarget:CPApp];

		[self setDefaultButton:loginButton];
		[contentView addSubview:loginButton];
		
		//[self setValue: 1 forKey: @"alphaValue"];
		
		// [self setFrame:CGRectMake(200,0,300,200) display:YES animate:YES];
		
		
	}
	
	return self;
}

- (BOOL)canBecomeMainWindow
{
	return YES;
}

@end