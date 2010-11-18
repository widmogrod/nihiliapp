@import <AppKit/CPPanel.j>

/*
	Inspektor panelu graficznego, zostaje uruchomiony przy wczytaniu grafiki.
	Każda zmiana focus'u na panelu z grafiką powoduje usunięcie inspektora.
	Każde odzyskanie focus'u przywołuje panel inspektora.
*/
@implementation NIImageInspector : CPPanel
{
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(200,200,220,50) 
							styleMask:CPHUDBackgroundWindowMask | CPDocModalWindowMask];
	if(self)
	{
		var contentView = [self contentView],
			frame = [contentView frame];
		
		[self setWorksWhenModal:YES];
		
		var rotateSliderField = [[CPSlider alloc] initWithFrame: CGRectMake(CGRectGetMinX(frame),
																			CGRectGetMinY(frame),
																			CGRectGetWidth(frame),
																			25)];
		[contentView addSubview:rotateSliderField];
	}
	return self;
}

@end