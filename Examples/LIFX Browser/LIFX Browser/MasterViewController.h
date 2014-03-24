//
//  MasterViewController.h
//  LIFX Browser
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
