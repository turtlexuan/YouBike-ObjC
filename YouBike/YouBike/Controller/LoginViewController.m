//
//  LoginViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;


@end

@implementation LoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES ];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) configView {
    
    UIColor *foregroundColor = [UIColor colorWithRed: 61/255.0 green: 52/255.0 blue: 66/255.0 alpha: 1];
    UIColor *strokeColor = [UIColor colorWithRed: 254/255.0  green: 241/255.0 blue: 220/255.0 alpha: 1];
    NSNumber *value = [NSNumber numberWithInt:-2];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_logoLabel.text];
    [attributedString addAttribute: NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, 5)];
    [attributedString addAttribute: NSStrokeColorAttributeName value: strokeColor range:NSMakeRange(0, 5)];
    [attributedString addAttribute: NSStrokeWidthAttributeName value: value range:NSMakeRange(0, 5)];
    
    
//    [self logoLabel attributedString] = attributedString;
    
    self.logoLabel.attributedText = attributedString;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.layer.frame.size.width / 2;
    
    self.logoImageView.layer.masksToBounds = YES;
    
    self.logoImageView.layer.borderWidth = 1;
    
    self.logoImageView.layer.borderColor = [UIColor colorWithRed: 61/255.0 green: 52/255.0 blue: 66/255.0 alpha: 1].CGColor;
    
    self.loginView.layer.cornerRadius = self.loginView.layer.frame.size.height / 10;
    
    self.loginView.layer.masksToBounds = YES;
    
}


- (IBAction)loginAction:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    NSArray *array = [[NSArray alloc] init];
    
    [login logInWithReadPermissions: array fromViewController: self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error != nil) {
            
            NSLog(@"error: %@", error);
        }
        
        NSString *token = result.token.tokenString;
        
        [NSUserDefaults.standardUserDefaults setObject:token forKey: [Constants email]];
        
        [self fetchProfile];
    }];
    
}


-(void) fetchProfile {
    
    NSDictionary *parameter = @{@"fields": @"name, picture.type(large), link, email, cover.type(large)" };
    [[[FBSDKGraphRequest alloc] initWithGraphPath: @"me" parameters: parameter] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
        }
        
        NSLog(@"Result: %@", result);
        
        NSString *name = [result valueForKey: @"name"];
        NSString *email = [result valueForKey: @"email"];
        NSDictionary *picture = [result valueForKey: @"picture"];
        NSDictionary *data = [picture valueForKey: @"data"];
        NSString *url = [data valueForKey: @"url"];
        NSDictionary *cover = [result valueForKey: @"cover"];
        NSString *source = [cover valueForKey: @"source"];
        
        if (name != nil) {
            
            [[NSUserDefaults standardUserDefaults] setValue: name forKey: [Constants name]];
            
        }

        if (email != nil) {
            
            [[NSUserDefaults standardUserDefaults] setValue: email forKey: [Constants email]];
            
        }

        if (url != nil) {
            
            [[NSUserDefaults standardUserDefaults] setValue: url forKey: [Constants picture]];

        }
        
        if (cover != nil) {
            
            [[NSUserDefaults standardUserDefaults] setValue: cover forKey: [Constants cover]];
            
        }
        
        [self nextVC];
        
    }];
    
}

-(void) nextVC {
    UIViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    UIApplication.sharedApplication.keyWindow.rootViewController = VC;
}


@end
