//
//  AppDelegate.h
//  StatusBarApp
//
//  Created by Vitaly Dudarev on 14.05.13.
//  Copyright (c) 2013 Vitaly Dudarev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighligth;
    IBOutlet NSView *view;
}

@property(strong, nonatomic) StatusWindowController *windowController;
@property (assign) IBOutlet NSWindow *window;

@end
