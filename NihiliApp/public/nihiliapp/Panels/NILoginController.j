@import <AppKit/CPWindowController.j>
@import <Foundation/CPTimer.j>

@import "NILoginPanel.j"
@import "../Models/NIFTPApi.j"
@import "../Models/VOConnection.j"
@import "NIAlert.j"

@import <Nihili/NIQueueConnection.j>
@import "../Models/VOUser.j"

var SharedNILoginController = nil;

@implementation NILoginController : CPWindowController
{
	VOConnection _connection;
}

+ (id)sharedController
{
	if (!SharedNILoginController)
		SharedNILoginController = [[NILoginController alloc] init];

	return SharedNILoginController;
}

- (id)init
{
	self = [super initWithWindow:[[NILoginPanel alloc] init]];

	if (self)
	{
		[[[self window] switchButton] setAction:@selector(swichForm:)];
		[[[self window] switchButton] setTarget:self];
		
		[self swichForm:nil]; // aktywuj formularz
	}
	return self;
}

- (void)showWithAnimation
{	
	[[self window] animateShow];

	// taki interwał dopełnia animację - usuwa brak efektu niepełnej animajci
	[CPTimer scheduledTimerWithTimeInterval: 0.10 target:[self window] selector:@selector(orderFront:) userInfo:nil repeats:1];
}

- (VOUser)VOUser
{
	var user = [VOUser new];
		[user setEmail:[[[self window] emailField] stringValue]];
		[user setPassword:[[[self window] passwordField] stringValue]];
		
	return user;
}

@end



@implementation NILoginController (TargetAction)

- (void)login:(id)sender
{
	var queue = [NIQueueConnection sharedQueue];
		[queue action:@"/login" 
			   object:[self VOUser]
			   delegate:self
			   selector:@selector(loginComplite:)];
}

- (void)register:(id)sender
{
	var queue = [NIQueueConnection sharedQueue];
		[queue action:@"/register" 
			   object:[self VOUser]
			   delegate:self
			   selector:@selector(loginComplite:)];
}


- (void)loginComplite:(CPDictionary)aDictionary
{
	[[NIAlert alertWithResponse:aDictionary] runModal];
	// var user = [VOUser initWithDictionary:[aDictionary valueFor]];
	// console.log(aDictionary);
}

- (void)swichForm:(id)sender
{
	var state = [sender isKindOfClass: [CPButton class]] ? [sender title] : 'Logowanie';

	switch(state)
	{
		case 'Logowanie':
		// case 'Zaloguj':
			[[[self window] submitButton] setAction:@selector(login:)];
			[[[self window] submitButton] setTarget:self];
			
			[[self window] animateLogin]; 
			
			[[[self window] submitButton] setTitle:@"Zaloguj"];
			[[[self window] switchButton] setTitle:@"Nowe konto"];
			break;

		case 'Nowe konto':
		// case 'Utwórz':
			[[[self window] submitButton] setAction:@selector(register:)];
			[[[self window] submitButton] setTarget:self];
			
			[[self window] animateRegister];
			
			[[[self window] submitButton] setTitle:@"Stwórz"];
			[[[self window] switchButton] setTitle:@"Logowanie"];
			break;
	}

	/*
		Przeliczenie położenia przycisku akcji by 
		- był zawsze wyrównany do prawje krawędzi 
		- posiadał rozmiar dopasowany do tekstu
	*/
	var	baseFrame = [[[self window] submitButton] frame];
	[[[self window] submitButton] sizeToFit];
	var	newFrame = [[[self window] submitButton] frame];
		newFrame = CGRectOffset(newFrame, CGRectGetWidth(baseFrame) - CGRectGetWidth(newFrame), 0);
	[[[self window] submitButton] setFrame:newFrame];

	[[[self window] switchButton] sizeToFit];
}

@end