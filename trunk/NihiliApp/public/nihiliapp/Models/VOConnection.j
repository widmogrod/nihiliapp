@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation VOConnection : CPObject
{
	CPString server @accessors;
	CPString username @accessors;
	CPString password @accessors;
	CPString pathname @accessors;
	CPString protocol @accessors;
	CPString content @accessors;
}

- (VOConnection)copy
{
	var copy = [[VOConnection alloc] init];
	[copy setServer:[self server]];
	[copy setUsername:[self username]];
	[copy setPassword:[self password]];
	[copy setPathname:[self pathname]];
	[copy setProtocol:[self protocol]];	
	[copy setContent:[self content]];	
	return copy;
}

@end
