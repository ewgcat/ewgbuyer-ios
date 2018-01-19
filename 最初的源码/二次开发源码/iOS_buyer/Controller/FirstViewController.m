//
//  FirstViewController.m
//  My_App
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "Seconde_sub2ViewController.h"
#import "SearchViewController.h"
#import "MyMessageViewController.h"
#import "StoreHomeViewController2.h"
#import "ASIFormDataRequest.h"
#import "ScanScanViewController.h"
#import "ExchangeHomeViewController.h"
#import "zeroListViewController.h"
#import "LoginViewController.h"
#import "getAllActivityNavViewController.h"
#import "ScanLoginViewController.h"
#import "Reachability.h"
#import "index_ad_Cell.h"
#import "firstModel.h"
#import "NotifWebViewController.h"
#import "templet_single_one_Cell.h"
#import "templet_single_two_Cell.h"
#import "templet_single_three_Cell.h"
#import "templet_Four_Cell.h"
#import "floorTitleCell.h"
#import "CycleScrollView.h"
#import "templet_six_Cell.h"
#import "templet_Five_Cell.h"
#import "NewLoginViewController.h"
#import "FreeCouponsViewController.h"
#import "MyCollectViewController.h"
#import "GroupPurchaseViewController.h"
#import "DetailViewController.h"
#import "CashBalanceViewController.h"
#import "OrderListViewController.h"
#import "OneYuanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FouthViewController.h"
#import "FirstIndexxCell.h"


#define CLICK_TYPE "goods"

#define kIndexFilePath [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/firstCache"]
#define kIndexTextColor [UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1]
#define kIndexTextFont [UIFont systemFontOfSize:12]

CFAbsoluteTime timeOnUI;

@interface FirstViewController ()<CycleScrollViewDelegate, FirstIndexxCellDelegate>
{
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *index_ad_request;
    ASIFormDataRequest *index_floor_request;
    SecondViewController *sec;
    BOOL cloudPurchase;
    BOOL groupPurchase;
    
}
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@property (nonatomic, assign)CGFloat previousY;
@property (nonatomic, weak)UIPageControl *pageControl;
@property (nonatomic, assign)NSInteger oldPage;
@property (nonatomic, strong)ScanScanViewController *scanscan;
@property (nonatomic, strong) NSMutableArray *netImageArray;
@property (nonatomic, strong) NSArray *allViews;

@end

static FirstViewController *singleInstance=nil;

@implementation FirstViewController
@synthesize scanStr;

+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    return singleInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _onBool = YES;
        // Custom initialization
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
    }
    return self;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
   
#if DEV
    NSLog(@"开发");
#else
    NSLog(@"发布");
#endif
    
    
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(219,34,46);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    sec = [SecondViewController sharedUserDefault];
    self.title = @"首页";
    _willAppearBool = NO;
    indexPicBool = NO;
    
    if (MessageCount.text.intValue == 0) {
        MessageCount.hidden = YES;
    }
    [MessageCount.layer setMasksToBounds:YES];
    [MessageCount.layer setCornerRadius:10];
    dataArray = [[NSMutableArray alloc]init];
    secontionArray = [[NSMutableArray alloc]init];
    secontionTitleArray = [[NSMutableArray alloc]init];
    _loginBool = NO;
    [searchLabel.layer setMasksToBounds:YES];
    [searchLabel.layer setCornerRadius:4];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    loadingV.hidden = YES;
    _payType = @"self";
    
    
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    [MyTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width*400/720) animationDuration:2];
    self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
}
-(void)cloudPurchase
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASESTATUS_URL];
       [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"云购状态******%@",responseObject);
        NSDictionary *dict = responseObject;

           NSString *cloud=[[dict objectForKey:@"cloudbuy"]stringValue];
           if ([cloud isEqualToString:@"100"]) {
               cloudPurchase=YES;
           }else
           {
               cloudPurchase=NO;
           }
           NSString *group=[[dict objectForKey:@"group"]stringValue];
           if ([group isEqualToString:@"100"]) {
               groupPurchase=YES;
           }else
           {
               groupPurchase=NO;
           }
           
        
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           cloudPurchase=NO;
    }];

}

