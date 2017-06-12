//
//  YouBikeManager.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "YouBikeManager.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface YouBikeManager()

@end

@implementation YouBikeManager

+ (instancetype)sharedInstance {
    
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YouBikeManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    self.stationArray = [[NSMutableArray alloc] init];
    self.commentArray = [[NSMutableArray alloc] init];
    self.stationParameter = [[NSString alloc] init];
    self.commentParameter = [[NSString alloc] init];
    
    return self;
    
}

- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken
                    withCompletionHandler:(void (^__nonnull)(NSString * __nullable token,
                                                             NSString * __nullable tokenType,
                                                             NSError * __nullable error))completionHandler {
    
    NSURLSessionDataTask *task2 = [[NSURLSessionDataTask alloc] init];
    
//    if (task2.state == NSURLSessionTaskStateRunning) {
//        [task2 cancel];
//    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URLSTRING_SERVER, URLSTRING_LOGIN];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary *parameter = @{@"accessToken": accessToken};
    
    NSData *rawJson = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPMethod = HTTPREQUEST_POST;
    request.HTTPBody = rawJson;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
                                            completionHandler:^(NSURLResponse * _Nonnull response,
                                                                id  _Nullable responseObject,
                                                                NSError * _Nullable error) {
        if (error != nil) {
            
            NSLog(@"%@", error);
            completionHandler(nil, nil, error);
            return;
            
        }
        
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey:@"data"];
        
        if (data == nil) {
            return;
        }
        
        NSString *token = [data objectForKey:@"token"];
        NSString *tokenType = [data objectForKey:@"tokenType"];
        
        [NSUserDefaults.standardUserDefaults setObject:token forKey:@"token"];
        [NSUserDefaults.standardUserDefaults setObject:tokenType forKey:@"tokenType"];

        completionHandler(token, tokenType, nil);
    }];
    
    [task resume];
    
}

- (void)getStations {

    NSString *urlString = [NSString stringWithFormat:@"%@%@", URLSTRING_SERVER, URLSTRING_STATION];
    
    NSString *token = [NSUserDefaults.standardUserDefaults objectForKey:@"token"];
    NSString *tokenType = [NSUserDefaults.standardUserDefaults objectForKey:@"tokenType"];
    
    NSString *authString = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    
    NSDictionary *param;
    
    if (self.stationParameter != nil) {
        param = @{@"paging": self.stationParameter};
    }
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];

    [manager GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey:@"data"];
        
        if (data == nil) {
            return;
        }
        
        NSDictionary *paging = [jsonObject objectForKey:@"paging"];
        NSString *nextPage = [paging objectForKey:@"next"];
        
        if (nextPage != nil) {
            self.stationParameter = nextPage;
        } else {
            self.stationParameter = nil;
        }
        
        NSLog(@"%@", self.stationParameter);

        for (NSDictionary *station in data) {
            //
            NSString *remainBikes = [station objectForKey:@"sbi"];
            NSString *stationNameCH = [station objectForKey:@"sna"];
            NSString *stationNameEN = [station objectForKey:@"snaen"];
            NSString *stationAddressCH = [station objectForKey:@"ar"];
            NSString *stationAddressEN = [station objectForKey:@"aren"];
            NSString *lati = [station objectForKey:@"lat"];
            NSString *longi = [station objectForKey:@"lng"];
            NSString *stationID = [station objectForKey:@"sno"];
            
            int remainBikeValue = [remainBikes intValue];
            double latiValue = [lati doubleValue];
            double longiValue = [longi doubleValue];
            
            AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
            NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
            StationMO *station = [[StationMO alloc] initWithContext:context];
            if ([NSLocale.preferredLanguages.firstObject isEqual:@"zh-Hant-US"]) {
                station.stationName = stationNameCH;
                station.stationAddress = stationAddressCH;
            } else {
                station.stationName = stationNameEN;
                station.stationAddress = stationAddressEN;
            }
            NSLog(@"%@", NSLocale.preferredLanguages.firstObject);
            station.numberOfRemainingBikes = remainBikeValue;
            station.lati = latiValue;
            station.longi = longiValue;
            station.stationID = stationID;
            [appDelegate saveContext];
            
            [self.stationArray addObject:station];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate manager:self didGet:self.stationArray];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate manager:self didFailWith:error];
        });
        
    }];
    
}

- (void)getCommentWithID:(NSString *)stationID withCompletionHandler:(void (^__nonnull)(NSMutableArray<Comment *> * __nullable comments,
                                                                                        NSError * __nullable error))completionHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@%@", URLSTRING_SERVER, URLSTRING_STATION, stationID, URLSTRING_COMMENT];
    
    NSString *token = [NSUserDefaults.standardUserDefaults objectForKey:@"token"];
    NSString *tokenType = [NSUserDefaults.standardUserDefaults objectForKey:@"tokenType"];
    
    NSString *authString = [NSString stringWithFormat:@"%@ %@", tokenType, token];

    NSDictionary *param;
    
    if (self.commentParameter != nil) {
        param = @{@"paging": self.commentParameter};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey:@"data"];
        
        if (data == nil) {
            return;
        }
        
        NSDictionary *paging = [jsonObject objectForKey:@"paging"];
        NSString *nextPage = [paging objectForKey:@"next"];
        
        if (nextPage != nil) {
            self.commentParameter = nextPage;
        } else {
            self.commentParameter = nil;
        }
        
        for (NSDictionary *comment in data) {
            
            NSDictionary *userData = [comment objectForKey:@"user"];
            NSString *text = [comment objectForKey:@"text"];
            NSString *time = [comment objectForKey:@"created"];
            
            if (userData == nil) {
                continue;
            }
            
            NSString *username = [userData objectForKey:@"name"];
            NSString *pictureUrl = [userData objectForKey:@"picture"];
            
            Comment *comments = [[Comment alloc] initWithUsername:username userPictureUrl:pictureUrl time:time text:text];
            
            [self.commentArray addObject:comments];
        }
        
        completionHandler(self.commentArray, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
        completionHandler(nil, error);
    }];
    
    
}




















@end
