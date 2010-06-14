@import <Foundation/CPObject.j>
@import <AppKit/CPUserSessionManager.j>

BASE_URL = "http://nihiliapp.lh/";

var SharedApiModel = nil;

@implementation NIApiModel : CPObject
{
	CPString username @accessor;
	CPString password @accessor;
}

+ (id)sharedApiModel
{
	if (!SharedApiModel)
		SharedApiModel = [SharedApiModel new];

	return SharedApiModel;
}



- (void)toggleAuthentication:(id)sender
{
    if ([self isAuthenticated])
        [self logout:sender];
    else
        [self promptForAuthentication:sender];
}

- (void)logout:(id)sender
{
    username = nil;
    authenticationToken = nil;
    userImage = nil;
    userThumbnailImage = nil;
    [[CPUserSessionManager defaultManager] setStatus:CPUserSessionLoggedOutStatus];
}

- (void)promptForAuthentication:(id)sender
{
    var loginWindow = [LoginWindow sharedLoginWindow];
    [loginWindow makeKeyAndOrderFront:self];
}


@end
