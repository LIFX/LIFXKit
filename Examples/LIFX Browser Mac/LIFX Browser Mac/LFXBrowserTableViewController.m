//
//  LFXBrowserTableViewController.m
//  LIFX Browser Mac
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXBrowserTableViewController.h"
#import "LFXLightDetailViewController.h"
#import "LFXTaggedLightCollectionViewController.h"
#import <LIFXKit/LIFXKit.h>


static NSString * const LFXBrowserTableLightViewIdentifier = @"LFXBrowserTableLightViewIdentifier";
static NSString * const LFXBrowserTableLightHeaderIdentifier = @"LFXBrowserTableLightHeaderIdentifier";


@interface LFXBrowserTableViewController () <LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver>

@property (weak) IBOutlet NSView *detailContainerView;
@property (weak) IBOutlet NSTableView *tableView;

@property (strong) LFXNetworkContext *lifxNetworkContext;

@property (strong) NSArray *lights;
@property (strong) NSArray *taggedLightCollections;

@property (strong) NSViewController *detailViewController;

@end


@implementation LFXBrowserTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
        [self.lifxNetworkContext addNetworkContextObserver:self];
        [self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];
    }
    return self;
}

- (void)dealloc
{
    [self.lifxNetworkContext removeNetworkContextObserver:self];
    [self.lifxNetworkContext.allLightsCollection removeLightCollectionObserver:self];
}

- (void)awakeFromNib
{
    __strong NSTableView *tableView = self.tableView;
    [tableView reloadData];

    [self updateTitle];
    [self updateLights];
    [self updateTags];
}


#pragma mark - Display Details

- (void)displayDetailsForLight:(LFXLight *)light
{
    LFXLightDetailViewController *viewController = [[LFXLightDetailViewController alloc] initWithNibName:@"LFXLightDetailViewController" bundle:nil];
    viewController.light = light;
    [self presentDetailViewController:viewController];
}

- (void)displayDetailsForTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection
{
    LFXTaggedLightCollectionViewController *viewController = [[LFXTaggedLightCollectionViewController alloc] initWithNibName:@"LFXTaggedLightCollectionViewController" bundle:nil];
    viewController.taggedLightCollection = taggedLightCollection;
    [self presentDetailViewController:viewController];
}

- (void)clearDetailsView
{
    [self presentDetailViewController:nil];
}


#pragma mark - Detail View Controller

- (void)presentDetailViewController:(NSViewController *)viewController
{
    NSView *containerView = self.detailContainerView;

    for (NSView *childView in containerView.subviews)
    {
        [childView removeFromSuperview];
    }
    self.detailViewController = nil;

    if (viewController)
    {
        NSView *detailView = [viewController view];
        detailView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
        detailView.frame = containerView.bounds;

        [containerView addSubview:detailView];

        self.detailViewController = viewController;
    }
}


#pragma mark - Update UI

- (void)updateTitle
{
    BOOL isConnected = (self.lifxNetworkContext.connectionState == LFXConnectionStateConnected);
    self.tableView.window.title = [NSString stringWithFormat:@"LIFX Browser (%@)", isConnected ? @"connected" : @"searching"];
}

- (void)updateTags
{
    self.taggedLightCollections = self.lifxNetworkContext.taggedLightCollections;
    [self.tableView reloadData];
}

- (void)updateLights
{
    self.lights = self.lifxNetworkContext.allLightsCollection.lights;
    [self.tableView reloadData];
}


#pragma mark - LFXNetworkContextObserver

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
    NSLog(@"Network Context Did Connect");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTitle];
    });
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
    NSLog(@"Network Context Did Disconnect");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTitle];
    });
}

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
    NSLog(@"Network Context Did Add Tagged Light Collection: %@", collection.tag);
    [collection addLightCollectionObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTags];
    });
}

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
    NSLog(@"Network Context Did Remove Tagged Light Collection: %@", collection.tag);
    [collection removeLightCollectionObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTags];
    });
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Add Light: %@", lightCollection, light);
    [light addLightObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLights];
    });
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Remove Light: %@", lightCollection, light);
    [light removeLightObserver:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLights];
    });
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
    NSLog(@"Light: %@ Did Change Label: %@", light, label);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLights];
    });
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger lightsRowCount = 1 + [self.lights count]; // include a group header row
    NSInteger tagsRowCount = 1 + [self.taggedLightCollections count]; // include a group header row
    return lightsRowCount + tagsRowCount;
}


#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    BOOL isGroupRow = [self tableView:tableView isGroupRow:row];
    NSString *identifier = (isGroupRow ? LFXBrowserTableLightHeaderIdentifier : LFXBrowserTableLightViewIdentifier);

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:nil];

    if (isGroupRow)
    {
        NSString *title = (row == 0 ? @"Lights" : @"Tags");
        [cellView.textField setStringValue:title];
    }
    else
    {
        NSUInteger lightsCount = [self.lights count];
        BOOL isLightRow = (row <= lightsCount);

        if (isLightRow)
        {
            NSUInteger lightIndex = row - 1;
            LFXLight *light = self.lights[lightIndex];

            cellView.textField.stringValue = [NSString stringWithFormat:@"%@ (%@)", light.label, light.deviceID];
        }
        else
        {
            NSUInteger tagIndex = row - 2 - lightsCount;

            LFXTaggedLightCollection *taggedLightCollection = self.taggedLightCollections[tagIndex];

            cellView.textField.stringValue = [NSString stringWithFormat:@"%@ (%i devices)", taggedLightCollection.tag, (int)taggedLightCollection.lights.count];
        }
    }

    return cellView;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    BOOL result = NO;

    if (row == 0) {result = YES;}

    if (row == 1 + [self.lights count]) {result = YES;}

    return result;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    BOOL isGroupRow = [self tableView:tableView isGroupRow:row];
    BOOL shouldSelectRow = (isGroupRow == NO);
    return shouldSelectRow;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSInteger row = tableView.selectedRow;

    if (row < 0 || row > [self numberOfRowsInTableView:tableView])
    {
        [self clearDetailsView];
    }
    else
    {
        BOOL isGroupRow = [self tableView:tableView isGroupRow:row];
        if (isGroupRow == NO)
        {
            NSUInteger lightsCount = [self.lights count];
            BOOL isLightRow = (row <= lightsCount);

            if (isLightRow)
            {
                NSUInteger lightIndex = row - 1;
                LFXLight *light = self.lights[lightIndex];

                [self displayDetailsForLight:light];
            }
            else
            {
                NSUInteger tagIndex = row - 2 - lightsCount;

                LFXTaggedLightCollection *taggedLightCollection = self.taggedLightCollections[tagIndex];

                [self displayDetailsForTaggedLightCollection:taggedLightCollection];
            }
        }
    }
}

@end
