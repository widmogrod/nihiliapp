@import <Foundation/CPObject.j>

var SharedApiController = nil;

@implementation NIApiController : CPObject
{}

+ (id)sharedController
{
	if(!SharedApiController)
		SharedApiController = [NIApiController new];

	return SharedApiController;
}

- (BOOL)isAuthenticated
{
    return [[CPUserSessionManager defaultManager] status] === CPUserSessionLoggedInStatus;
}

@end
