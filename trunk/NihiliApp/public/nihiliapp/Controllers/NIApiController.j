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

- (bool)testConnectionToHost:(CPString)aHost user:(CPString)anUser pass:(CPString)aPass
{
	var url = @"http://nihiliapp.lh/api/siteconfig/test";
	var request = [CPURLRequest requestWithURL:url];
	var body = @"hostname=" + aHost + "&" +
			 	@"username=" + anUser + "&" +
			 	@"password=" + aPass;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:[self authorisationValue] forHTTPHeaderField:@"Authorization"];
//	[request setValue:[body length] forHTTPHeaderField:@"Content-Length"];
 	[request setHTTPBody:body];

	[CPURLConnection connectionWithRequest:request delegate:self];
}

// Called when the connection encounters an error.
-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{

}

// Called when the connection receives a response.
-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
	console.log("response", [response statusCode]);
}

// Called when the connection has received data.
-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	console.log(data);
}

// Called when the URL has finished loading.
-(void)connectionDidFinishLoading:(CPURLConnection)connection
{

}

@end
