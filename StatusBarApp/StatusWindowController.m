//
//  StatusWindowController.m
//  StatusBarApp
//
//  Created by Vitaly Dudarev on 18.05.13.
//  Copyright (c) 2013 Vitaly Dudarev. All rights reserved.
//

#import "StatusWindowController.h"

NSString *_consumerKey = @"b4XqrqRsnI8xP9ioAbzPQh0x6ooG4Y3G5KhpfOq6";
NSString *_apiUrl = @"https://api.500px.com/v1";

@interface StatusWindowController ()

@end

@implementation StatusWindowController

@synthesize carousel;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        //NSData *data = [self sendAsyncRequest];
        //[self parseResponse:data];
        items = [NSMutableArray array];
        for (int i = 0; i < 10; i++)
        {
            [items addObject:[NSNumber numberWithInt:i]];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runSearch) name:NSControlTextDidChangeNotification object:searchField];
    
    return self;
}

- (void)awakeFromNib
{
    //configure carousel
    carousel.type = /*iCarouselTypeLinear;*/ iCarouselTypeCoverFlow2;
    //carousel.vertical = YES;
    [self.window makeFirstResponder:carousel];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view
{
    NSTextField *label = nil;
    
    //create new view if no view is available for recycling
	if (view == nil)
	{
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
		//NSImage *image = [items objectAtIndex:0];
        
        NSImage *image = [NSImage imageNamed:@"page.png"];
       	view = [[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)];
        [(NSImageView *)view setImage:image];
        [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
        
        label = [[NSTextField alloc] init];
        [label setBackgroundColor:[NSColor clearColor]];
        [label setBordered:NO];
        [label setSelectable:NO];
        [label setAlignment:NSCenterTextAlignment];
        [label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
        label.tag = 1;
        [view addSubview:label];
	}
	else
	{
		//get a reference to the label in the recycled view
		label = (NSTextField *)[view viewWithTag:1];
	}
    
	//set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
	[label setStringValue:[NSString stringWithFormat:@"%lu", index]];
    [label sizeToFit];
    [label setFrameOrigin:NSMakePoint((view.bounds.size.width - label.frame.size.width)/2.0,
                                      (view.bounds.size.height - label.frame.size.height)/2.0)];
	
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return 2;
}

- (NSView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(NSView *)view
{
	NSTextField *label = nil;
    
    //create new view if no view is available for recycling
	if (view == nil)
	{
        //NSImage *image = [items objectAtIndex:0];
		NSImage *image = [NSImage imageNamed:@"page.png"];
       	view = [[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)];
        [(NSImageView *)view setImage:image];
        [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
        
        label = [[NSTextField alloc] init];
        [label setBackgroundColor:[NSColor clearColor]];
        [label setBordered:NO];
        [label setSelectable:NO];
        [label setAlignment:NSCenterTextAlignment];
        [label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
        label.tag = 1;
        //[view addSubview:label];
	}
	else
	{
        //get a reference to the label in the recycled view
		label = (NSTextField *)[view viewWithTag:1];
	}
    
	//set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
	[label setStringValue:(index == 0)? @"[": @"]"];
    [label sizeToFit];
    [label setFrameOrigin:NSMakePoint((view.bounds.size.width - label.frame.size.width)/2.0,
                                      (view.bounds.size.height - label.frame.size.height)/2.0)];
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //set correct view size
    //because the background image on the views makes them too large
    return 200.0f;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //reduce item spacing to compensate
            //for drop shadow and reflection around views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //NSData *data = [self sendAsyncRequest];
    //[self parseResponse:data];
    //[self sendRequest];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillClose:(NSNotification *)notification
{
    [NSApp terminate:0];
}

- (void)runSearch
{
    NSString *searchFormat = @"";
    NSString *searchString = [searchField stringValue];
    if ([searchString length] > 0)
    {
        searchFormat = NSLocalizedString(@"Search for ‘%@’…", @"Format for search request");
    }
    NSString *searchRequest = [NSString stringWithFormat:searchFormat, searchString];
    [textField setStringValue:searchRequest];
}

- (NSData *)sendAsyncRequest
{
    NSString *feature = @"popular";
    NSString *params = [NSString stringWithFormat:@"photos?feature=%@"
                                                          "&image_size=4"
                                                          "&consumer_key=%@", feature, _consumerKey];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSURL *fullUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _apiUrl, params]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: fullUrl];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return data;
}

- (void)parseResponse:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *photos = [json objectForKey:@"photos"];

    //for (NSString *key in photos)
    {
        id value = [photos objectAtIndex:0];
        NSString *imageUrl = [value objectForKey:@"image_url"];
        NSImage *image = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:imageUrl]];
        
        items = [NSMutableArray array];
        for (int i = 0; i < 10; i++)
        {
            [items addObject:image];
        }
        //[imageView setImage:image];
        //break;
    }
}

- (void)sendRequest
{
    NSString *consumerKey = @"b4XqrqRsnI8xP9ioAbzPQh0x6ooG4Y3G5KhpfOq6";
    NSString *apiUrl = @"https://api.500px.com/v1";
    NSString *request = @"popular";
    NSString *customUrl = [NSString stringWithFormat: @"%@/photos?feature=%@&image_size=4&consumer_key=%@", apiUrl, request, consumerKey];
    
    //NSString *urlString = [NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=%@", request];
    
    NSURL *url = [NSURL URLWithString: customUrl];
    
    NSString *response = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error: NULL];
    
    
    NSLog(@"%@", response);
    
    NSError *error;
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSString *feature = [json objectForKey:@"feature"];
    NSString *totalItems = [json objectForKey:@"total_items"];
    NSString *totalPages = [json objectForKey:@"total_pages"];
    
    NSString *result = [NSString stringWithFormat:@"Feature: %@\nTotal Pages: %@\nTotal Items: %@", feature, totalPages, totalItems];
    
    [textField setStringValue:result];
    
    NSDictionary *photos = [json objectForKey:@"photos"];
    NSImage *image = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:@"http://content.onliner.by/news/2013/05/large/b11a7b60d067a85fd72aeb169ca0f21c_1368868173.jpg"]];
    [imageView setImage:image];
    //[photos valueAtIndex:0 inPropertyWithKey:<#(NSString *)#>]
}

@end
