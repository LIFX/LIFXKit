//
//  LFXTaggedLightCollectionViewController.m
//  LIFX Browser Mac
//
//  Created by Chris Miles on 23/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTaggedLightCollectionViewController.h"
#import <LIFXKit/LIFXKit.h>


@interface LFXTaggedLightCollectionViewController () <LFXLightCollectionObserver, LFXNetworkContextObserver>

@property (strong) IBOutlet NSTextField *collectionTextField;
@property (strong) IBOutlet NSButton *colorButton;

@property (strong) LFXNetworkContext *lifxNetworkContext;

@end


@implementation LFXTaggedLightCollectionViewController

- (void)awakeFromNib
{
    self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
    [self.lifxNetworkContext addNetworkContextObserver:self];

    [self.taggedLightCollection addLightCollectionObserver:self];
    [self updateViewsWithCollectionDetails];
}

- (void)dealloc
{
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel setTarget:nil];
    [panel setAction:nil];
    
    [self.taggedLightCollection removeLightCollectionObserver:self];
    [self.lifxNetworkContext removeNetworkContextObserver:self];
}

- (void)updateViewsWithCollectionDetails
{
    LFXTaggedLightCollection *taggedLightCollection = self.taggedLightCollection;

    NSMutableString *string = [NSMutableString new];

    if (taggedLightCollection)
    {
        [string appendFormat:@"Tagged Light Collection\n"];
        [string appendFormat:@"Tag = %@\n", taggedLightCollection.tag];
        [string appendFormat:@"Power State = %@\n", NSStringFromLFXFuzzyPowerState(taggedLightCollection.fuzzyPowerState)];
        [string appendFormat:@"Color = %@\n", taggedLightCollection.color];
        [string appendFormat:@"Lights = %@", [taggedLightCollection.lights valueForKeyPath:@"label"]];
    }

    NSColor *collectionColor = [self currentColor];

    NSButtonCell *colorButtonCell = self.colorButton.cell;
    [colorButtonCell setBackgroundColor:collectionColor];

    if (collectionColor)
    {
        NSColorPanel *panel = [NSColorPanel sharedColorPanel];
        panel.color = collectionColor;
    }

    self.collectionTextField.stringValue = string;
}

- (void)setTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection
{
    if (taggedLightCollection != _taggedLightCollection)
    {
        [_taggedLightCollection removeLightCollectionObserver:self];

        _taggedLightCollection = taggedLightCollection;

        [_taggedLightCollection addLightCollectionObserver:self];

        [self updateViewsWithCollectionDetails];
    }
}

- (NSColor *)currentColor
{
    LFXTaggedLightCollection *taggedLightCollection = self.taggedLightCollection;
    NSColor *collectionColor = nil;
    if (taggedLightCollection)
    {
        collectionColor = [NSColor colorWithDeviceHue:taggedLightCollection.color.hue / 360.0
                                           saturation:taggedLightCollection.color.saturation
                                           brightness:taggedLightCollection.color.brightness
                                                alpha:1.0];
    }
    return collectionColor;
}

#pragma mark - Turn On/Off Actions

- (IBAction)turnOn:(id)sender
{
    [self.taggedLightCollection setPowerState:LFXPowerStateOn];
}

- (IBAction)turnOff:(id)sender
{
    [self.taggedLightCollection setPowerState:LFXPowerStateOff];
}


#pragma mark - Color Action

- (IBAction)colorAction:(id)sender
{
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel orderFront:nil];
    [panel setAction:@selector(changeColorFromPanel:)];
    [panel setTarget:self];
    panel.color = [self currentColor];
    [panel makeKeyAndOrderFront:self];
}

- (void)changeColorFromPanel:(NSColorPanel *)colorPanel
{
    NSColor *selectedColor = [colorPanel.color colorUsingColorSpaceName:NSDeviceRGBColorSpace];

    LFXHSBKColor *hsbkColor = [LFXHSBKColor colorWithHue:selectedColor.hueComponent * 360.0
                                              saturation:selectedColor.saturationComponent
                                              brightness:selectedColor.brightnessComponent];
    [self.taggedLightCollection setColor:hsbkColor];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Add Light: %@", lightCollection, light);
    [self updateViewsWithCollectionDetails];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Remove Light: %@", lightCollection, light);
    [self updateViewsWithCollectionDetails];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeLabel:(NSString *)label
{
    NSLog(@"Light Collection: %@ Did Change Label: %@", lightCollection, label);
    [self updateViewsWithCollectionDetails];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeColor:(LFXHSBKColor *)color
{
    NSLog(@"Light Collection: %@ Did Change Color: %@", lightCollection, color);
    [self updateViewsWithCollectionDetails];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeFuzzyPowerState:(LFXFuzzyPowerState)fuzzyPowerState
{
    NSLog(@"Light Collection: %@ Did Change Fuzzy Power State: %@", lightCollection, NSStringFromLFXFuzzyPowerState(fuzzyPowerState));
    [self updateViewsWithCollectionDetails];
}


#pragma mark - LFXNetworkContextObserver

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
    if (collection == self.taggedLightCollection)
    {
        self.taggedLightCollection = nil;
    }
}

@end
