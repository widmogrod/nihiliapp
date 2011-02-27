@import <Foundation/CPObject.j>

@implementation NIQueueConnectionRequest : CPObject
{
	id delegate @accessors;
	SEL selector @accessors;
	CPString action @accessors;
	CPDictionary userInfo @accessors;
	VOObject object @accessors;
	NIQueueConnection queueConnection @accessors;
}

- (id)initWithQueueConnection:(NIQueueConnection)aQueueConnection
{
	self = [super init]
	if (self)
	{
		[self setQueueConnection:aQueueConnection];
	}

	return self;
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	//CPLog.debug([self class] + ' connection:didReceiveData:');

	try {
		data = [data objectFromJSON];
	} catch(e) {
		CPLog.error(e);

		/*
			TODO: Przewidzieć możliwość definiowania
		*/ 
		data = {
			'status':'FAILURE',
			'messages': [
				{'type':'ERROR', 'message': 'Nieokreślony błąd połączenia'}
			]
		};
	}

	// zamiana JSON na CPDictionary
	data = [CPDictionary dictionaryWithJSObject: data recursively:YES];

	if (userInfo)
		[data setValue:userInfo forKey:@"userInfo"];

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
	[queueConnection setIsPerformingRequest:NO];
	[queueConnection performNextRequest];
}

@end