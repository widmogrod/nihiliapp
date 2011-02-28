@import <AppKit/CPWindowController.j>
@import <Nihili/NIPositionAnimation.j>


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
		[[[self window] loginButton] setAction:@selector(login:)];
		[[[self window] loginButton] setTarget:self];
	}
	return self;
}

- (void)showWithAnimation
{	
	var opacityAnimation = [[NIPositionAnimation alloc] initWithWindow:[self window]];
		[opacityAnimation setStart:-CGRectGetWidth([[self window] frame])];
		[opacityAnimation setEnd:CGRectGetMinY([[self window] frame])];
		[opacityAnimation setDuration:0.5];
		[opacityAnimation startAnimation];

	// taki interwał dopełnia animację - nie efektu niepełnej animajci
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

- (id)login:(id)sender
{
	var queue = [NIQueueConnection sharedQueue];
		[queue action:@"/login" 
			   object:[self VOUser]
			   delegate:self
			   selector:@selector(loginComplite:)];

	// var opacityAnimation = [[CPPropertyAnimation alloc] initWithView:[self contentView] property:@"alphaValue"];
	// 	[opacityAnimation setStart:0];
	// 	[opacityAnimation setEnd:1];
	// 	[opacityAnimation setDuration:2];
	// 	[opacityAnimation startAnimation];
		
	// console.log([usernameField stringValue]);
	// 	console.log([passwordField stringValue]);
	// 	[self close];
}

- (id)loginComplite:(CPDictionary)aDictionary
{
	// var user = [VOUser initWithDictionary:[aDictionary valueFor]];
	console.log(aDictionary);
}

@end