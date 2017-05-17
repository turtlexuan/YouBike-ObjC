//
//  StationCollectionViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "StationCollectionViewController.h"

@interface StationCollectionViewController ()

@end

@implementation StationCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"StationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.collectionViewLayout = [self setUpFlowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:166/255.0 green:145/255.0 blue:84/255.0 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method
- (UICollectionViewFlowLayout *)setUpFlowLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(14, 14, 14, 14);
    layout.minimumLineSpacing = 14;
    
    if ([UIDevice.currentDevice.model  isEqual: @"iPad"]) {
        layout.itemSize = CGSizeMake(140, 140);
    } else {
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 42) / 2, (self.view.frame.size.width - 42) / 2);
    }
    
    return layout;
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"Station Count: %lu", (unsigned long)self.station.count);

    return self.station.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.station[indexPath.row].stationNameCH;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", self.station[indexPath.row].numberOfRemainingBikes];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Station *selectedStation = self.station[indexPath.row];
    
    if (self.splitViewController != nil) {
        
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"StoryboardiPad" bundle:nil];
        
        MapTableViewController *MVC = [iPadStoryboard instantiateViewControllerWithIdentifier:@"MapTableViewController"];
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:MVC];
        
        MVC.selectedStation = selectedStation;
        MVC.isFromButton = false;
        
        [self.splitViewController showDetailViewController:navigation sender:nil];
        
    } else {
        
        MapTableViewController *MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapTableViewController"];
        
        MVC.selectedStation = selectedStation;
        MVC.isFromButton = false;
        
        MVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:MVC animated:true];
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger lastElement = self.station.count - 1;
    
    if (indexPath.row == lastElement && YouBikeManager.sharedInstance.stationParameter != nil) {
        [YouBikeManager.sharedInstance getStations];
    }
    
}

@end
