@import <AppKit/CPPanel.j>
@import <AppKit/CPSecureTextField.j>
@import <Nihili/NIPositionAnimation.j>
@import <Nihili/NIPropertyAnimation.j>

/*
	Panel logowania jest zawsze widoczny nad wszystkimi oknami.
	Jego funkcjonalność to:
	- TODO: nie można zamknąć okna bez poprawnego logowania
	- TODO: logowanie użytkownika
	- TODO: rejestrowanie nowego użytkownika
*/
@implementation NILoginPanel : CPPanel
{
	CPTextField 		emailField @accessors(readonly);
	CPSecureTextField 	passwordField @accessors(readonly);
	CPSecureTextField 	repasswordField @accessors(readonly);
	CPButton 			submitButton @accessors(readonly);
	CPButton 			switchButton @accessors(readonly);
}

- (id)init
{
	// CPDocModalWindowMask
	self = [super initWithContentRect:CGRectMake(0,0,300,145) styleMask:CPDocModalWindowMask];
	
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
		
		passwordField = [[CPSecureTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(usernameFrame), 
																	  		CGRectGetMinY(usernameFrame) + 20 + fieldHeight/2,
																	  		CGRectGetWidth(usernameFrame),
																	  		fieldHeight)];
		[passwordField setEditable:YES];
		[passwordField setBezeled:YES];
		[passwordField setPlaceholderString:@"Hasło"];
		[contentView addSubview:passwordField];
		
		var passwordFrame = [passwordField frame];
		
		repasswordField = [[CPSecureTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordFrame), 
																	  		CGRectGetMinY(passwordFrame) + 20 + fieldHeight/2,
																	  		CGRectGetWidth(passwordFrame),
																	  		fieldHeight)];
		[repasswordField setEditable:YES];
		[repasswordField setBezeled:YES];
		[repasswordField setPlaceholderString:@"Powtórz hasło"];
		[contentView addSubview:repasswordField];
		[repasswordField setHidden: YES];

		submitButton = [CPButton buttonWithTitle:"Zaloguj"];
		// ustaw położenie w prawym dolnym roku!
		[submitButton setFrameOrigin:CGPointMake(CGRectGetMaxX(frame) - 20 - CGRectGetWidth([submitButton frame]), 
												CGRectGetMaxY(frame) - 10 - CGRectGetHeight([submitButton frame]))];

		[submitButton setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
		// [submitButton setAction:@selector(openDocument:)];
		// [submitButton setTarget:CPApp];

		[self setDefaultButton:submitButton];
		[contentView addSubview:submitButton];
		
		//[self setValue: 1 forKey: @"alphaValue"];
		
		// [self setFrame:CGRectMake(200,0,300,200) display:YES animate:YES];
		
		switchButton = [CPButton buttonWithTitle:"Nowe konto"];
		// ustaw położenie w lewym dolnym roku!
		[switchButton setFrameOrigin:CGPointMake(CGRectGetMinX(frame) + 15, 
												CGRectGetMaxY(frame) - 10 - CGRectGetHeight([switchButton frame]))];

		[switchButton setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
		[contentView addSubview:switchButton];
	}
	
	return self;
}

- (void)animateLogin
{
	/*
		Przeliczenie położenia przycisku akcji by 
		- był zawsze wyrównany do prawje krawędzi 
		- posiadał rozmiar dopasowany do tekstu
	*/
	var	baseFrame = [self frame];
	var	repasswordFrame = [repasswordField frame];
	var newFrame = CGRectMake(CGRectGetMinX(baseFrame), 
							  CGRectGetMinY(baseFrame), 
							  CGRectGetWidth(baseFrame), 
							  CGRectGetHeight(baseFrame) - CGRectGetHeight(repasswordFrame));

	[repasswordField setHidden: YES];	
	
	var positionAnimation = [[NIPositionAnimation alloc] initWithWindow:self];
		[positionAnimation setStart:baseFrame];
		[positionAnimation setEnd:newFrame];
		[positionAnimation setDuration:0.2];
		[positionAnimation startAnimation];

	var	opacityAnimation = [[NIPropertyAnimation alloc] initWithView:repasswordField property:@"alphaValue"];
		[opacityAnimation setStart:1];
		[opacityAnimation setEnd:0];
		[opacityAnimation setDuration:0.5];
		[opacityAnimation startAnimation];
}

- (void)animateRegister
{
	/*
		Przeliczenie położenia przycisku akcji by 
		- był zawsze wyrównany do prawje krawędzi 
		- posiadał rozmiar dopasowany do tekstu
	*/
	var	baseFrame = [self frame];
	var	repasswordFrame = [repasswordField frame];
	var newFrame = CGRectMake(CGRectGetMinX(baseFrame), 
							  CGRectGetMinY(baseFrame), 
							  CGRectGetWidth(baseFrame), 
							  CGRectGetHeight(baseFrame) + CGRectGetHeight(repasswordFrame));



	var positionAnimation = [[NIPositionAnimation alloc] initWithWindow:self];
		[positionAnimation setStart:baseFrame];
		[positionAnimation setEnd:newFrame];
		[positionAnimation setDuration:0.2];
		[positionAnimation startAnimation];

	var	opacityAnimation = [[NIPropertyAnimation alloc] initWithView:repasswordField property:@"alphaValue"];
		[opacityAnimation setStart:0];
		[opacityAnimation setEnd:1];
		[opacityAnimation setDuration:0.5];
		[opacityAnimation startAnimation];

	[repasswordField setHidden: NO];
}

- (void)animateShow
{
	var frame = [self frame];
	var opacityAnimation = [[NIPositionAnimation alloc] initWithWindow:self];
		[opacityAnimation setStart:CGRectMake(CGRectGetMinX(frame), -CGRectGetWidth(frame)), CGRectGetWidth(frame), CGRectGetHeight(frame)];
		[opacityAnimation setEnd:  CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame)), CGRectGetWidth(frame), CGRectGetHeight(frame)];
		[opacityAnimation setDuration:0.5];
		[opacityAnimation startAnimation];
}

- (BOOL)canBecomeMainWindow
{
	return YES;
}

@end