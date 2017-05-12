//
//  ProfileViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *homePageButtonView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self settingView];
    
}

- (IBAction)homePageAction:(id)sender {
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"link"];
    
    if (urlString != nil) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:true completion:nil];
        
    }
    
}


- (void)settingView {
    
    self.gradientView.layer.cornerRadius        = self.gradientView.layer.frame.size.width / 2;
    self.profileImageView.layer.cornerRadius    = self.profileImageView.layer.frame.size.width / 2;
    self.homePageButtonView.layer.cornerRadius  = 10;
    
    self.gradientView.layer.masksToBounds       = true;
    self.profileImageView.layer.masksToBounds   = true;
    self.homePageButtonView.layer.masksToBounds = true;
    
    CAShapeLayer *rectShape;
    rectShape.bounds = self.backgroundView.frame;
    rectShape.position = self.backgroundView.center;
    rectShape.path = [UIBezierPath bezierPathWithRoundedRect: self.backgroundView.bounds
                                           byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                 cornerRadii: CGSizeMake(20, 20)].CGPath;
    
    self.backgroundView.layer.mask = rectShape;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    if (username != nil) {
        
        self.usernameLabel.text = username;
    }
    
    NSString *pictureUrlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"picture"];
    
    if (pictureUrlString != nil) {
        
        NSURL *url = [NSURL URLWithString:pictureUrlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.profileImageView.image = [UIImage imageWithData:data];
        
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
