//
//  ViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [YouBikeManager.sharedInstance signInWithFacebookWithAccessToken:[FBSDKAccessToken.currentAccessToken tokenString]
                                               withCompletionHandler:^(NSString * _Nullable token,
                                                                       NSString * _Nullable tokenType,
                                                                       NSError * _Nullable error) {
        
        NSLog(@"%@", token);
        NSLog(@"%@", tokenType);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
