@import <AppKit/CPAlert.j>

@implementation NIAlert : CPAlert

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setDelegate:self];
		[self setWindowStyle:CPHUDBackgroundWindowMask];
		[self addButtonWithTitle:@"OK"];
	}

	return self;
}

+ (NIAlert)alertWithResponse:(CPDictionary)aResponse
{
	if (![aResponse count])
		return nil;

	var messages = [[aResponse valueForKey:@"messages"] objectEnumerator],
		message = nil,
		messageText = "",
		alertStyle = CPInformationalAlertStyle;

	while(message = [messages nextObject])
	{
		messageText += [message valueForKey:@"message"];
		messageText += "\n";
		
		switch([message valueForKey:@"type"])
		{
			case "INFO":	alertStyle = CPInformationalAlertStyle; break;
			case "ERROR":	alertStyle = CPCriticalAlertStyle; break;
			case "WARNING":	alertStyle = CPWarningAlertStyle; break;
		}
	}

	var alert = [[NIAlert alloc] init];
	[alert setMessageText:messageText];
	[alert setAlertStyle:alertStyle];

	return alert;
}

-(void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode 
{
	// returnCode == 0, odpowiada pierwszemu dodanemu przyciskowi tj. OK
	if (returnCode == 0)
	{
		[self close];
	}
}

@end
