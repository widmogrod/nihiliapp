@import <AppKit/CPWindowController.j>
@import "../Windows/NIOpenWindow.j"

var SharedOpenWindowController = nil;

/*
	Głownym zadaniem kontrolera jest obsługa zdarzeń,
	które są wywolywane w oknie NIOpenWindow 
	poprzez kliknięcie przycisków zaimplementowanych w oknie
*/
@implementation NIOpenWindowController : CPWindowController
{}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		[self setWindow:[[NIOpenWindow alloc] init]];
	}

	return self;
}

+ (id)sharedController
{
	if (!SharedOpenWindowController)
		SharedOpenWindowController = [[NIOpenWindowController alloc] init];

	return SharedOpenWindowController;
}

/*
	Otwórz panel tworzenia nowego projektu
*/
- (void)createProject:(id)sender
{

}

/*
	Otwórz panel projektu i przekaż do niego dane
*/
- (void)editProject:(id)sender
{

}

/*
	Otwórz panel potwierdzenia usunięcia projektu
*/
- (void)deleteProject:(id)sender
{

}


@end
