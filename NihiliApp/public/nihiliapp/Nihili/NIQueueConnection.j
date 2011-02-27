@import <Foundation/CPObject.j>
@import <Foundation/CPURLRequest.j>
@import <Nihili/NIQueueConnectionRequest.j>


var NIQueueConnectionShared = nil,
	NIQueueConnectionBaseURL = location.protocol +"//"+ location.host +"/";

/*
	Klasa odpowiada za:
	- kolejkowanie połączeń
	- komunikację z serwerem via JSON data
*/
@implementation NIQueueConnection : CPObject
{
	CPSet _requestsQueue;
	BOOL isPerformingRequest @accessors;

	CPURLRequest _request;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_requestsQueue = [[CPSet alloc] init];
		[self setIsPerformingRequest:NO];
	}
	return self;
}

+ (NIQueueConnection)sharedQueue
{
	if (!NIQueueConnectionShared)
		NIQueueConnectionShared = [[self alloc] init];

	return NIQueueConnectionShared;
}

- (CPURLRequest)requestWithQueuedRequest:(NIQueueConnectionRequest)aQueuedRequest
{
	// przygotuj nowy url dla Request!
	var action = NIQueueConnectionBaseURL + [aQueuedRequest action],
		   url = [CPURL URLWithString:action];

	var request = [CPURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	// przygotuj parametry rządania HTTP
	[request setHTTPBody:[[aQueuedRequest object] toJSONString]];

	return request;
}

- (void)action:(CPString)anAction object:(VOObject)anObject delegate:(id)aDelegate selector:(SEL)aSelector
{
	var request = [[NIQueueConnectionRequest alloc] initWithQueueConnection:self];
	[request setAction:anAction];
	[request setObject:anObject];
	[request setDelegate:aDelegate];
	[request setSelector:aSelector];

	[_requestsQueue addObject:request];

	[self performNextRequest];
}

- (void)action:(CPString)anAction object:(VOObject)anObject delegate:(id)aDelegate selector:(SEL)aSelector userInfo:(CPDictionary)anUserInfo
{
	var request = [[NIQueueConnectionRequest alloc] initWithQueueConnection:self];
	[request setAction:anAction];
	[request setObject:anObject];
	[request setDelegate:aDelegate];
	[request setSelector:aSelector];
	[request setUserInfo:anUserInfo];

	[_requestsQueue addObject:request];

	[self performNextRequest];
}

/*
	Wykonaj następny request
*/
- (void)performNextRequest
{
	if ([_requestsQueue count])
	{
		if (![self isPerformingRequest])
		{
			[self setIsPerformingRequest:YES];

			var enumerator = [_requestsQueue objectEnumerator],
				queuedRequest = [enumerator nextObject];

			[CPURLConnection connectionWithRequest:[self requestWithQueuedRequest:queuedRequest] delegate:queuedRequest];
			
			[_requestsQueue removeObject:queuedRequest];
		}
	}
}

@end