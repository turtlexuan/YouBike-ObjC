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

//protocol YouBikeManagerDelegate: class {
//    func manager(_ manager: YouBikeManager, didGet stations: [StationMO])
//
//    func manager(_ manager: YouBikeManager, didFailWith error: Error)
//
//    func manager(_ manager: YouBikeManager, didGet comments: [Comment])
//}

@protocol YouBikeManagerDelegate <NSObject>

- (void)manager:(YouBikeManager *)manager didGet:(NSArray<Station *> *)stations;
- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error;

@end

@interface YouBikeManager : NSObject

@property (weak, nonatomic) id<YouBikeManagerDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken withCompletionHandler:(void (^_Nonnull)(NSString * __nullable token, NSString * __nullable tokenType, NSError * __nullable error))completionHandler;

@end
