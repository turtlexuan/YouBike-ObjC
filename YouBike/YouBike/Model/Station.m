//
//  Station.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "Station.h"

@implementation Station

- (instancetype) initWithName:(NSString *)name
                      address:(NSString *)address
       numberOfRemainingBikes:(int *)number
                         lati:(double *)lati
                        longi:(double *)longi
                    stationID:(NSString *)stationID {
    
    _name = name;
    _address = address;
    _numberOfRemainingBikes = number;
    _lati = lati;
    _longi = longi;
    _stationID = stationID;
    
    return self;
    
}


@end
