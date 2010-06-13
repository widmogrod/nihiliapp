@import <Foundation/CPObject.j>

var SharedApiModel = nil;

@implementation NIApiModel : CPObject
{}

+ (id)sharedApiModel
{
	if (!SharedApiModel)
		SharedApiModel = [SharedApiModel new];

	return SharedApiModel;
}

@end
