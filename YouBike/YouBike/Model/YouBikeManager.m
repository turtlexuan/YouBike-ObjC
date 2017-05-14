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
//    let url = URL(string: "\(Constants.URLString.server)\(Constants.URLString.station)")
//    guard let authorizeData = self.userDefault.object(forKey: Constants.URLReturnData.signInReturn) as? [String: AnyObject] else { return }
//    let token       = authorizeData["token"]
//    let tokenType   = authorizeData["tokenType"]
//    let authString  = "\(tokenType!) \(token!)"
//    let headers = ["Authorization": authString]
//    let param = ["paging": self.stationParameter]
//    
//    Alamofire.request(url!, method: .get, parameters: param, headers: headers).responseJSON { (response) in
//        if let error = response.error {
//            self.delegate?.manager(self, didFailWith: error)
//            return
//        }
//        guard let jsonData = response.result.value as? [String: AnyObject], let stationData = jsonData["data"] as? [[String: AnyObject]], let nextToken = jsonData["paging"] as? [String:AnyObject] else { return }
//        for station in stationData {
//            guard let remainBikes       = station["sbi"] as? String, let stationNameCH          = station["sna"] as? String,
//            let stationAreaCH     = station["sarea"] as? String, let stationAddressCH     = station["ar"] as? String,
//            let lati              = station["lat"] as? String, let longi                  = station["lng"] as? String,
//            let id                = station["sno"] as? String, let stationNameEN          = station["snaen"] as? String,
//            let stationAddressEN  = station["aren"] as? String else { return }
//            
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                let context = appDelegate.persistentContainer.viewContext
//                let station = StationMO(context: context)
//                if NSLocale.preferredLanguages.first == "en" {
//                    station.name = stationNameEN
//                    station.address = stationAddressEN
//                } else if NSLocale.preferredLanguages.first == "zh-Hant" {
//                    station.name = "\(stationAreaCH) / \(stationNameCH)"
//                    station.address = stationAddressCH
//                }
//                station.numberOfRemainingBikes = Int64(remainBikes)!
//                station.lati = Double(lati)!
//                station.longi = Double(longi)!
//                station.stationID = id
//                appDelegate.saveContext()
//                
//                self.stationArray.append(station)
//            }
//        }
//        DispatchQueue.main.async {
//            self.delegate?.manager(self, didGet: self.stationArray)
//        }
//        guard let page = nextToken["next"] as? String else {
//            self.stationParameter = "Stop"
//            return
//        }
//        self.stationParameter = page
//    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@", URLSTRING_SERVER, URLSTRING_STATION];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *authString = [NSString stringWithFormat:@"%@ %@", token, tokenType];
    
    NSDictionary *headers = @{@"Authorization": authString};
    NSDictionary *param = @{@"paging": stationParameter};
    
}






















@end
