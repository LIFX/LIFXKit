//
//  DetailViewController.m
//  LIFX Browser
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <LFXLightObserver, LFXLightCollectionObserver>

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if ([self detailItemIsALight])
	{
		LFXLight *light = (LFXLight *)self.detailItem;
		[light addLightObserver:self];
		[self updateViewForLight];
	}
	else
	{
		LFXTaggedLightCollection *taggedLightCollection = (LFXTaggedLightCollection *)self.detailItem;
		[taggedLightCollection addLightCollectionObserver:self];
		[self updateViewForLightCollection];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if ([self detailItemIsALight])
	{
		LFXLight *light = (LFXLight *)self.detailItem;
		[light removeLightObserver:self];
	}
	else
	{
		LFXTaggedLightCollection *taggedLightCollection = (LFXTaggedLightCollection *)self.detailItem;
		[taggedLightCollection removeLightCollectionObserver:self];
	}
}

- (BOOL)detailItemIsALight
{
	return [self.detailItem isKindOfClass:[LFXLight class]];
}

- (void)updateViewForLight
{
	LFXLight *light = self.detailItem;
	
	NSMutableString *string = [NSMutableString new];
	
	[string appendFormat:@"Light\n"];
	[string appendFormat:@"Label = %@\n", light.label];
	[string appendFormat:@"DeviceID = %@\n", light.deviceID];
	[string appendFormat:@"Power State = %@\n", NSStringFromLFXPowerState(light.powerState)];
	[string appendFormat:@"Color = %@\n", light.color.stringValue];
	
	self.detailDescriptionLabel.text = string;
}

- (void)updateViewForLightCollection
{
	LFXTaggedLightCollection *taggedLightCollection = self.detailItem;
	
	NSMutableString *string = [NSMutableString new];
	
	[string appendFormat:@"Tagged Light Collection\n"];
	[string appendFormat:@"Tag = %@\n", taggedLightCollection.tag];
	[string appendFormat:@"Power State = %@\n", NSStringFromLFXFuzzyPowerState(taggedLightCollection.fuzzyPowerState)];
	[string appendFormat:@"Color = %@\n", taggedLightCollection.color];
	[string appendFormat:@"Lights = %@", [taggedLightCollection.lights valueForKeyPath:@"label"]];
	
	self.detailDescriptionLabel.text = string;
}

- (IBAction)turnOn:(id)sender
{
	[self.detailItem setPowerState:LFXPowerStateOn];
}

- (IBAction)turnOff:(id)sender
{
	[self.detailItem setPowerState:LFXPowerStateOff];
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color
{
	NSLog(@"Light: %@ Did Change Color: %@", light, color);
	[self updateViewForLight];
}

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
	NSLog(@"Light: %@ Did Change Label: %@", light, label);
	[self updateViewForLight];
}

- (void)light:(LFXLight *)light didChangePowerState:(LFXPowerState)powerState
{
	NSLog(@"Light: %@ Did Change Power State: %@", light, NSStringFromLFXPowerState(powerState));
	[self updateViewForLight];
}

#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeColor:(LFXHSBKColor *)color
{
	NSLog(@"Light Collection: %@ Did Change Color: %@", lightCollection, color);
	[self updateViewForLightCollection];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeFuzzyPowerState:(LFXFuzzyPowerState)fuzzyPowerState
{
	NSLog(@"Light Collection: %@ Did Change Fuzzy Power State: %@", lightCollection, NSStringFromLFXFuzzyPowerState(fuzzyPowerState));
	[self updateViewForLightCollection];
}

@end
