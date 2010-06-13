/*
 * AppController.j
 * NihiliApp
 *
 * Created by You on June 13, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Windows/NILoginWindow.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

    [label setStringValue:@"Hello World!"];
    [label setFont:[CPFont boldSystemFontOfSize:24.0]];

    [label sizeToFit];

    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setCenter:[contentView center]];

    [contentView addSubview:label];

    [theWindow orderFront:self];
    
    var loginWindow = [NILoginWindow sharedLoginWindow];
    [loginWindow makeKeyAndOrderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end
