//
//  ViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) StationTableViewController *stationTableViewController;
@property (assign, nonatomic) StationCollectionViewController *stationCollectionViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YouBikeManager.sharedInstance.delegate = self;
    
    [YouBikeManager.sharedInstance signInWithFacebookWithAccessToken:[FBSDKAccessToken.currentAccessToken tokenString]
                                               withCompletionHandler:^(NSString * _Nullable token,
                                                                       NSString * _Nullable tokenType,
                                                                       NSError * _Nullable error) {
        
        NSLog(@"%@", token);
        NSLog(@"%@", tokenType);
                                                   
        [YouBikeManager.sharedInstance getStationsWithToken:token withTokenType:tokenType];
        
    }];
}

- (instancetype)init {
    
    self = [super init];
    
    
    
    return self;
}

- (void)manager:(YouBikeManager *)manager didGet:(NSArray<Station *> *)stations {
    
    NSLog(@"%@", stations);
    
}

- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error {
    
    NSLog(@"%@", error);
    
}

@end
