@import <Nihili/VOObject.j>

@implementation VOUser : VOObject
{
	unsigned int 	user_id @accessors(getter=id, setter=setId:);
	CPString 		email @accessors;
	CPString 		password;
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

- (void)setPassword:(CPString)aPassword
{
	password = MD5(aPassword);
}

- (void)setPasswordWithoutMD5:(CPString)aPassword
{
	password = aPassword;
}

- (CPString)password
{
	return password;
}

- (VOUser)copy
{
	var copy = [[VOUser alloc] init];
	[copy setId:[self id]];
	[copy setEmail:[self email]];
	[copy setPasswordWithoutMD5:[self password]];
	return copy;
}

@end