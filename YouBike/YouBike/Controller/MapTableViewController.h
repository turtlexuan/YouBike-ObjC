//
//  MapTableViewController.h
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MapTableViewController : UITableViewController

@property (strong, nonatomic) Station *selectedStation;
@property (assign, nonatomic) BOOL isFromButton;

@end
