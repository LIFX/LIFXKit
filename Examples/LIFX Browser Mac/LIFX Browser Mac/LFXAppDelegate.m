//
//  LFXAppDelegate.m
//  LIFX Browser Mac
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXAppDelegate.h"
#import "LFXBrowserWindowController.h"


@interface LFXAppDelegate ()

@property (strong) LFXBrowserWindowController *browserWindowController;

@end


@implementation LFXAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initialiseBrowserWindow];
    [self.browserWindowController showWindow:nil];
}

- (void)initialiseBrowserWindow
{
    LFXBrowserWindowController *browserWindowController = [[LFXBrowserWindowController alloc] init];
    self.browserWindowController = browserWindowController;
}

@end
