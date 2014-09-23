//
//  MasterViewController.m
//  LIFX Browser
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <LIFXKit/LIFXKit.h>

typedef NS_ENUM(NSInteger, TableSection) {
	TableSectionLights = 0,
	TableSectionTags = 1,
};

@interface MasterViewController () <LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver>

@property (nonatomic) LFXNetworkContext *lifxNetworkContext;

@property (nonatomic) NSArray *lights;
@property (nonatomic) NSArray *taggedLightCollections;

@property (nonatomic) UIView *connectionStatusView;

@end

@implementation MasterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
		[self.lifxNetworkContext addNetworkContextObserver:self];
		[self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.connectionStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
	self.connectionStatusView.backgroundColor = [UIColor redColor];
	self.connectionStatusView.layer.cornerRadius = self.connectionStatusView.frame.size.height / 2.0;
	self.connectionStatusView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
	self.connectionStatusView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.connectionStatusView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateNavBar];
	[self updateLights];
	[self updateTags];
}

- (void)updateLights
{
	self.lights = self.lifxNetworkContext.allLightsCollection.lights;
	[self.tableView reloadData];
}

- (void)updateTags
{
	self.taggedLightCollections = self.lifxNetworkContext.taggedLightCollections;
	[self.tableView reloadData];
}

- (void)updateNavBar
{
    BOOL isConnected = (self.lifxNetworkContext.connectionState == LFXConnectionStateConnected);
	self.title = [NSString stringWithFormat:@"LIFX Browser (%@)", isConnected ? @"connected" : @"searching"];
	self.connectionStatusView.backgroundColor = isConnected ? [UIColor greenColor] : [UIColor redColor];
}

#pragma mark - LFXNetworkContextObserver

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
	NSLog(@"Network Context Did Connect");
	[self updateNavBar];
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
	NSLog(@"Network Context Did Disconnect");
	[self updateNavBar];
}

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
	NSLog(@"Network Context Did Add Tagged Light Collection: %@", collection.tag);
	[collection addLightCollectionObserver:self];
	[self updateTags];
}

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
	NSLog(@"Network Context Did Remove Tagged Light Collection: %@", collection.tag);
	[collection removeLightCollectionObserver:self];
	[self updateTags];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
	NSLog(@"Light Collection: %@ Did Add Light: %@", lightCollection, light);
	[light addLightObserver:self];
	[self updateLights];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
	NSLog(@"Light Collection: %@ Did Remove Light: %@", lightCollection, light);
	[light removeLightObserver:self];
	[self updateLights];
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
	NSLog(@"Light: %@ Did Change Label: %@", light, label);
	NSUInteger rowIndex = [self.lights indexOfObject:light];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowIndex inSection:TableSectionLights]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch ((TableSection)section)
	{
		case TableSectionLights:	return self.lights.count;
		case TableSectionTags:		return self.taggedLightCollections.count;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch ((TableSection)section)
	{
		case TableSectionLights:	return @"Lights";
		case TableSectionTags:		return @"Tags";
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	switch ((TableSection)indexPath.section)
	{
		case TableSectionLights:
		{
			LFXLight *light = self.lights[indexPath.row];
			
			cell.textLabel.text = light.label;
			cell.detailTextLabel.text = light.deviceID;
			
			break;
		}
		case TableSectionTags:
		{
			LFXTaggedLightCollection *taggedLightCollection = self.taggedLightCollections[indexPath.row];
			
			cell.textLabel.text = taggedLightCollection.tag;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%i devices", (int)taggedLightCollection.lights.count];
			
			break;
		}
	}
	
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		id detailItem;
		switch ((TableSection)indexPath.section)
		{
			case TableSectionLights:
				detailItem = self.lights[indexPath.row];
				break;
			case TableSectionTags:
				detailItem = self.taggedLightCollections[indexPath.row];
				break;
		}
        [[segue destinationViewController] setDetailItem:detailItem];
    }
}

@end
