//
//  Comment.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (instancetype)initWithUsername:(NSString *)username userPictureUrl:(NSString *)pictureUrl time:(NSString *)time text:(NSString *)text {
    
    _username = username;
    _userPictureUrl = pictureUrl;
    _time = time;
    _text = text;
    
    return self;
}

@end
