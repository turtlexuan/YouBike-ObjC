//
//  Station.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, readonly) NSString * stationNameCH;
@property (nonatomic, readonly) NSString * stationNameEN;
@property (nonatomic, readonly) int numberOfRemainingBikes;
@property (nonatomic, readonly) double lati;
@property (nonatomic, readonly) double longi;
@property (nonatomic, readonly) NSString * stationID;
@property (nonatomic, readonly) NSString * stationAddressCH;
@property (nonatomic, readonly) NSString * stationAddressEN;

- (instancetype) initWithNameCH:(NSString *)stationNameCH
                         nameEN:(NSString *)stationNameEN
                      addressCH:(NSString *)stationAddressCH
                      addressEN:(NSString *)stationAddressEN
         numberOfRemainingBikes:(int)number
                           lati:(double)lati
                          longi:(double)longi
                      stationID:(NSString *)stationID;

@end
