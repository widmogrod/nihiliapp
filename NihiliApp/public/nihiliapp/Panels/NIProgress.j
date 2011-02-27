var SharedNIProgress = nil; 
@implementation NIProgress : CPWindowController 
{ 
        id delegate; 
        CPWindow theWindow; 
        CPProgressIndicator progressIndicator; 
} 

+ (ProgressHUD)sharedProgress
{ 
    if (!SharedNIProgress) 
        SharedNIProgress = [[NIProgress alloc] init]; 

    return SharedNIProgress; 
} 

- (id)init 
{ 
    theWindow = [[CPPanel alloc] initWithContentRect:CGRectMake(0, 0, 64, 64) 
										   styleMask:CPBorderlessWindowMask]; 

    self = [super initWithWindow:theWindow]; 
    if (self) 
	{ 
        [theWindow center]; 
        [theWindow setFloatingPanel:YES]; 
        [theWindow setBackgroundColor:[CPColor whiteColor]]; 

        var contentView = [theWindow contentView]; 

        progressIndicator = [[CPProgressIndicator alloc] initWithFrame:[contentView bounds]]; 
        [progressIndicator setStyle:CPProgressIndicatorBarStyle]; 
		[progressIndicator setUsesThreadedAnimation:YES];
        [progressIndicator sizeToFit];
		
		[progressIndicator setIndeterminate:YES];
		[progressIndicator startAnimation:self];
		[progressIndicator incrementBy:10];
		[progressIndicator incrementBy:20];
        [contentView addSubview:progressIndicator]; 
    } 
    return self; 
} 

- (void)close 
{ 
        // Convenience class to close window. 
        [[self window] close]; 
}