# LIFXKit

LIFXKit is the LIFX SDK for Objective-C. LIFXKit currently supports iOS. OS X support is coming soon.

## Installation

### CocoaPods Installation
LIFXKit will be published in the public CocoaPod Specs repo shortly. Until then, you can use LIFXKit with CocoaPods by add the following to your Podfile:

	pod 'LIFXKit', :git => 'https://github.com/LIFX/LIFXKit.git', :tag => 'v0.5'

### Xcode Sub-Project Installation
1. Drag `LIFX SDK.xcodeproj` into your Xcode project as a sub-project. Go to the Products source group within LIFX SDK, then drag `libLIFXKit.a` into your App Target's Linked Frameworks and Libraries list.
2. Configure your Target to link against the follow system Frameworks/Libraries:
	- `SystemConfiguration.framework`
	- `libz.dylib`
3. Ensure that your target is configured to link against categories from static libraries correctly. To do this, ensure that the `Other Linker Flags` Build Settings for your app target contains `-ObjC`.

Once you've configured your Xcode project with either method, add `#import <LIFXKit/LIFXKit.h>` to your source files and start hacking away!

## Quick Examples

Turn off all lights:
```objc
LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
[localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOff];
```

Turn on the light named "Hallway":
```objc
LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
LFXLight *hallway = [localNetworkContext.allLightsCollection firstLightForLabel:@"Hallway"];
[hallway setPowerState:LFXPowerStateOn];
```

Turn on all lights that are tagged "Kitchen":
```objc
LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
LFXTaggedLightCollection *kitchen = [localNetworkContext taggedLightCollectionForTag:@"Kitchen"];
[kitchen setPowerState:LFXPowerStateOn];
```

Set every light to a random color:
```objc
LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
for (LFXLight *aLight in localNetworkContext.allLightsCollection.lights)
{
	LFXHSBKColor *color = [LFXHSBKColor colorWithHue:arc4random()%360 saturation:1.0 brightness:1.0];
	[aLight setColor:color];
}
```

## Sample Code

Sample code can be found in `/Examples`.

### LIFX Browser
The `LIFX Browser` sample code project gives a very simple demonstration of discovery, lights, tagged light collections, light state and light control. It also shows how to integrate with the observer-callback APIs used throught LIFXKit. This is the best starting point for writing your own LIFX-compatible app.


## Quick overview of LIFX SDK terminology

### Network Context

A Network Context (`LFXNetworkContext`) denotes a context within which you will be accessing LIFX devices. The SDK currently only has support for a "Local Network Context", which refers to devices accessible on your LAN. We plan on adding Network Contexts for accessing LIFX devices via the upcoming cloud service.

### Lights, Light Collections and Addressing

The underlying LIFX system has three types of internal address: device, tag and broadcast. Device addressing will target an individual device, tag addressing will target all devices that have a particular tag, and broadcast addressing addressing will target all devices. Due to the way the underlying LIFX Binary Protocol works, you'll see much faster performance by targetting a tag (using a Tagged Light Collection) rather than targetting every device within that tag individually. The same applies to targetting all lights in a Network Context - if you want to change the state on all lights, you'll see much faster performance targetting `-[LFXNetworkContext allLightsCollection]` than you would by targetting each device individually.

### Lights

A `LFXLight` object represents an individual LIFX Light, and there will be only one `LFXLight` corresponding to each device per Network Context.

### Light Collections

Light Collections (`LFXLightCollection`) are classes that encapsulate a group of LIFX lights. They can have their light state manipulated in the same way that an individual light can. You can access the lights within a Light Collection through the `.lights` property.

### The All Lights Collection

Each `LFXNetworkContext` has an `.allLightsCollection` property, which is how you get the list of lights. If you want to manipulate every light in the same way (e.g. to turn every light off), you should use the All Lights Collection property directly, instead of targetting each device individually.

### Tagged Light Collections

A Tagged Light Collection (`LFXTaggedLightCollection`) represents the lights contained within a particular tag. If you want to manipulate every device within a tag, you should always use the Tagged Light Collection instead of dealing with each Light individually. Tagged Light Collections are unique within a Network Context.

### HSBK Color

LIFX makes use of a "HSBK" color representation. The "HSB" part refers to the [HSB](http://en.wikipedia.org/wiki/HSB_color_space) color space, and the "K" part refers to the [Color Temperature](http://en.wikipedia.org/wiki/Color_temperature) of the white point, in Kelvin. At full saturation, HSBK colors will correspond to the edge of the realisable color gamut, and at zero saturation, HSBK colors will correspond to the color described by the Color Temperature in the K component.

