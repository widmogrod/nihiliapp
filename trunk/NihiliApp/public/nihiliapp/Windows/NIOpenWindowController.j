@import <AppKit/CPWindowController.j>
@import "NIOpenWindow.j"

@implementation NIOpenWindowController : CPWindowController
{
}

- (id)init
{
	var openWindow = [[NIOpenWindow alloc] init];
	if(self = [super initWithWindow: openWindow])
	{
		[openWindow orderFront:self];
	}
	return self;
}

@end