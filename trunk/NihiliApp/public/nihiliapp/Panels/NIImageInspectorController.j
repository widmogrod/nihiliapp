@import <AppKit/CPWindowController.j>
@import "NIImageInspector.j"

var SharedNIImageInspectorController = nil;

/*
	Odpowiada za:
	- przekazywanie akcji inspektora
*/
@implementation NIImageInspectorController : CPWindowController
{
}

- (id)init
{
	var inspector = [[NIImageInspector alloc] init];
	self = [super initWithWindow: inspector];
	if(self)
	{
		// TODO: Konfigurowanie
	}
	return self;
}

+ (NIImageController)sharedController
{
	if (!SharedNIImageInspectorController)
		SharedNIImageInspectorController = [[NIImageInspectorController alloc] init];

	return SharedNIImageInspectorController;
}

@end
