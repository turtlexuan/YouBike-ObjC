//
//  MapTableViewController.m
//  YouBike-ObjC
//
//  Created by 劉仲軒 on 2017/5/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "MapTableViewController.h"

typedef NS_ENUM(NSInteger, Components) {
    
    StationDetail,
    Map,
    Segment,
    Comments
    
};

@interface MapTableViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSArray *components;
}

@property (strong, nonatomic) NSArray<Comment *>* comments;
@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D stationLocation;
@property (strong, nonatomic) CLLocation *nowLocation;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MapTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];
    
    if (self.isFromButton == true) {
        [self.tableView setScrollEnabled:false];
    }
    
    self.mapView = [[MKMapView alloc] init];
    self.comments = [[NSArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"SegmentTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    self.tableView.rowHeight = 120;
    self.tableView.estimatedRowHeight = 44;
    
    [YouBikeManager.sharedInstance getCommentWithID:self.selectedStation.stationID withCompletionHandler:^(NSMutableArray<Comment *> * _Nullable comments, NSError * _Nullable error) {
        
        self.comments = comments;
        
        [self.tableView reloadData];
    }];
    
    [self setUpMapView];
}

- (void)dealloc {
    
    [self.timer invalidate];
    [LocationManager.sharedInstance stop];
    
}

- (NSArray<Comment *> *)comments {
    
    if (!_comments) {
        
        _comments = [[NSArray<Comment *> alloc] init];
        
    }
    
    return _comments;
}

#pragma mark - Helper Method
- (void)onChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            
        default:
            break;
    }
    
}

- (void)setUp {
    
    [self.navigationItem setTitle:self.selectedStation.stationNameCH];
    self.navigationController.hidesBottomBarWhenPushed = true;
    
    if (self.isFromButton) {
        components = [[NSArray alloc] initWithObjects:@(Map), @(Segment), @(Comments), nil];
    } else {
        components = [[NSArray alloc] initWithObjects:@(StationDetail), @(Map), @(Segment), @(Comments), nil];
    }
    
    self.mapView.delegate = self;
    
    [self getUserLocation];
    
}

- (void)setUpMapView {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    self.stationLocation = CLLocationCoordinate2DMake(self.selectedStation.lati, self.selectedStation.longi);
    
    annotation.coordinate = self.stationLocation;
    
    [self.mapView addAnnotation:annotation];
    
    self.mapView.delegate = self;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.stationLocation, span);
    
    [self.mapView setRegion:region];
    
    [self.mapView setShowsUserLocation:true];
    
}

- (void)getUserLocation {
    
    LocationManager.sharedInstance.locationManager.delegate = self;
    [LocationManager.sharedInstance requestUserLocationWhenInUse];
    [LocationManager.sharedInstance start];
    
}

- (void)getRoute {
    
    [LocationManager.sharedInstance getPolylineFrom:self.nowLocation.coordinate to:self.stationLocation withTransportType:MKDirectionsTransportTypeAny withCompletionHandler:^(MKPolyline * _Nullable polyline, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@", error.description);
            return;
        }
        
        NSArray<id<MKOverlay>> *oldOverlays = self.mapView.overlays;
        
        [self.mapView removeOverlays:oldOverlays];
        [self.mapView addOverlay:polyline];
        [self.mapView setVisibleMapRect:polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(100, 50, 50, 50) animated:true];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return components.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int value = [components[section] intValue];

    switch (value) {
        case Comments:
            return self.comments.count;
            break;
            
        default:
            return 1;
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int value = [components[indexPath.section] intValue];
    
    switch (value) {
        case StationDetail:
            return 120;
            break;
            
        case Map:
            return  self.isFromButton ? self.view.frame.size.height - 44 : self.view.frame.size.height - 120 - 44;
            break;
            
        case Segment:
            return 44;
            break;
            
        default:
            return UITableViewAutomaticDimension;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int value = [components[indexPath.section] intValue];
    
    if (value == StationDetail) {
        
        StationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.nameLabel.text = self.selectedStation.stationNameCH;
        cell.addressLabel.text = self.selectedStation.stationAddressCH;
        cell.numberLabel.text = [NSString stringWithFormat:@"%d", self.selectedStation.numberOfRemainingBikes];
        [cell.mapButton setHidden:true];
        cell.markerImageView.image = [cell.markerImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.markerImageView.tintColor = [UIColor colorWithRed:160/255.0 green:98/255.0 blue:90/255.0 alpha:1];
        
        return cell;
        
    } else if (value == Map) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.mapView.frame = cell.contentView.frame;
        [cell.contentView addSubview:self.mapView];
        
        return cell;
        
    } else if (value == Segment) {
        
        SegmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentTableViewCell" forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.segment addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, cell.segment.frame.size.width, cell.contentView.frame.size.height)];
        [commentLabel setText:@"Comment"];
        [commentLabel setTextColor:[UIColor colorWithRed:251/255.0 green:197/255.0 blue:111/255.0 alpha:1]];
        
        if (self.isFromButton == false) {
            [cell.segment setHidden:true];
            [cell.contentView addSubview:commentLabel];
        }
        
        return cell;
        
    } else if (value == Comments) {
        
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.usernameLabel.text = self.comments[indexPath.row].username;
        cell.dateLabel.text = self.comments[indexPath.row].time;
        cell.commentLabel.text = self.comments[indexPath.row].text;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL *url = [NSURL URLWithString:self.comments[indexPath.row].userPictureUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *userPicture = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.userImageView.image = userPicture;
            });
        });
        
        
        return cell;
        
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // Receive Location
    self.nowLocation = locations.lastObject;
    
    if (self.isFromButton) {
        
        self.timer = [[NSTimer alloc] init];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getRoute) userInfo:nil repeats:false];
        
    }
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    renderer.strokeColor = [UIColor colorWithRed:201/255.0 green:28/255.0 blue:187/255.0 alpha:1];
    renderer.lineWidth = 7;
    
    return renderer;
    
}







@end
