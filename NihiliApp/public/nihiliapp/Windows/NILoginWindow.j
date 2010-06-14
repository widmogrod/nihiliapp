@import <AppKit/CPWindow.j>

var SharedLoginWindow = nil;

@implementation NILoginWindow : CPWindow
{}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,200,200) styleMask:CPTitledWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Logowanie"]

		var buttonBarHeight = 25;

		var buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - buttonBarHeight,
																	 CGRectGetWidth(frame), buttonBarHeight)];

		[contentView addSubview:buttonBar];

		var popUpButton = [CPButtonBar actionPopupButton];
		[popUpButton addItemWithTitle:@"Item1"];

		var buttons = [
			[CPButtonBar plusButton],
			[CPButtonBar minusButton],
			popUpButton
		];
		
		[buttonBar setButtons:buttons];
		
	}
	
	return self;
}

+ (id)sharedLoginWindow
{
	if (!SharedLoginWindow)
		SharedLoginWindow = [[NILoginWindow alloc] init];

	return SharedLoginWindow;
}

@end
