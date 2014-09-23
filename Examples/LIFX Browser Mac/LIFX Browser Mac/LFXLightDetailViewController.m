//
//  LFXLightDetailViewController.m
//  LIFX Browser Mac
//
//  Created by Chris Miles on 23/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLightDetailViewController.h"
#import <LIFXKit/LIFXKit.h>


@interface LFXLightDetailViewController () <LFXLightObserver, LFXLightCollectionObserver>

@property (strong) IBOutlet NSButton *colorButton;
@property (strong) IBOutlet NSTextField *deviceLabelTextField;

@property (strong) LFXNetworkContext *lifxNetworkContext;

@end


@implementation LFXLightDetailViewController

- (void)awakeFromNib
{
    self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
    [self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];

    [self.light addLightObserver:self];
    [self updateViewsWithLightDetails];
}

- (void)dealloc
{
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel setTarget:nil];
    [panel setAction:nil];

    [self.light removeLightObserver:self];
    [self.lifxNetworkContext.allLightsCollection removeLightCollectionObserver:self];
}

- (void)updateViewsWithLightDetails
{
    LFXLight *light = self.light;

    NSMutableString *string = [NSMutableString new];

    if (light)
    {
        [string appendFormat:@"Light\n"];
        [string appendFormat:@"Label = %@\n", light.label];
        [string appendFormat:@"DeviceID = %@\n", light.deviceID];
        [string appendFormat:@"Mesh FW Version = %@\n", light.meshFirmwareVersion];
        [string appendFormat:@"WIFI FW Version = %@\n", light.wifiFirmwareVersion];
        [string appendFormat:@"Power State = %@\n", NSStringFromLFXPowerState(light.powerState)];
        [string appendFormat:@"Color = %@\n", light.color.stringValue];
    }

    NSColor *lightColor = [self currentColor];

    NSButtonCell *colorButtonCell = self.colorButton.cell;
    [colorButtonCell setBackgroundColor:lightColor];

    if (lightColor)
    {
        NSColorPanel *panel = [NSColorPanel sharedColorPanel];
        panel.color = lightColor;
    }

    self.deviceLabelTextField.stringValue = string;
}

- (void)setLight:(LFXLight *)light
{
    if (light != _light)
    {
        [_light removeLightObserver:self];

        _light = light;

        [_light addLightObserver:self];

        [self updateViewsWithLightDetails];
    }
}

- (NSColor *)currentColor
{
    LFXLight *light = self.light;
    NSColor *lightColor = nil;
    if (light)
    {
        lightColor = [NSColor colorWithDeviceHue:light.color.hue / 360.0
                                      saturation:light.color.saturation
                                      brightness:light.color.brightness
                                           alpha:1.0];
    }
    return lightColor;
}


#pragma mark - Turn On/Off Actions

- (IBAction)turnOn:(id)sender
{
    [self.light setPowerState:LFXPowerStateOn];
}

- (IBAction)turnOff:(id)sender
{
    [self.light setPowerState:LFXPowerStateOff];
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
    [self.light setColor:hsbkColor];
}


#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color
{
    NSLog(@"Light: %@ Did Change Color: %@", light, color);
    [self updateViewsWithLightDetails];
}

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
    NSLog(@"Light: %@ Did Change Label: %@", light, label);
    [self updateViewsWithLightDetails];
}

- (void)light:(LFXLight *)light didChangePowerState:(LFXPowerState)powerState
{
    NSLog(@"Light: %@ Did Change Power State: %@", light, NSStringFromLFXPowerState(powerState));
    [self updateViewsWithLightDetails];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    if (light == self.light)
    {
        self.light = nil;
    }
}

@end