#pragma mark - 这里住着按钮大家族
-(NSArray *)getIndexArray{
    
    NSArray *arr=[[NSArray alloc]init];
    if (cloudPurchase == YES && groupPurchase == YES) {
         arr=@[@"我的关注",@"物流查询",@"云购",@"免费抢券",@"促销",@"团购",@"积分商城",@"0元试用"];
    }
    
    else if (cloudPurchase == YES && groupPurchase == NO) {
        arr=@[@"我的关注",@"物流查询",@"云购",@"免费抢券",@"促销",@"积分商城",@"0元试用"];
    }
    
    else if (cloudPurchase == NO && groupPurchase == YES) {
        arr=@[@"我的关注",@"物流查询",@"品牌",@"免费抢券",@"促销",@"团购",@"积分商城",@"0元试用"];
    }
    
    else if (cloudPurchase == NO && groupPurchase == NO) {
        arr=@[@"我的关注",@"物流查询",@"品牌",@"免费抢券",@"促销",@"积分商城",@"0元试用"];
    }
    return arr;
    
}
-(NSArray *)allViews{
    if (!_allViews) {
        _allViews = [FirstIndexxCell getAllKindsOfButton];
    }
    return _allViews;
}
-(NSArray *)getRealArray{
    NSArray *allViews = self.allViews;
    NSArray *indexTitles = [self getIndexArray];
    NSMutableArray *viewArray = [NSMutableArray array];
    for (NSString *title1 in indexTitles) {
        for (FirstIndexxCell *view in allViews) {
            if ([view.title isEqualToString:title1]) {
                [viewArray addObject:view];
            }
        }
    }
    return viewArray;
}
-(BOOL)loginAlready{
    return [[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH];
}

#pragma mark - 页面跳转
-(void)firstIndexxCell:(FirstIndexxCell *)cell didClickedWithTitle:(NSString *)title{
    UIViewController *vc = nil;
    if(![self loginAlready]){
        //没登录
        if ([title isEqualToString:@"我的关注"]||[title isEqualToString:@"物流查询"]||[title isEqualToString:@"免费抢券"]||[title isEqualToString:@"积分商城"]) {
            vc = [[NewLoginViewController alloc]init];
        }
    } else {
        //已登录
        if ([title isEqualToString:@"我的关注"]) {
            vc =[[MyCollectViewController alloc]init];
        }  else if ([title isEqualToString:@"物流查询"]) {
            LoginViewController *login = [LoginViewController sharedUserDefault];
            login.orderTag=3;
            vc =[[OrderListViewController alloc]init];
        }  else if ([title isEqualToString:@"免费抢券"]) {
           
            vc = [[FreeCouponsViewController alloc]init];
        } else if ([title isEqualToString:@"积分商城"]) {
            vc = [[ExchangeHomeViewController alloc]init];
        }
    }
    if ([title isEqualToString:@"云购"]) {
        vc =[OneYuanViewController new] ;
    }  else if ([title isEqualToString:@"促销"]) {
        vc =[[getAllActivityNavViewController alloc]init];
    }  else if ([title isEqualToString:@"0元试用"]) {
        UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"first" bundle:nil];
        vc = [homePageStoryboard instantiateViewControllerWithIdentifier:@"zeroListViewController"];
    } else if ([title isEqualToString:@"品牌"]) {
        vc = [[FouthViewController alloc]init];
        ((FouthViewController *)vc).brandNav=YES;
    } else if ([title isEqualToString:@"团购"]) {
        vc = [[GroupPurchaseViewController alloc]init];
    }
    if (!vc) {
        NSLog(@"未知的控制器，自己加上面去");
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 检查未读信息
-(void)checkMessage{
    if(![[NSFileManager defaultManager]fileExistsAtPath:INFORMATION_FILEPATH]){
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken]
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *ret = dict[@"ret"];
        if ([ret isEqualToString:@"true"]) {
            NSArray *msgList = dict[@"msg_list"];
            NSInteger msgCount = msgList.count;
            NSLog(@"共有%lu条系统信息",(long)msgCount);
            //设置到“badge”
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (msgCount == 0) {
                    MessageCount.hidden = YES;
                }else {
                    MessageCount.hidden = NO;
                    MessageCount.text = [NSString stringWithFormat:@"%lu",(long)msgCount];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self index_ad_network];//广告请求
    [self index_floor_network];//请求楼层数据
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self cloudPurchase];
    NSLog(@"%ld",(long)self.navigationController.viewControllers.count);
    backBtn.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (_loginBool == NO) {
        //用户已登录
    }else{
        //用户没登录
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 4;
        _loginBool = NO;
    }
    [self checkMessage];
    [MyTableView reloadData];
      //购物车数量提示
    [SYShopAccessTool getItemBadgeValue];
    MyTableView.tableFooterView = [[UIView alloc]init];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
   

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)netExist{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        if (secontionArray.count!=0) {
            [secontionArray removeAllObjects];
        }
        if (secontionTitleArray.count!=0) {
            [secontionTitleArray removeAllObjects];
        }
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = [consultViewNetwork dataFloorDataCacheData];
        secontionTitleArray = [arr objectAtIndex:0];
        secontionArray = [arr objectAtIndex:1];
        
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataIndexAdDataCacheData];
        [MyTableView reloadData];
    }else if (networkStatus == kReachableViaWiFi){ }else{ }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [MyTableView headerEndRefreshing];
    [self loadPage];
   
}

