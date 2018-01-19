//
//  GroupMapViewController.m
//  My_App
//
//  Created by barney on 15/12/11.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapLocation.h"
@interface GroupMapViewController ()<MKMapViewDelegate>

@end

@implementation GroupMapViewController
{
    MKMapView *_mapView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBtn];
    // Do any additional setup after loading the view.
    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    _mapView.mapType=MKMapTypeStandard;
    _mapView.delegate=self;
    CLLocationCoordinate2D cor=CLLocationCoordinate2DMake(self.mapModel.gai_lat.doubleValue, self.mapModel.gai_lng.doubleValue);
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(cor, 2000, 2000);
    
    [_mapView setRegion:region];
    [self.view addSubview:_mapView];


    MapLocation *mapLocation=[[MapLocation alloc]initWithTitle:[NSString stringWithFormat:@"%@",self.mapModel.store_name] SubTitle:nil Coordinate:cor];
    [_mapView addAnnotation:mapLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
