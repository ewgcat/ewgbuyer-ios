//
//  FirstViewController.h
//  My_App
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "UMSocialShakeService.h"
#import <AVFoundation/AVFoundation.h>

@class FirstIndexxCell;

@interface FirstViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UMSocialShakeDelegate>
{
    BOOL indexPicBool;

    __weak IBOutlet UIView *topSearchView;
    __weak IBOutlet UILabel *MessageCount;
    __weak IBOutlet UITableView *MyTableView;
    __weak IBOutlet UIView *loadingV;

    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
    NSMutableArray *dataArray;//保存网络数据的数组
    __weak IBOutlet UIImageView *navImage;
    __weak IBOutlet UIImageView *searchImage;
    __weak IBOutlet UILabel *searchLabel;
    IBOutlet UIButton *searchbtn;
    NSMutableArray *secontionArray;
    NSMutableArray *secontionTitleArray;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    __weak IBOutlet UIButton *backBtn;
    UIScrollView *topScrollView;
    UIPageControl *topPageControl;
}

@property (nonatomic, strong) NSString *DeviceToken;
@property (nonatomic, strong) NSString *scanStr;
@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, assign) BOOL onBool;
@property (nonatomic, assign) BOOL loginBool;//点击轻松购时 没有登录 则需要=yes
@property (nonatomic, strong) UIImageView * line;
@property (strong, nonatomic) NSString *Detailfree_id;
@property (assign,nonatomic)BOOL willAppearBool;
@property (strong,nonatomic)NSString *payType;

+(id)sharedUserDefault;
-(IBAction)MysearchBtnClicked:(id)sender;
-(IBAction)ScanClicekedMy:(id)sender;
-(IBAction)gotoTopAction:(id)sender;
-(void)mycar;
-(void)tabbarIndex:(NSInteger)tabbarindex;
-(IBAction)refreshClicked:(id)sender;
-(IBAction)signBtnClicked:(id)sender;

@end
