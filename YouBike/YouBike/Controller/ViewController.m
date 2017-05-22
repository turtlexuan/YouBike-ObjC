//
//  ViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (strong, nonatomic) StationTableViewController *stationTableViewController;
@property (strong, nonatomic) StationCollectionViewController *stationCollectionViewController;
@property (strong, nonatomic) UISegmentedControl *segmentControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSegmentControl];
    [self.navigationController setNavigationBarHidden:false animated:true];
    self.navigationController.navigationBar.translucent = false;
    
    YouBikeManager.sharedInstance.delegate = self;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        
        [self fetchData];
        
    } else {
        
        [self deleteData];
    
        [YouBikeManager.sharedInstance signInWithFacebookWithAccessToken:[FBSDKAccessToken.currentAccessToken tokenString]
                                                   withCompletionHandler:^(NSString * _Nullable token,
                                                                           NSString * _Nullable tokenType,
                                                                           NSError * _Nullable error) {
        
            NSLog(@"%@", token);
            NSLog(@"%@", tokenType);
                                                   
            [YouBikeManager.sharedInstance getStations];
        
    }];
        
    }
    
    [self updateView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Initializer
- (StationTableViewController *)stationTableViewController {
    
    if (!_stationTableViewController) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        _stationTableViewController = (StationTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StationTableViewController"];
        
        [self addAsChildViewControlle:_stationTableViewController];
        
    }
    
    return _stationTableViewController;
}

- (StationCollectionViewController *)stationCollectionViewController {
    
    if (!_stationCollectionViewController) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        _stationCollectionViewController = (StationCollectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StationCollectionViewController"];
        
        [self addAsChildViewControlle:_stationCollectionViewController];
        
    }
    
    return _stationCollectionViewController;
    
}

#pragma mark - Helper Methods
- (void)addAsChildViewControlle:(UIViewController *)viewController {
    
    [self addChildViewController:viewController];
    
    [self.view addSubview:viewController.view];
    
    viewController.view.frame = self.view.bounds;
    
    [viewController didMoveToParentViewController:self];
    
}

- (void)removeAsChildViewController:(UIViewController *)viewController {
    
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
}

#pragma mark - View Setting
- (void)setUpSegmentControl {
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"List", @"Grid"]];
    [self.segmentControl setImage:[UIImage imageNamed:@"icon-list"] forSegmentAtIndex:0];
    [self.segmentControl setImage:[UIImage imageNamed:@"icon-grid"] forSegmentAtIndex:1];
    self.segmentControl.tintColor = [UIColor colorWithRed:251/255.0 green:197/255.0 blue:111/255.0 alpha:1];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
    
}

- (void)onChange:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        [self removeAsChildViewController:self.stationCollectionViewController];
        [self addAsChildViewControlle:self.stationTableViewController];
        
    } else {
        
        [self removeAsChildViewController:self.stationTableViewController];
        [self addAsChildViewControlle:self.stationCollectionViewController];

    }
    
}

- (void)updateView {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        [self removeAsChildViewController:self.stationCollectionViewController];
        [self addAsChildViewControlle:self.stationTableViewController];
        
    } else {
        
        [self removeAsChildViewController:self.stationTableViewController];
        [self addAsChildViewControlle:self.stationCollectionViewController];
        
    }
    
}

- (void)fetchData {
    
    NSFetchRequest *fetchRequest = [StationMO fetchRequest];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stationID" ascending:true];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    if (appDelegate == nil) {
        return;
    }
    
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSError * _Nullable __autoreleasing * _Nullable error = NULL;
    
    NSArray<StationMO *> *fetchedObjects = [context executeFetchRequest:fetchRequest error:error];
    
    self.stationTableViewController.station = fetchedObjects;
    self.stationCollectionViewController.station = fetchedObjects;

}

- (void)deleteData {
    
    NSFetchRequest *fetchRequest = [StationMO fetchRequest];
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    if (appDelegate == nil) {
        return;
    }
    
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    NSError * _Nullable __autoreleasing * _Nullable error = NULL;
    
    NSArray<StationMO *> *fetchedObjects = [context executeFetchRequest:fetchRequest error:error];
    
    for (StationMO *object in fetchedObjects) {
        
        NSManagedObject *managedObject = object;
        [context deleteObject:managedObject];
        
    }
    
}

#pragma mark - YouBikeManagerDelegate
- (void)manager:(YouBikeManager *)manager didGet:(NSArray<StationMO *> *)stations {
    
    self.stationTableViewController.station = stations;
    self.stationCollectionViewController.station = stations;
    
    [self.stationTableViewController.tableView reloadData];
    [self.stationCollectionViewController.collectionView reloadData];
    
}

- (void)manager:(YouBikeManager *)manager didFailWith:(NSError *)error {
    
    NSLog(@"%@", error);
    
}

@end
