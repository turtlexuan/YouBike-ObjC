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
#import "Comment.h"
#import "StationMO+CoreDataClass.h"
#import "StationMO+CoreDataProperties.h"

@class YouBikeManager;

@protocol YouBikeManagerDelegate <NSObject>

- (void)manager:(YouBikeManager *)manager didGet:(NSArray<StationMO *> *)stations;
- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error;

@end

@interface YouBikeManager : NSObject

@property (weak, nonatomic) id<YouBikeManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray<StationMO *> *stationArray;
@property (strong, nonatomic) NSMutableArray<Comment *> *commentArray;
@property (strong, nonatomic) NSString *stationParameter;
@property (strong, nonatomic) NSString *commentParameter;

+ (instancetype)sharedInstance;
- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken withCompletionHandler:(void (^)(NSString * token, NSString * tokenType, NSError * error))completionHandler;
- (void)getStations;
- (void)getCommentWithID:(NSString *)stationID withCompletionHandler:(void (^__nonnull)(NSMutableArray<Comment *> * __nullable comments,
                                                                                        NSError * __nullable error))completionHandler;

@end
