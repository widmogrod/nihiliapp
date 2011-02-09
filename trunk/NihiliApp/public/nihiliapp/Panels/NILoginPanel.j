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
	// CPDocModalWindowMask
	self = [super initWithContentRect:CGRectMake(0,0,300,120) styleMask:CPDocModalWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];
			
		// ukrywam okno przed uruchomieniem animacji
		[self setValue: 0 forKey: @"alphaValue"];

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

		usernameField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame) + 10, 
																	  CGRectGetMinY(frame) + 10,
																	  CGRectGetWidth(frame)-20,
																	  fieldHeight)];
		[usernameField setEditable:YES];
		[usernameField setBezeled:YES];
		[usernameField setPlaceholderString:@"Użytkownik"];
		// [usernameField setAlignment:CPRightTextAlignment];		
		[contentView addSubview:usernameField];

		var usernameFrame = [usernameField frame];
		
		passwordField = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(usernameFrame), 
																	  CGRectGetMinY(usernameFrame) + 20 + fieldHeight/2,
																	  CGRectGetWidth(usernameFrame),
																	  fieldHeight)];
		[passwordField setEditable:YES];
		[passwordField setBezeled:YES];
		[passwordField setPlaceholderString:@"Hasło"];
		[contentView addSubview:passwordField];

		var loginButton = [CPButton buttonWithTitle:"Zaloguj"];
			// ustaw położenie w lewym dolnym roku!
			[loginButton setFrameOrigin:CGPointMake(CGRectGetMaxX(frame) - 20 - CGRectGetWidth([loginButton frame]), 
													CGRectGetMaxY(frame) - 10 - CGRectGetHeight([loginButton frame]))];
			[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin ];
			[loginButton setAction:@selector(login:)];
			[loginButton setTarget:self];

		[self setDefaultButton:loginButton];
		[contentView addSubview:loginButton];
		
		[self setValue: 1 forKey: @"alphaValue"];
		
		// [self setFrame:CGRectMake(200,0,300,200) display:YES animate:YES];
		
		var opacityAnimation = [[CPPositionAnimation alloc] initWithWindow:self];
			[opacityAnimation setStart:-CGRectGetWidth([self frame])];
			[opacityAnimation setEnd:CGRectGetMinY([self frame])];
			[opacityAnimation setDuration:0.5];
			[opacityAnimation startAnimation];
	}
	
	return self;
}

- (id)login:(id)sender
{
	

	// var opacityAnimation = [[CPPropertyAnimation alloc] initWithView:[self contentView] property:@"alphaValue"];
	// 	[opacityAnimation setStart:0];
	// 	[opacityAnimation setEnd:1];
	// 	[opacityAnimation setDuration:2];
	// 	[opacityAnimation startAnimation];
		
	// console.log([usernameField stringValue]);
	// 	console.log([passwordField stringValue]);
	// 	[self close];
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



/*
  A VERY basic, but functional, property for Cappuccino. This is not CoreAnimation,
  nor anything similar. However, it will handle some basic property animations, and
  more can easily be added.
*/

@implementation CPPositionAnimation : CPAnimation
{
	CPWindow _window;
	
	float _x;

	CPValue _start;
	CPValue _end;
}

- (id)initWithWindow:(CPWindow)aWindow
{
	self = [super initWithDuration:1.0 animationCurve:CPAnimationLinear];
	if(self)
	{
		if([aWindow respondsToSelector:@selector(frame)]){
			_window = aWindow;
			_x = CGRectGetMinX([aWindow frame]);
		} else {
			return null;
		}
	}

	return self;
}

- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];

	progress = [self currentValue];	
	progress = (progress * (_end - _start)) + _start;

	[_window setFrameOrigin:CGPointMake(_x, progress)];
}

- (void)setStart:(float)aValue
{
	_start = aValue;
}

- (float)start
{
	return _start;
}

- (void)setEnd:(float)aValue
{
	_end = aValue;
}

- (float)end
{
	return _end;
}

@end



/*
  A VERY basic, but functional, property for Cappuccino. This is not CoreAnimation,
  nor anything similar. However, it will handle some basic property animations, and
  more can easily be added.
*/

@implementation CPPropertyAnimation : CPAnimation
{
	CPView _view;
	CPString _keyPath;

	CPValue _start;
	CPValue _end;
}

- (id)initWithView:(CPView)aView property:(NSString)keyPath
{
	self = [super initWithDuration:1.0 animationCurve:CPAnimationLinear];
	if(self)
	{
		if([aView respondsToSelector:keyPath]){
			_view = aView;
			_keyPath = keyPath;
		} else {
			return null;
		}
	}

	return self;
}

- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];

	progress = [self currentValue];

	if(_keyPath == 'width' || _keyPath == 'height')
        progress = (progress * (_end - _start)) + _start;
    else if(_keyPath == 'size')
        progress = CGSizeMake((progress * (_end.width - _start.width)) + _start.width, (progress * (_end.height - _start.height)) + _start.height);
	else if(_keyPath == 'alphaValue')
		progress = (progress * (_end - _start)) + _start;
        
	[_view setValue:progress forKey:_keyPath];
}

- (void)setStart:(id)aValue
{
	_start = aValue;
}

- (id)start
{
	return _start;
}

- (void)setEnd:(id)aValue
{
	_end = aValue;
}

- (id)end
{
	return _end;
}

@end