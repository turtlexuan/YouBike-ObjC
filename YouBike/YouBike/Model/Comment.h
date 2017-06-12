//
//  Comment.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Constants.h"

@interface Comment : NSObject

@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic, readonly) NSString *userPictureUrl;
@property (strong, nonatomic, readonly) NSString *time;
@property (strong, nonatomic, readonly) NSString *text;

- (instancetype)initWithUsername:(NSString *)username userPictureUrl:(NSString *)pictureUrl time:(NSString *)time text:(NSString *)text;

@end
