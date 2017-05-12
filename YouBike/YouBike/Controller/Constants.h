//
//  Constants.h
//  YouBike
//
//  Created by 陳冠華 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject


// FB Login
@property (class) NSString *publicProfile;
@property (class) NSString *email;
@property (class) NSString *name;
@property (class) NSString *links;
@property (class) NSString *picture;
@property (class) NSString *cover;
@property (class) NSString *accessToken;

// HTTPRequest
@property (class) NSString *post;
@property (class) NSString *get;


// URLString
@property (class) NSString *server;
@property (class) NSString *login;
@property (class) NSString *station;
@property (class) NSString *comment;


// URLReturnData

@property (class) NSString *SignInReturn;
@end
