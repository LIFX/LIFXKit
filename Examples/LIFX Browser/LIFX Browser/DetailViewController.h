//
//  DetailViewController.h
//  LIFX Browser
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LIFXKit/LIFXKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) id <LFXLightTarget> detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)turnOn:(id)sender;
- (IBAction)turnOff:(id)sender;

@end
