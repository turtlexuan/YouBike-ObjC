//
//  SplitViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "SplitViewController.h"
#import "ViewController.h"
#import "ProfileNavigationController.h"

@interface SplitViewController ()

@property (strong, nonatomic) ViewController *viewController;

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab-bar-profile"]
                                                                              landscapeImagePhone:nil
                                                                                            style:UIBarButtonItemStylePlain
                                                                                           target:self
                                                                                           action:@selector(showProfile)];
    self.viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:251/255.0 green:197/255.0 blue:111/255.0 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ViewController *)viewController {
    
    UINavigationController *navigationController = self.viewControllers.firstObject;
    
    return (ViewController *)navigationController.viewControllers.firstObject;
    
}

- (void)showProfile:(UIBarButtonItem *)sender {
    
    ProfileViewController *profileViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    ProfileNavigationController *navigationController = [[ProfileNavigationController alloc] initWithRootViewController:profileViewController];
    
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    navigationController.preferredContentSize = CGSizeMake(320, 320);
    navigationController.popoverPresentationController.barButtonItem = sender;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