#pragma mark - 点击事件
-(void)Three_Action:(UIButton *)btn{
    if(secontionArray.count !=0){
        NSMutableArray *arr = [secontionArray objectAtIndex:btn.tag/100-1];
        firstModel *first = [arr objectAtIndex:(btn.tag-(btn.tag/100)*100)/3];
        
        NSInteger index = btn.tag-btn.tag/100*100 - (btn.tag-(btn.tag/100)*100)/3*3;
        NSString *clickType = [first.line_info objectAtIndex:index][@"click_type"];
        NSString *clickInfo = first.line_info[index][@"click_info"];
        if ([clickType isEqualToString:@"goods"]) {
            sec.detail_id = [SYObject stringByNumber:clickInfo];
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([clickType isEqualToString:@"url"]){
            NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
            notifVC.request = [Requester requestByBaldURLString:clickInfo];
            [self.navigationController pushViewController:notifVC animated:YES];
        }
    }
}
-(void)One_Action:(UIButton *)btn{
    if(secontionArray.count !=0){
        NSMutableArray *arr = [secontionArray objectAtIndex:btn.tag/100-1];
        firstModel *first = [arr objectAtIndex:(btn.tag-(btn.tag/100)*100)/1];
        NSInteger index = btn.tag-btn.tag/100*100 - (btn.tag-(btn.tag/100)*100)/1*1;
        NSString *clickType = [first.line_info objectAtIndex:index][@"click_type"];
        NSString *clickInfo = first.line_info[index][@"click_info"];
        if ([clickType isEqualToString:@"goods"]) {
            sec.detail_id = [SYObject stringByNumber:clickInfo];
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([clickType isEqualToString:@"url"]){
            NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
            notifVC.request = [Requester requestByBaldURLString:clickInfo];
            [self.navigationController pushViewController:notifVC animated:YES];
        }
    }
}
-(void)Four_Action:(UIButton *)btn{
    if(secontionArray.count !=0){
        NSMutableArray *arr = [secontionArray objectAtIndex:btn.tag/100-1];
        firstModel *first = [arr objectAtIndex:(btn.tag-(btn.tag/100)*100)/4];
        NSInteger index = btn.tag-btn.tag/100*100 - (btn.tag-(btn.tag/100)*100)/4*4;
        NSString *clickType = [[first.line_info objectAtIndex:index] objectForKey:@"click_type"];
        NSString *clickInfo = first.line_info[index][@"click_info"];
        if ([clickType isEqualToString:@"goods"]) {
            sec.detail_id = [SYObject stringByNumber:clickInfo];
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([clickType isEqualToString:@"url"]){
            NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
            notifVC.request = [Requester requestByBaldURLString:clickInfo];
            [self.navigationController pushViewController:notifVC animated:YES];
        }
    }
}
-(void)templet_singleTwoLeftAction:(UIButton *)btn{
    if(secontionArray.count !=0){
        NSMutableArray *arr = [secontionArray objectAtIndex:btn.tag/100-1];
        firstModel *first = [arr objectAtIndex:(btn.tag-(btn.tag/100)*100)/2];
        NSInteger index = btn.tag-btn.tag/100*100 - (btn.tag-(btn.tag/100)*100)/2*2;
        NSString *clickType = [first.line_info objectAtIndex:index][@"click_type"];
        NSString *clickInfo = first.line_info[index][@"click_info"];
        if ([clickType isEqualToString:@"goods"]) {
            sec.detail_id = [SYObject stringByNumber:clickInfo];
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([clickType isEqualToString:@"url"]){
            NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
            notifVC.request = [Requester requestByBaldURLString:clickInfo];
            [self.navigationController pushViewController:notifVC animated:YES];
        }
    }
}
-(IBAction)refreshClicked:(id)sender
{
}

- (IBAction)linshiBtnClicked:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"first" bundle:nil];
    zeroListViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"zeroListViewController"];;
    [self.navigationController pushViewController:ordrt animated:YES];
}


#pragma mark 网络
-(void)setNetImages{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_NAV_URL];
    self.netImageArray = [[NSMutableArray alloc]init];
    [[Requester manager]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"code"]intValue]==100)
        {
            
            for(int i=1;i<9;i++)
            {
                if ([dict objectForKey:[NSString stringWithFormat:@"index_%d",i]])
                {
                    [self.netImageArray addObject:[dict objectForKey:[NSString stringWithFormat:@"index_%d",i]]];
                }
            }
        }
        [self postNotif];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self postNotif];
    }];
}
//发送通知更新8个按钮的图片
-(void)postNotif{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kaifanle" object:nil userInfo:@{@"nidefan":self.netImageArray}];
}

