//
//  StationTableViewController.h
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "StationMO+CoreDataClass.h"
#import "StationMO+CoreDataProperties.h"

@interface StationTableViewController : UITableViewController

@property (strong, nonatomic) NSArray<StationMO *> *station;

@end
