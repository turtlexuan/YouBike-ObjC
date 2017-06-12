//
//  Station.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "Station.h"

@implementation Station

- (instancetype) initWithNameCH:(NSString*)stationNameCH
                         nameEN:(NSString *)stationNameEN
                      addressCH:(NSString *)stationAddressCH
                      addressEN:(NSString *)stationAddressEN
         numberOfRemainingBikes:(int)number
                           lati:(double)lati
                          longi:(double)longi
                      stationID:(NSString *)stationID {
    
    _stationNameCH = stationNameCH;
    _stationNameEN = stationNameEN;
    _stationAddressCH = stationAddressCH;
    _stationAddressEN = stationAddressEN;
    _numberOfRemainingBikes = number;
    _lati = lati;
    _longi = longi;
    _stationID = stationID;
    
    return self;
    
}


@end
