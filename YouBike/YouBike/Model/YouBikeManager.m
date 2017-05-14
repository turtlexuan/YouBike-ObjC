//
//  YouBikeManager.m
//  YouBike
//
//  Created by 劉仲軒 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "YouBikeManager.h"
#import "ViewController.h"

@interface YouBikeManager()

{
    NSString *stationParameter;
}

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
    
    return self;
    
}

- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken
                    withCompletionHandler:(void (^__nonnull)(NSString * __nullable token,
                                                             NSString * __nullable tokenType,
                                                             NSError * __nullable error))completionHandler {
    
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
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response,
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

        completionHandler(token, tokenType, nil);
    }];
    
    [task resume];
    
}

- (void)getStationsWithToken:(NSString *__nonnull)token withTokenType:(NSString *__nonnull)tokenType {

    NSString *urlString = [NSString stringWithFormat:@"%@%@", URLSTRING_SERVER, URLSTRING_STATION];
    
    NSString *authString = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    
    NSDictionary *param;
    
    if (stationParameter != nil) {
        param = @{@"paging": stationParameter};
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
        
        if (paging != nil) {
            stationParameter = nextPage;
        }
        
        NSLog(@"%@", stationParameter);

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

            Station *oneStation = [[Station alloc] initWithNameCH:stationNameCH nameEN:stationNameEN addressCH:stationAddressCH addressEN:stationAddressEN numberOfRemainingBikes:remainBikeValue lati:latiValue longi:longiValue stationID:stationID];
            
            [self.stationArray addObject:oneStation];
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






















@end