#pragma mark - 请求楼层数据
-(void)index_floor_network{
    index_floor_request = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_FLOOR_URL] setKey:nil setValue:nil];
    [index_floor_request setDidFailSelector:@selector(index_floor_analyzeFaild:)];
    [index_floor_request setDidFinishSelector:@selector(index_floor_analyzeSuccess:)];
    index_floor_request.delegate = self;
    [index_floor_request startAsynchronous];
}
-(void)restoreCachedData{
    [secontionTitleArray removeAllObjects];
    [secontionArray removeAllObjects];
    
    NSArray *floorArray = [[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"homepage.txt"]];
    NSDictionary *dicBig = [floorArray objectAtIndex:0];
    if(dicBig){
        NSArray *arrFloor = [dicBig objectForKey:@"floor_list"];
        for(NSDictionary *dic in arrFloor){
            NSArray *arrCeng = [dic objectForKey:@"lines_info"];
            NSMutableArray *arrcc = [[NSMutableArray alloc]init];
            for(NSDictionary *dicCeng in arrCeng){
                firstModel *first = [[firstModel alloc]init];
                
                first.sequence = [[dicCeng objectForKey:@"sequence"] intValue];
                first.line_type = [[dicCeng objectForKey:@"line_type"] intValue];
                first.line_info = [dicCeng objectForKey:@"line_info"];
                [arrcc addObject:first];
            }
            [secontionTitleArray addObject:[dic objectForKey:@"title"]];
            [secontionArray addObject:arrcc];
        }
    }
}
-(void)index_floor_analyzeSuccess:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (secontionArray.count!=0) {
            [secontionArray removeAllObjects];
        }
        if (secontionTitleArray.count!=0) {
            [secontionTitleArray removeAllObjects];
        }
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = [consultViewNetwork dataFloorData:request];
        secontionTitleArray = [arr objectAtIndex:0];
        secontionArray = [arr objectAtIndex:1];
        [MyTableView reloadData];
    }else{
        [SYObject failedPrompt:@"楼层请求出错"];
        [self restoreCachedData];
    }
    _reloading = NO;
}
-(void)index_floor_analyzeFaild:(ASIFormDataRequest *)request{
    _reloading = NO;
    [self restoreCachedData];
    [MyTableView reloadData];
}
-(void)index_ad_network{
    index_ad_request = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_AD_URL] setKey:nil setValue:nil];
    [index_ad_request setDidFailSelector:@selector(index_ad_analyzeFaild:)];
    [index_ad_request setDidFinishSelector:@selector(index_ad_analyzeSuccess:)];
    index_ad_request.delegate = self;
    [index_ad_request startAsynchronous];
}
-(void)index_ad_analyzeSuccess:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataIndexAdData:request];
    }else{
        [self restoreCachedAd];
        [SYObject failedPrompt:@"广告请求出错"];
    }
    [MyTableView reloadData];
     [SYObject endLoading];
}
-(void)index_ad_analyzeFaild:(ASIFormDataRequest *)request{
    [self restoreCachedAd];
    [SYObject failedPrompt:@"广告网络请求失败"];
}
-(void)restoreCachedAd{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"indexPics"];
    dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [MyTableView reloadData];
}
#pragma mark - tableView
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (secontionArray.count!=0) {
        return secontionArray.count + 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        if(section == 0){
            return 1;
        }else{
            if (secontionArray.count != 0) {
                NSArray *arr =[secontionArray objectAtIndex:section-1];
                return [arr count];
            }
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat h1 = 165+ ScreenFrame.size.width*150/320 + 27.8;
        return h1;
    }else{
        if(secontionArray.count !=0){
            NSMutableArray *arr = [secontionArray objectAtIndex:indexPath.section-1];
            firstModel *first = [arr objectAtIndex:indexPath.row];
            if (first.line_info.count == 0) {
                return 0;
            }
            CGFloat www = [[[first.line_info objectAtIndex:0]objectForKey:@"width"] floatValue];
            CGFloat hhh = [[[first.line_info objectAtIndex:0]objectForKey:@"height"] floatValue];
            
            if (first.line_type == 1) {
                return ScreenFrame.size.width*hhh/www+1;
            }else if (first.line_type == 2){
                return ScreenFrame.size.width/2*hhh/www+1;
            }else if (first.line_type == 3){
                return ScreenFrame.size.width/3*hhh/www+1;
            }else if (first.line_type == 4){
                UIImageView *imageA = [[UIImageView alloc]init];
                [imageA sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                NSStringFromCGSize(imageA.image.size);
                return imageA.image.size.height*ScreenFrame.size.width/4/imageA.image.size.width;
            }else if (first.line_type == 6){
                return SIX_HEIGHT;
            }else if (first.line_type == 7){
                return ScreenFrame.size.width/3*hhh/www+1;
            }
        }
    }
    return 0;
}
//头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (secontionArray.count!=0) {
        if(section != 0){
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 50)];
            view.backgroundColor = [UIColor whiteColor];
            UIImageView *iage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21, 2, 25)];
            iage.backgroundColor = MY_COLOR;
            [view addSubview:iage];
            UIView *viewG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 16)];
            viewG.backgroundColor = BACKGROUNDCOLOR;
            [view addSubview:viewG];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, ScreenFrame.size.width, 30)];
            label.text = [secontionTitleArray objectAtIndex:section-1];
            label.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightLight];
            [view addSubview:label];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, view.height - 1, view.width, 1)];
            line.backgroundColor = UIColorFromRGB(0xefefef);
            [view addSubview:line];
            return view;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 50;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        index_ad_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"index_ad_Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"index_ad_Cell" owner:self options:nil] lastObject];
        }
        if (dataArray.count!=0) {
            //缓存dataArray
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"indexPics"];
            if([NSKeyedArchiver archiveRootObject:dataArray toFile:filePath]) {NSLog(@"广告图片缓存成功!");}
            else {NSLog(@"广告图片缓存失败!");}
            
            NSMutableArray *viewsArray = [@[] mutableCopy];
            for (int i = 0; i < dataArray.count; ++i) {
                firstModel *first = [dataArray objectAtIndex:i];
                UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width*400/720)];
                [tempLabel sd_setImageWithURL:[NSURL URLWithString:first.img_url] placeholderImage:[self grayImage]];
                [viewsArray addObject:tempLabel];
            }
            
            __unsafe_unretained FirstViewController *blockself = self;
            
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                //总页数
                return blockself->dataArray.count;
            };
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                //点击方法
                NSString *str=[NSString stringWithFormat:@"%ld",(long)pageIndex+1];
                [blockself getIndexAdClick:str];
                firstModel *first = [blockself->dataArray objectAtIndex:pageIndex];
                NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
                NSString *urlStr = [NSString stringWithFormat:@"http://%@",first.click_url];
                NSURL *url = [NSURL URLWithString:urlStr];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                notifVC.request = request;
                [blockself.navigationController pushViewController:notifVC animated:YES];
                
            };
            self.mainScorllView.delegate = self;
            [cell addSubview:self.mainScorllView];
            
            //小点点
            CGFloat w = 10 * dataArray.count;
            CGFloat x = ScreenFrame.size.width - w - 50;
            if (ScreenFrame.size.height<=480) {
                x = ScreenFrame.size.width - w - 10;
            }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
                x = ScreenFrame.size.width - w - 20;
            }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
                x = ScreenFrame.size.width - w - 50;
            }else{
                x = ScreenFrame.size.width - w - 70;
            }
            
            CGFloat h = 10;
            CGFloat y = self.mainScorllView.height - h;
            CGRect frame = CGRectMake(x, y, w, h);
            UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:frame];
            pageControl.numberOfPages = dataArray.count;
            self.pageControl = pageControl;
            self.pageControl.currentPage=self.mainScorllView.currentPageIndex;
            [cell addSubview:pageControl];
        }
        
        //8个按钮
        CGFloat scrollViewH = ScreenFrame.size.width * 400 / 720;
        CGFloat cell1Hx = 165+ ScreenFrame.size.width*150/320 + 27.8;
        CGFloat eW = ScreenFrame.size.width / 4.0;
        CGFloat eH = (cell1Hx - scrollViewH) / 2;
        NSArray *indexArrx = [self getRealArray];
        for (int i=0; i<indexArrx.count; i++) {
            FirstIndexxCell *viewXYZ = indexArrx[i];
            CGFloat eX = (i % 4) * eW;
            CGFloat eY = (i / 4) * eH + scrollViewH;
            viewXYZ.frame = CGRectMake(eX, eY, eW, eH);
            [cell.contentView addSubview:viewXYZ];
            viewXYZ.delegate = self;
        }
        //重新请求网络图片
        [self setNetImages];
        
        return cell;
        
    }
    else{
        if(secontionArray.count !=0){
            NSMutableArray *arr = [secontionArray objectAtIndex:indexPath.section-1];
            firstModel *first = [arr objectAtIndex:indexPath.row];
            if (first.line_type == 1) {
                templet_single_one_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_single_one_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_single_one_Cell" owner:self options:nil] lastObject];
                }
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                
                cell.OneBtn.tag = indexPath.section*100+indexPath.row;
                [cell.OneBtn addTarget:self action:@selector(One_Action:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (first.line_type == 2) {
                templet_single_two_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_single_two_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_single_two_Cell" owner:self options:nil] lastObject];
                }
                [cell.photoImageLeft sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImageRight sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:1]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                
                cell.LeftBtn.tag = indexPath.section*100+indexPath.row*2;
                cell.RightBtn.tag = indexPath.section*100+indexPath.row*2+1;
                [cell.LeftBtn addTarget:self action:@selector(templet_singleTwoLeftAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.RightBtn addTarget:self action:@selector(templet_singleTwoLeftAction:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (first.line_type == 3) {
                templet_Five_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_Five_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_Five_Cell" owner:self options:nil] lastObject];
                }
                
                [cell setData_Left:[first.line_info objectAtIndex:0] Middle:[first.line_info objectAtIndex:1] Right:[first.line_info objectAtIndex:2]];
                
                cell.OneBtn.tag = indexPath.section*100+indexPath.row*3;
                cell.TwoBtn.tag = indexPath.section*100+indexPath.row*3+1;
                cell.ThreeBtn.tag = indexPath.section*100+indexPath.row*3+2;
                [cell.OneBtn addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.TwoBtn addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.ThreeBtn addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }else if (first.line_type == 4) {
                templet_single_three_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_single_three_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_single_three_Cell" owner:self options:nil] lastObject];
                }
                [cell.photoImage_one sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImage_two sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:1]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImage_three sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:2]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImage_four sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:3]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                
                cell.OneBtn.tag = indexPath.section*100+indexPath.row*4;
                cell.TwoBtn.tag = indexPath.section*100+indexPath.row*4+1;
                cell.ThreeBtn.tag = indexPath.section*100+indexPath.row*4+2;
                cell.FourBtn.tag = indexPath.section*100+indexPath.row*4+3;
                [cell.OneBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.TwoBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.ThreeBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.FourBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (first.line_type == 6) {
                templet_Four_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_Four_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_Four_Cell" owner:self options:nil] lastObject];
                }
                [cell.photoImage_one sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImage_two sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:1]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImage_three sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:2]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                
                cell.OneBtn.tag = indexPath.section*100+indexPath.row*3;
                cell.TwoBtn.tag = indexPath.section*100+indexPath.row*3+1;
                cell.ThreeBt.tag = indexPath.section*100+indexPath.row*3+2;
                [cell.OneBtn addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.TwoBtn addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.ThreeBt addTarget:self action:@selector(Three_Action:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (first.line_type == 7) {
                templet_six_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_six_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_six_Cell" owner:self options:nil] lastObject];
                }
                
                [cell setData_Left:[first.line_info objectAtIndex:0] Middle:[first.line_info objectAtIndex:1] BottomLeft:[first.line_info objectAtIndex:2] BottomRight:[first.line_info objectAtIndex:3]];
                
                cell.OneBtn.tag = indexPath.section*100+indexPath.row*4;
                cell.TwoBtn.tag = indexPath.section*100+indexPath.row*4+1;
                cell.ThreeBtn.tag = indexPath.section*100+indexPath.row*4+2;
                cell.FourBtn.tag = indexPath.section*100+indexPath.row*4+3;
                [cell.OneBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.TwoBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.ThreeBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.FourBtn addTarget:self action:@selector(Four_Action:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)getIndexAdClick:(NSString *)Id{
    NSString *adurl =[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_AD_CLICK_URL];
    NSDictionary *par = @{@"id":Id};
    //[Requester managerWithHeader]
    [[Requester manager]POST:adurl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求出现错误"];
    }];
}
-(UIImage *)grayImage{
    return [UIImage imageNamed:@"pure_gray"];
}
#pragma mark - 循环滚动
-(void)cycleScrollViewDidEndDecelerating:(CycleScrollView *)scrollView curPage:(NSInteger)curPage{
    if(curPage == self.oldPage){return;}
    self.pageControl.currentPage = curPage;
    self.oldPage = curPage;
}
-(void)turnPage{
    int page = (int)topPageControl.currentPage; // 获取当前的page
    [topScrollView scrollRectToVisible:CGRectMake(ScreenFrame.size.width*(page+1),0,ScreenFrame.size.width,174) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = topScrollView.frame.size.width;
    int currentPage = floor((topScrollView.contentOffset.x - pagewidth/ ([dataArray count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [topScrollView scrollRectToVisible:CGRectMake(ScreenFrame.size.width * [dataArray count],0,ScreenFrame.size.width,174) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([dataArray count]+1))
    {
        [topScrollView scrollRectToVisible:CGRectMake(ScreenFrame.size.width,0,ScreenFrame.size.width,174) animated:NO]; // 最后+1,循环第1页
    }
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)topPageControl.currentPage; // 获取当前的page
    page++;
    page = page > dataArray.count ? 0 : page ;
    topPageControl.currentPage = page;
    [self turnPage];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == MyTableView) {
        CGFloat offset=scrollView.contentOffset.y;
        
        if (offset<0) {
            navImage.alpha = 0;
            topSearchView.hidden = YES;
        }else {
            CGFloat alpha=1-((64-offset)/64);
            navImage.alpha=alpha;
            searchImage.alpha = alpha + 0.7;
            searchLabel.alpha = alpha + 0.7;
            topSearchView.hidden = NO;
        }
        _previousY = offset;
        
        if (offset<174-64) {
            backBtn.hidden=YES;
        }else
        {
            backBtn.hidden=NO;
        
        }
    
        
    }
    if (scrollView == topScrollView) {
        CGFloat pagewidth = topScrollView.frame.size.width;
        int page = floor((topScrollView.contentOffset.x - pagewidth/([dataArray count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        topPageControl.currentPage = page;
    }
}

//加载网页
- (void)loadPage {
    _reloading = YES;
    [self index_floor_network];
    [self index_ad_network];
    [self cloudPurchase];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}
-(void)mycar{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 2;
}

- (IBAction)MysearchBtnClicked:(id)sender {
    SearchViewController *ordrt = [[SearchViewController alloc]init];;
    [self.navigationController pushViewController:ordrt animated:YES];
}

- (IBAction)ScanClicekedMy:(id)sender {
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
        NewLoginViewController *new = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }else{
        MyMessageViewController *my = [[MyMessageViewController alloc]init];
        [self.navigationController pushViewController:my animated:YES];
    }
}

- (IBAction)gotoTopAction:(id)sender {
    [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)tabbarIndex:(NSInteger)tabbarindex{
    if (tabbarindex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
    }else if (tabbarindex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 1;
    }else if (tabbarindex == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 2;
    }else if (tabbarindex == 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 3;
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 4;
    }
}

- (IBAction)signBtnClicked:(id)sender {
//    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
//        
//    if (login) {
//            
//            ScanScanViewController *s = [ScanScanViewController new];
//            //[self presentViewController:s animated:YES completion:nil];
//            [self.navigationController pushViewController:s animated:NO];
//        }}];
    ScanScanViewController *s = [ScanScanViewController new];
    //[self presentViewController:s animated:YES completion:nil];
    [self.navigationController pushViewController:s animated:NO];

//    iOS 判断应用是否有使用相机的权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [OHAlertView showAlertWithTitle:@"" message:@"请在iPhone的“设置-隐私—相机”选项中，允许商城访问你的相机" cancelButton:@"好" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        }];
        return;
    }
    
}




@end
