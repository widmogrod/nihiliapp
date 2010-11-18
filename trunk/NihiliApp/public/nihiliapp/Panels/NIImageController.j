@import <AppKit/CPWindowController.j>
@import "NIImagePanel.j"
@import "NIImageInspectorController.j"

var SharedNIImageController = nil;

/*
	Odpowiada za:
	- obracanie grafiki
	- obcinanie grafiki
	- powiększanie grafiki
	- zapisywanie zmian
*/
@implementation NIImageController : CPWindowController
{
}

- (id)init
{
	var panel = [[NIImagePanel alloc] init];
	self = [super initWithWindow: panel];
	if(self)
	{
		[panel setAcceptsMouseMovedEvents:YES];
		// TODO: Konfigurowanie
	}
	return self;
}

+ (NIImageController)sharedController
{
	if (!SharedNIImageController)
		SharedNIImageController = [[NIImageController alloc] init];

	return SharedNIImageController;
}

- (void)mouseEntered:(CPEvent)anEvent
{
	[[[NIImageInspectorController sharedController] window] orderFront:self];
	
	[super mouseEntered:anEvent];
}

- (void)mouseExited:(CPEvent)anEvent
{
	[[[NIImageInspectorController sharedController] window] orderOut:self];
	
	[super mouseExited:anEvent];
}

@end
