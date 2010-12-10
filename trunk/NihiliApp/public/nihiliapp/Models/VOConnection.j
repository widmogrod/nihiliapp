@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation VOConnection : CPObject
{
	unsigned int _id @accessors(getter=id,setter=setId:);
	CPString server @accessors;
	CPString username @accessors;
	CPString password @accessors;
	CPString pathname @accessors;
	CPString protocol @accessors;
	CPString content @accessors;
}

- initWithDictionary:(CPDictionary)aDictionary
{
	self = [super init];
	if (self) 
	{
		[self setId: [aDictionary valueForKey:@"connection_id"]];
		[self setServer: [aDictionary valueForKey:@"server"]];
		[self setUsername: [aDictionary valueForKey:@"username"]];
		[self setPassword: [aDictionary valueForKey:@"password"]];
		[self setProtocol: [aDictionary valueForKey:@"protocol"]];
		[self setPathname: [aDictionary valueForKey:@"pathname"]];
		[self setContent: [aDictionary valueForKey:@"content"]];
	}
	return self;
}

- (VOConnection)copy
{
	var copy = [[VOConnection alloc] init];
	[copy setId:[self id]];
	[copy setServer:[self server]];
	[copy setUsername:[self username]];
	[copy setPassword:[self password]];
	[copy setPathname:[self pathname]];
	[copy setProtocol:[self protocol]];	
	[copy setContent:[self content]];	
	return copy;
}

@end
