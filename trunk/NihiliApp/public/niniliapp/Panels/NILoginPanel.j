@import <AppKit/CPPanel.j>

var SharedLoginPanel = nil;

@implementation NILoginPanel : CPPanel
{}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(0,0,400,200) styleMask:CPHUDBackgroundWindowMask | CPDocModalWindowMask];
	
	if (self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];

		[self center];
		[self setTitle:@"Logowanie w panelu"]
		
		[self setFloatingPanel:YES];
		[self setWorksWhenModal:YES];

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
