@import <AppKit/CPButton.j>
@import <AppKit/CPImage.j>

@implementation NIButton : CPButton

+ (CPButton)penButton
{
	var button = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)],
    	 image = [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[NIButton class]] pathForResource:@"pen.png"] 
													   size:CGSizeMake(16, 16)];

    [button setBordered:NO];
    [button setImage:image];
    [button setImagePosition:CPImageOnly];

	return button;
}

+ (CPButton)minusButton
{
	var button = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)],
    	 image = [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[NIButton class]] pathForResource:@"minus.png"] 
													   size:CGSizeMake(16, 16)];

    [button setBordered:NO];
    [button setImage:image];
    [button setImagePosition:CPImageOnly];

	return button;
}

+ (CPButton)plusButton
{
	var button = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)],
    	 image = [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[NIButton class]] pathForResource:@"plus.png"] 
													   size:CGSizeMake(16, 16)];

    [button setBordered:NO];
    [button setImage:image];
    [button setImagePosition:CPImageOnly];

	return button;
}

@end