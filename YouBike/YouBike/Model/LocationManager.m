//
//  LocationManager.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/16.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()

@end

@implementation LocationManager

+ (instancetype)sharedInstance {
    
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        
    }
    
    return self;
}

- (void)requestUserLocationAlways {
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    // Set Location Parameter
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyHundredMeters;
    self.locationManager.activityType       = CLActivityTypeOtherNavigation;
    self.locationManager.distanceFilter     = 10.0;
    
}

- (void)requestUserLocationWhenInUse {
    
    
    [self.locationManager requestWhenInUseAuthorization];
    
    // Set Location Parameter
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyHundredMeters;
    self.locationManager.activityType       = CLActivityTypeOtherNavigation;
    self.locationManager.distanceFilter     = 10.0;
    
}

#pragma mark - Function

- (void)start {
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

- (void)getPolylineFrom:(CLLocationCoordinate2D)sourceCoordinate
                     to:(CLLocationCoordinate2D)destinationCoordinate
      withTransportType:(MKDirectionsTransportType)transportType
  withCompletionHandler:(void (^)(MKPolyline *__nullable polyline, NSError *__nullable error))completionHandler {
    
    MKPlacemark *sourcePlacemark            = [[MKPlacemark alloc] initWithCoordinate:sourceCoordinate];
    MKMapItem *sourceMapItem                = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    MKPlacemark *destinationPlacemark       = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate];
    MKMapItem *destinationMapItem           = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    MKDirectionsRequest *directionRequest   = [[MKDirectionsRequest alloc] init];
    directionRequest.transportType          = transportType;
    directionRequest.source                 = sourceMapItem;
    directionRequest.destination            = destinationMapItem;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            completionHandler(nil, error);
        }
        
        MKPolyline *polyline = response.routes.firstObject.polyline;
        
        completionHandler(polyline, nil);
        
    }];
    
}















@end
