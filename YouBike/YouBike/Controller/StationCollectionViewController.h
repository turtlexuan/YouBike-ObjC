//
//  StationCollectionViewController.h
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface StationCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray<Station *> *station;

@end
