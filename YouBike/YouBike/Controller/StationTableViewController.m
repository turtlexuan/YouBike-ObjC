//
//  StationTableViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "StationTableViewController.h"

@interface StationTableViewController ()

@end

@implementation StationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"StationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.rowHeight = 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.station.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.station[indexPath.row].stationNameCH;
    cell.addressLabel.text = self.station[indexPath.row].stationAddressCH;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", self.station[indexPath.row].numberOfRemainingBikes];
    cell.remainLabel.text = NSLocalizedString(@"剩", @"");
    cell.bikesLabel.text = NSLocalizedString(@"台", @"");
    
    if ([[NSLocale.preferredLanguages firstObject]  isEqual: @"en"]) {
        cell.bikesLabel.font = [cell.bikesLabel.font fontWithSize:12];
    }
    
    if ([[UIDevice.currentDevice model] isEqual:@"iPad"]) {
        [cell.mapButton setHidden:true];
    }
    
    cell.mapButton.layer.borderWidth = 1;
    cell.mapButton.layer.borderColor = [UIColor colorWithRed:204/255.0 green:113/255.0 blue:93/255.0 alpha:1].CGColor;
    cell.mapButton.layer.cornerRadius = 4;
    cell.mapButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.mapButton setTitle:NSLocalizedString(@"看地圖", @"") forState:UIControlStateNormal];
    [cell.mapButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.markerImageView.image = [cell.markerImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.markerImageView.tintColor = [UIColor colorWithRed:160/255.0 green:98/255.0 blue:90/255.0 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        MVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:MVC animated:true];
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger lastElement = self.station.count - 1;
    
    if (indexPath.row == lastElement && YouBikeManager.sharedInstance.stationParameter != nil) {
        [YouBikeManager.sharedInstance getStations];
    }
    
}

#pragma mark - Helper Method
- (void)viewMap:(UIButton *)sender {
    
    StationTableViewCell *cell = (StationTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Station *selectedStation = self.station[indexPath.row];
    
    MapTableViewController *MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapTableViewController"];
    
    MVC.selectedStation = selectedStation;
    MVC.isFromButton = true;
    
    MVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:MVC animated:true];
    
}


@end
