@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

var NIURLFTPConnection = @"http://nihiliapp.lh/api/connection/ls";

@implementation NIFTPConnection : CPObject
{
	CPString _server @accessors(property=server);
	CPString _username @accessors(property=username);
	CPString _password @accessors(property=password);
	CPString _connectionType @accessors(property=connectionType);
	CPString _path @accessors(property=path);
	int	_port @accessors(property=port);
}

+ (NIFTPConnection)connectionToServer:(CPString)aServer
							 username:(CPString)anUsername
							 password:(CPString)aPassword
{
	return [[NIFTPConnection alloc] initWithServer:aServer username:anUsername password:aPassword];
}

- (id)initWithServer:(CPString)aServer
			username:(CPString)anUsername
			password:(CPString)aPassword
{
	self= [super init];

	if (self)
	{
		_server   = aServer;
		_username = anUsername;
		_password = aPassword;
	}
	
	return self;
}

- (void)connectionWithDelegate:(id)aDelegate
{
	var request = [CPURLRequest requestWithURL:NIURLFTPConnection];
	var body = @"server=" + _server + "&" +
			   @"username=" + _username + "&" +
			   @"password=" + _password + "&" +
			   @"connectionType=" + _connectionType;


    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:[self authorisationValue] forHTTPHeaderField:@"Authorization"];
//	[request setValue:[body length] forHTTPHeaderField:@"Content-Length"];
 	[request setHTTPBody:body];

	[CPURLConnection connectionWithRequest:request delegate:aDelegate];
}

@end
