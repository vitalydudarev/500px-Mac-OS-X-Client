//
//  AppDelegate.m
//  StatusBarApp
//
//  Created by Vitaly Dudarev on 14.05.13.
//  Copyright (c) 2013 Vitaly Dudarev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    //[statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Insta"];
    [statusItem setTarget:self];
    [statusItem setAction:@selector(statusItemAction:)];
    //[statusItem setView:view];
}

- (void)openWindow:(id)sender {
    NSWindow *window = [self window]; // Get the window to open
    [window makeKeyAndOrderFront:nil];
}

- (void) statusItemAction:(id) sender
{
    // Get the frame and origin of the control of the current event
    // (= our NSStatusItem)
    CGRect eventFrame = [[[NSApp currentEvent] window] frame];
    CGPoint eventOrigin = eventFrame.origin;
    CGSize eventSize = eventFrame.size;
    
    // Create a window controller from your xib file
    // and get the window reference
    if (self.windowController == nil)
    {
        self.windowController = [[StatusWindowController alloc] initWithWindowNibName:@"Panel"];
    NSWindow *window = [self.windowController window];
    
    // Calculate the position of the window to
    // place it centered below of the status item
    CGRect windowFrame = window.frame;
    CGSize windowSize = windowFrame.size;
    CGPoint windowTopLeftPosition = CGPointMake(eventOrigin.x + eventSize.width/2.f - windowSize.width/2.f, eventOrigin.y - 20);
    
    // Set position of the window and display it
    [window setFrameTopLeftPoint:windowTopLeftPosition];
    [window makeKeyAndOrderFront:self];
    
    // Show your window in front of all other apps
    [NSApp activateIgnoringOtherApps:YES];
    }
    else
    {
        NSWindow *window = [self.windowController window];
        [window close];
    }
}

@end
