//
//  LocationManager.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/16.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *nowLocation;

+ (instancetype)sharedInstance;
- (void)requestUserLocationAlways;
- (void)requestUserLocationWhenInUse;
- (void)start;
- (void)stop;
- (void)getPolylineFrom:(CLLocationCoordinate2D)sourceCoordinate
                     to:(CLLocationCoordinate2D)destinationCoordinate
      withTransportType:(MKDirectionsTransportType)transportType
  withCompletionHandler:(void (^_Nullable)(MKPolyline *_Nullable polyline, NSError *_Nullable error))completionHandler;

@end
