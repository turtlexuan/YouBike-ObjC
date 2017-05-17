//
//  Constants.h
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import "Station.h"
#import "Comment.h"
#import "StationTableViewController.h"
#import "StationCollectionViewController.h"
#import "StationTableViewCell.h"
#import "StationCollectionViewCell.h"
#import "SegmentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "MapTableViewController.h"
#import "YouBikeManager.h"
#import "LocationManager.h"


#endif /* Constants_h */

/* FBLogin */
#define FBLOGIN_PUBLIC_PROFILE      @"public_profile"
#define FBLOGIN_EMAIL               @"email"
#define FBLOGIN_NAME                @"name"
#define FBLOGIN_LINK                @"link"
#define FBLOGIN_PICTURE             @"picture"
#define FBLOGIN_COVER               @"cover"
#define FBLOGIN_ACCESSTOKEN         @"fbAccessToken"

/* HTTPRequest */
#define HTTPREQUEST_POST            @"POST"
#define HTTPREQUEST_GET             @"GET"

/* URLString */
#define URLSTRING_SERVER            @"http://52.198.40.72/youbike/v1"
#define URLSTRING_LOGIN             @"/sign-in/facebook"
#define URLSTRING_STATION           @"/stations"
#define URLSTRING_COMMENT           @"/comments"

/* URLReturnData */
#define URLRETURNDATA_SINGINRETURN  @"signInWithFacebookData"
