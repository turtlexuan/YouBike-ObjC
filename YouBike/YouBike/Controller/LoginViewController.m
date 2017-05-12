//
//  LoginViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configView];
}

- (void)configView {
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.logoLabel.text
                                                                           attributes:@{
                                                                                        NSFontAttributeName: self.logoLabel.font,
                                                                                        NSForegroundColorAttributeName: [UIColor colorWithRed:61/255.0 green:52/255.0 blue:66/255.0 alpha:1],
                                                                                        NSStrokeWidthAttributeName: @-2,
                                                                                        NSStrokeColorAttributeName: [UIColor colorWithRed:254/255.0 green:241/255.0 blue:220/255.0 alpha:1]}];
    self.logoLabel.attributedText = attributedString;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.layer.frame.size.width / 2;
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.borderWidth = 1;
    self.logoImageView.layer.borderColor = [[UIColor colorWithRed:61/255.0 green:52/255.0 blue:66/255.0 alpha:1] CGColor];
    
    self.loginView.layer.cornerRadius = self.loginView.layer.frame.size.height / 10;
    self.loginView.layer.masksToBounds = YES;

}

- (IBAction)loginAction:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *permissions = @[FBLOGIN_PUBLIC_PROFILE, FBLOGIN_EMAIL];
    [login logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error != nil) {
            return;
        }
        
        NSString *token = result.token.tokenString;
        [NSUserDefaults.standardUserDefaults setObject:token forKey:FBLOGIN_ACCESSTOKEN];
        
        [self fetchProfile];
        
    }];
    
}

- (void)fetchProfile {
    
    NSDictionary *parameter = @{@"fields": @"name, picture.type(large), link, email"};
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameter] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        //
        if (error != nil) {
            return;
        }
        
        NSString *name = [result objectForKey:FBLOGIN_NAME];
        
        if (name != nil) {
            [NSUserDefaults.standardUserDefaults setObject:name forKey:FBLOGIN_NAME];
        }
        
        NSString *link = [result objectForKey:FBLOGIN_LINK];
        
        if (link != nil) {
            [NSUserDefaults.standardUserDefaults setObject:link forKey:FBLOGIN_LINK];
        }
        
        NSString *email = [result objectForKey:FBLOGIN_EMAIL];
        
        if (email != nil) {
            [NSUserDefaults.standardUserDefaults setObject:email forKey:FBLOGIN_EMAIL];
        }
        
        NSDictionary *picture = [result objectForKey:FBLOGIN_PICTURE];
        NSDictionary *source = [picture objectForKey:@"data"];
        NSString *url = [source objectForKey:@"url"];
        
        if (url != nil) {
            [NSUserDefaults.standardUserDefaults setObject:url forKey:FBLOGIN_PICTURE];
        }
        
        [self nextVC];
        
    }];
    
}

- (void)nextVC {
    
    UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"StoryboardiPad" bundle:nil];
    
    NSString *deviceType = [UIDevice.currentDevice model];
    
    if ([deviceType isEqual: @"iPad"]) {
        
        UIViewController *splitVC = [iPadStoryboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
        UIApplication.sharedApplication.keyWindow.rootViewController = splitVC;
        
    } else {
        
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        UIApplication.sharedApplication.keyWindow.rootViewController = VC;
    }
    
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
