//
//  StatusWindowController.h
//  StatusBarApp
//
//  Created by Vitaly Dudarev on 18.05.13.
//  Copyright (c) 2013 Vitaly Dudarev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iCarousel.h"

@interface StatusWindowController : NSWindowController <NSWindowDelegate, NSURLConnectionDelegate>
{
    iCarousel *carousel;
    IBOutlet NSPanel *panel;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSTextField *textField;
    IBOutlet NSImageView *imageView;
    
    NSMutableArray *items;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;

@end
