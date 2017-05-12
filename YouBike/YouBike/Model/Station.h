//
//  Station.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, readonly) NSString * name;

- (instancetype) initWithName:(NSString *)name;

@end
