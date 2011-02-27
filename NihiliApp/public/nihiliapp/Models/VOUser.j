@import <Nihili/VOObject.j>

@implementation VOUser : VOObject
{
	unsigned int user_id @accessors(getter=id, setter=setId:);
	CPString email @accessors;
	CPString password @accessors;
}

- (id)initWithDictionary:(CPDictionary)aDictionary
{
	self = [super init];
	if (self) 
	{
		[self setId: [aDictionary valueForKey:@"user_id"]];
		[self setEmail: [aDictionary valueForKey:@"username"]];
		[self setPassword: [aDictionary valueForKey:@"password"]];
	}
	return self;
}

- (VOUser)copy
{
	var copy = [[VOUser alloc] init];
	[copy setId:[self id]];
	[copy setEmail:[self email]];
	[copy setPassword:[self password]];
	return copy;
}

@end
