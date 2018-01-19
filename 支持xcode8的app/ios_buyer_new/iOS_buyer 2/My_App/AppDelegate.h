//
//  AppDelegate.h
//  My_App
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "OnlinePayTypeSelectViewController.h"
#import "PositionViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WXApiManagerDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>//sendMsgToWeChatViewDelegat
{
    UILabel *labelTi;
    enum WXScene _scene;
    UIImageView *launch_ad_Image;
    UIView *launch_ad_View;
    NSMutableArray *navArray;
    
    CLLocationManager *_manager;//定位
    NSMutableString *colng; //经度
    NSMutableString *colat; //纬度
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *addressListDic;
@property (strong, nonatomic) NSArray *addressVCard;
@property (weak, nonatomic) UIImageView *imageView;

@property float autoSizeScaleX;
@property float autoSizeScaleY;


@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@property (nonatomic, strong) UIApplicationShortcutItem *currentShortItem;

@property (nonatomic, assign)int vcCount;

@end
