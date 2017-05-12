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
@property (nonatomic, readonly) NSString * address;
@property (nonatomic, readonly) int * numberOfRemainingBikes;
@property (nonatomic, readonly) double * lati;
@property (nonatomic, readonly) double * longi;
@property (nonatomic, readonly) NSString * stationID;

- (instancetype) initWithName:(NSString *)name
                      address:(NSString *)address
       numberOfRemainingBikes:(int *)number
                         lati:(double *)lati
                        longi:(double *)longi
                    stationID:(NSString *)stationID;

@end
