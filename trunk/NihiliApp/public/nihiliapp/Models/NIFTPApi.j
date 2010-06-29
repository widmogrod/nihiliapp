@import <Foundation/CPObject.j>
@import <Foundation/CPURLRequest.j>


var NIFTPApiShared = nil,
	NIFTPApiURL = "http://nihiliapp.lh/api/connection/";

/*
	Klasa odpowiada za połączenie z API serwera odpowiedzialnego za połączenie FTP
	- kolejkowanie połączeń
	
	Umożliwia operacje na API:
	- nawiązanie połączenia
	- wylistowanie katalogów i plików
*/
@implementation NIFTPApi : CPObject
{
	CPSet _requests;
	BOOL isPerformingRequest @accessors;

	CPURLRequest _request;
	VOConnection _connection @accessors(property=connection);
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_requests = [[CPSet alloc] init];
		[self setIsPerformingRequest:NO];
	}
	return self;
}

+ (NIFTPApi)sharedApi
{
	if (!NIFTPApiShared)
		NIFTPApiShared = [[self alloc] init];

	return NIFTPApiShared;
}

- (CPURLRequest)requestWithHelper:(NIFTPApiRequestHelper)aRequestHelper
{
	// przygotuj nowy url dla Request!
	var action = NIFTPApiURL + [aRequestHelper action],
		   url = [CPURL URLWithString:action];

	var request = [CPURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	// przygotuj parametry rządania HTTP
	[request setHTTPBody:[self _bodyFromConnection:[aRequestHelper connection]]];

	return request;
}


/*
	Przygotowywuje i zwraca dane POST do rządania.
*/
- (CPString)_bodyFromConnection:(VOConnection)aConnection
{
	var body = @"server=" 	+ [aConnection server] + "&" +
			   @"username=" + [aConnection username] + "&" +
			   @"password=" + [aConnection password] + "&" +
			   @"pathname=" + [aConnection pathname] + "&" +
			   @"protocol=" + [aConnection protocol];

	return body;
}

- (void)testWithDelegate:(id)aDelegate selector:(SEL)aSelector
{
	console.log("[self connection]", [self connection]);
	
	var request = [[NIFTPApiRequestHelper alloc] initWithApi:self];
	[request setDelegate:aDelegate];
	[request setSelector:aSelector];
	[request setConnection:[self connection]];
	[request setAction:@"test"];
	
	[_requests addObject:request];
	[self performNextRequest];
}

- (void)lsWithDelegate:(id)aDelegate selector:(SEL)aSelector
{
	var request = [[NIFTPApiRequestHelper alloc] initWithApi:self];
	[request setDelegate:aDelegate];
	[request setSelector:aSelector];
	[request setConnection:[self connection]];
	[request setAction:@"ls"];

	[_requests addObject:request];
	[self performNextRequest];
}

/*
	Wykonaj następne połączenie
*/
- (void)performNextRequest
{
	if ([_requests count])
	{
		if (![self isPerformingRequest])
		{
			[self setIsPerformingRequest:YES];

			var enumerator = [_requests objectEnumerator],
				requestHelper = [enumerator nextObject];

			[CPURLConnection connectionWithRequest:[self requestWithHelper:requestHelper] delegate:requestHelper];
			
			[_requests removeObject:requestHelper];
		}
	}
}

@end


@implementation NIFTPApiRequestHelper : CPObject
{
	id delegate @accessors;
	SEL selector @accessors;
	SPString action @accessors;
	VOConnection _connection @accessors;
	NIFTPApi api @accessors;
}

- (id)initWithApi:(NIFTPApi)anApi
{
	self = [super init]
	if (self)
	{
		[self setApi:anApi];
	}

	return self;
}

-(void)setConnection:(VOConnection)aConnection
{
	_connection = aConnection;
}

- (VOConnection)connection
{
	return _connection;
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	data = [data objectFromJSON];
	data = [CPDictionary dictionaryWithJSObject: data];
	[delegate performSelector:selector withObject:data];
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
	/*
		Jako że odblokowywanie requestu odbywa się w ostatniej metodzie (tutaj)
		może wystąpić sytuacja że jeżeli @see connection:didReceiveData:
		- a dokładnie delegate - wykonywać będzie dłuższą akcję nastąpi
		zablokowanie wątku... i następny request może się nie wykonac..
		.. to jest do przemyślenia..
	*/
	[api setIsPerformingRequest:NO];
	[api performNextRequest];
}

@end
