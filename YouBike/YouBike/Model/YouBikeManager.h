//
//  YouBikeManager.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>
#import "Station.h"
@class YouBikeManager;

@protocol YouBikeManagerDelegate <NSObject>

- (void)manager:(YouBikeManager *)manager didGet:(NSArray<Station *> *)stations;
- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error;

@end

@interface YouBikeManager : NSObject

@property (weak, nonatomic) id<YouBikeManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray<Station *> *stationArray;
@property (strong, nonatomic) NSString *stationParameter;

+ (instancetype)sharedInstance;
- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken withCompletionHandler:(void (^)(NSString * token, NSString * tokenType, NSError * error))completionHandler;
- (void)getStations;

@end
