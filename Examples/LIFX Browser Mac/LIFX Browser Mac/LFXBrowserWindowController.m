//
//  LFXBrowserWindowController.m
//  LIFX Browser Mac
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXBrowserWindowController.h"
#import "LFXBrowserTableViewController.h"


@interface LFXBrowserWindowController ()

@property (strong) IBOutlet LFXBrowserTableViewController *browserTableViewController;

@end


@implementation LFXBrowserWindowController

- (id)init
{
    return [super initWithWindowNibName:@"LFXBrowserWindow"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
