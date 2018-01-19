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
#import <AVFoundation/AVFoundation.h>
#import "FouthViewController.h"
#import "FirstIndexxCell.h"
#import "Seconde_sub2ViewController.h"
#import "IntegraDetialViewController.h"
#import "BrandGoodListViewController.h"
#import "getActivityGoodsViewController.h"
#import "ChinaViewController.h"
#import "GlobalViewController.h"
#import "Requester.h"
#import "TTLoopView.h"
#import "GYChangeTextView.h"
#import "IndexNewsViewController.h"

#define CLICK_TYPE "goods"

#define kIndexFilePath [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/firstCache"]
#define kIndexTextColor [UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1]
#define kIndexTextFont [UIFont systemFontOfSize:12]

CFAbsoluteTime timeOnUI;

@interface FirstViewController ()< FirstIndexxCellDelegate,GYChangeTextViewDelegate>
{
    SecondViewController *sec;
    BOOL cloudPurchase;
    BOOL groupPurchase;
    int _flag;//更新状态
    
    GYChangeTextView *showScrollView;//文字滚动的界面

    
}
@property (nonatomic, assign)CGFloat previousY;
@property (nonatomic, strong)ScanScanViewController *scanscan;
@property (nonatomic, strong) NSMutableArray *netImageArray;
@property (nonatomic, strong) NSArray *allViews;
@property (nonatomic, strong) NSArray *newsArr;//今日头条的数组
@property (nonatomic, strong) NSString *moreUrlString;//点击更多的那个url


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

#pragma mark - 检查更新
-(void)checkUpdate{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
 
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/vjson.htm?type=ios"];
    
    
   
    [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"remark======%@",dic);
        NSString *v;
        
        if (dic[@"type"]) {
            NSString *he=[NSString stringWithFormat:@"%@",dic[@"type"]];
            if ([he isEqualToString:@"0"]) {//0的话就不更新
                return;
            }
        }
        if (dic[@"vjson"]) {
            v=dic[@"vjson"];//版本
            if (v.floatValue >app_Version.floatValue) {
                //需要更新
                if(dic[@"type"]){// 1强制更新0不更新2建议更新
                    
                    NSString *a=[NSString stringWithFormat:@"%@",dic[@"type"]];
                    _flag=a.floatValue;
                    
                    NSString *remark;
                    if(dic[@"remark"]){
                        remark=dic[@"remark"];
                    }else{
                        remark=@"";
                    }
                    if (_flag==1) {//强制更新
                        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"版本更新" message:remark delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                        [a show];
                        
                    }else{
                        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"版本更新" message:remark delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                        [a show];
                    }
                    
                }
            }
        }
        
        
   
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
      
        
    }];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(_flag==1){//强制升级的
        if(buttonIndex==0){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
        }
        
    }else{
        if(buttonIndex==1){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
        }
    }
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self checkUpdate];
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
    [self getTitleAD];

    
}
-(void)getTitleAD{

    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/information.htm"];
    
    
    __weak typeof(self) weakSelf=self;
    [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"dicdic==%@",dic);
        weakSelf.newsArr=dic[@"ac_list"];
        weakSelf.moreUrlString=dic[@"url"];

        for (NSDictionary *dic in weakSelf.newsArr) {
            NSLog(@"===++===%@",dic[@"title"]);

        }
        NSLog(@"===++===%@",dic[@"ac_list"]);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        
        
    }];


}
#pragma mark -更多的点击事件

-(void)moreButtonClick{
    if (_moreUrlString) {
        IndexNewsViewController *vc=[[IndexNewsViewController alloc]init];
        
        vc.urlString=_moreUrlString;
        vc.title=@"更多";
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SYObject failedPrompt:@"暂无更多"];
    }
    
}
#pragma mark -点击文字滚动的界面
- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    if (_newsArr.count!=0) {
        NSDictionary *dic= _newsArr[index];
        NSString *urlSting=dic[@"ac_url"];
        NSString *title=dic[@"title"];
        IndexNewsViewController *vc=[[IndexNewsViewController alloc]init];
        vc.urlString=urlSting;
        vc.title=title;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        

    }
}

-(void)cloudPurchase
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASESTATUS_URL];
       [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"云购状态******%@",responseObject);
        NSDictionary *dict = responseObject;

           NSString *cloud=[[dict objectForKey:@"iosKey"]stringValue];
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

#pragma mark - 这里住着按钮大家族的title
-(NSArray *)getIndexArray{
    
    NSArray *arr=[[NSArray alloc]init];
//    if (cloudPurchase == YES && groupPurchase == YES) {
//         arr=@[@"我的关注",@"物流查询",@"云购",@"免费抢券",@"促销",@"团购",@"积分商城",@"0元试用"];
//    }
//    
//    else if (cloudPurchase == YES && groupPurchase == NO) {
//        arr=@[@"我的关注",@"物流查询",@"云购",@"免费抢券",@"促销",@"积分商城",@"0元试用"];
//    }
//    
//    else if (cloudPurchase == NO && groupPurchase == YES) {
//        arr=@[@"我的关注",@"物流查询",@"品牌",@"免费抢券",@"促销",@"团购",@"积分商城",@"0元试用"];
//    }
//    
//    else if (cloudPurchase == NO && groupPurchase == NO) {
//        arr=@[@"我的关注",@"物流查询",@"品牌",@"免费抢券",@"促销",@"积分商城",@"0元试用"];
//    }
//    if (cloudPurchase == NO && groupPurchase == NO)
//    如果云购等于no，则发起通知，
    NSLog(@"--+cloudPurchase++==%zd",cloudPurchase);
//    cloudPurchase=NO;
#pragma mark - 云购这里先改成if 0
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    if([[d valueForKey:@"yy"] isEqualToString:@"0"]){
//        arr=@[@"品牌街",@"积分商城",@"e云购",@"团购",@"免费领券",@"促销",@"中国馆",@"全球馆"];
        arr=@[@"品牌街",@"积分商城",@"促销",@"全球馆"];

        
        
    }else if(cloudPurchase == YES){
        [d setObject:@"0" forKey:@"yy"];
        [d synchronize];
//        arr=@[@"品牌街",@"积分商城",@"e云购",@"团购",@"免费领券",@"促销",@"中国馆",@"全球馆"];
        arr=@[@"品牌街",@"积分商城",@"促销",@"全球馆"];


    
    }else if(cloudPurchase == NO){
        [d setObject:@"1" forKey:@"yy"];
        [d synchronize];
        //        @"e云购",@"团购"
//        arr=@[@"品牌街",@"积分商城",@"免费领券",@"促销",@"中国馆",@"全球馆"];
        arr=@[@"品牌街",@"积分商城",@"促销",@"全球馆"];

        
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

#pragma mark - 页面跳转(八大button的跳转)
-(void)firstIndexxCell:(FirstIndexxCell *)cell didClickedWithTitle:(NSString *)title{
    UIViewController *vc = nil;
    if(![self loginAlready]){
        //没登录
        if ([title isEqualToString:@"团购"]||[title isEqualToString:@"物流查询"]||[title isEqualToString:@"免费领券"]||[title isEqualToString:@"积分商城"]) {
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
        }  else if ([title isEqualToString:@"免费领券"]) {
           
            vc = [[FreeCouponsViewController alloc]init];
        } else if ([title isEqualToString:@"积分商城"]) {
            vc = [[ExchangeHomeViewController alloc]init];
        }
    }
    if ([title isEqualToString:@"e云购"]) {
//        vc =[OneYuanViewController new] ;
    }  else if ([title isEqualToString:@"促销"]) {
        vc =[[getAllActivityNavViewController alloc]init];
    }  else if ([title isEqualToString:@"0元试用"]) {
        UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"first" bundle:nil];
        vc = [homePageStoryboard instantiateViewControllerWithIdentifier:@"zeroListViewController"];
    } else if ([title isEqualToString:@"品牌街"]) {
        vc = [[FouthViewController alloc]init];
//        ((FouthViewController *)vc).brandNav=YES;
        vc.hidesBottomBarWhenPushed=YES;

    } else if ([title isEqualToString:@"团购"]) {
        vc = [[GroupPurchaseViewController alloc]init];
    }else if ([title isEqualToString:@"中国馆"]){
        ChinaViewController *china=[[ChinaViewController alloc]init];
        china.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:china animated:YES];
       //        [SYObject failedPrompt:@"敬请关注"];
    }else if ([title isEqualToString:@"全球馆"]){
        GlobalViewController *global=[[GlobalViewController alloc]init];
        global.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:global animated:YES];

//        [SYObject failedPrompt:@"敬请关注"];

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
            NSMutableArray *unreadMsg=[NSMutableArray array];
            for (NSDictionary *d in msgList) {
                NSString *s=[NSString stringWithFormat:@"%@",d[@"status"]];
                if ([s isEqualToString:@"0"]) {
                    [unreadMsg addObject:s];
                }
            }
            
            NSInteger msgCount = unreadMsg.count;
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
        }else if([clickType isEqualToString:@"goods_class"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=arr[1];
            
            Seconde_sub2ViewController *vc=[[Seconde_sub2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([clickType isEqualToString:@"goods_brand"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            BrandGoodListViewController *secddd = [[BrandGoodListViewController alloc]init];
            [self.navigationController pushViewController:secddd animated:YES];
            
        }else if([clickType isEqualToString:@"integral"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            

            
            ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
            exc.ig_id = arr[0];
            IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
            [self.navigationController pushViewController:integraDetialVC animated:YES];
        
        }else if([clickType isEqualToString:@"activity"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
            all.classifyModel=[[ClassifyModel alloc]init];

            all.classifyModel.goods_id=arr[0];
            getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
            get.hidesBottomBarWhenPushed=YES;

            [self.navigationController pushViewController:get animated:YES];
        
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
        }else if([clickType isEqualToString:@"goods_class"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            Seconde_sub2ViewController *vc=[[Seconde_sub2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if([clickType isEqualToString:@"goods_brand"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            BrandGoodListViewController *secddd = [[BrandGoodListViewController alloc]init];
            [self.navigationController pushViewController:secddd animated:YES];
            
            
        }else if([clickType isEqualToString:@"integral"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            
            
            ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
            exc.ig_id = arr[0];
            IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
            [self.navigationController pushViewController:integraDetialVC animated:YES];
            
        }else if([clickType isEqualToString:@"activity"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
            all.classifyModel=[[ClassifyModel alloc]init];

            all.classifyModel.goods_id=arr[0];
            all.classifyModel.coupon_name=arr[1];

            getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
            get.hidesBottomBarWhenPushed=YES;

            [self.navigationController pushViewController:get animated:YES];
            
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
        }else if([clickType isEqualToString:@"goods_class"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            Seconde_sub2ViewController *vc=[[Seconde_sub2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([clickType isEqualToString:@"goods_brand"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            BrandGoodListViewController *secddd = [[BrandGoodListViewController alloc]init];
            [self.navigationController pushViewController:secddd animated:YES];
            
            
        }else if([clickType isEqualToString:@"integral"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            
            
            ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
            exc.ig_id = arr[0];
            IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
            [self.navigationController pushViewController:integraDetialVC animated:YES];
            
        }else if([clickType isEqualToString:@"activity"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
            all.classifyModel.goods_id=arr[0];
            getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
            get.hidesBottomBarWhenPushed=YES;

            [self.navigationController pushViewController:get animated:YES];
            
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
        NSLog(@"clickInfo==%@",clickInfo);
        if ([clickType isEqualToString:@"goods"]) {
            sec.detail_id = [SYObject stringByNumber:clickInfo];
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([clickType isEqualToString:@"url"]){
            NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
            notifVC.request = [Requester requestByBaldURLString:clickInfo];
            [self.navigationController pushViewController:notifVC animated:YES];
        }else if([clickType isEqualToString:@"goods_class"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            Seconde_sub2ViewController *vc=[[Seconde_sub2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([clickType isEqualToString:@"goods_brand"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            
 NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.sub_id2 = arr[0];
            thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            BrandGoodListViewController *secddd = [[BrandGoodListViewController alloc]init];
            [self.navigationController pushViewController:secddd animated:YES];
            
            
        }else if([clickType isEqualToString:@"integral"]){
            
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            
            
            
            ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
            exc.ig_id = arr[0];
            IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
            [self.navigationController pushViewController:integraDetialVC animated:YES];
            
        }else if([clickType isEqualToString:@"activity"]){
            NSArray *arr= [clickInfo componentsSeparatedByString:@"|"];
            NSLog(@"-+---%@====%@",arr[0],[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""]);
            getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
            all.classifyModel.goods_id=arr[0];
            getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
            get.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:get animated:YES];
            
            
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

    
    __weak typeof(self) ws=self;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_FLOOR_URL];
    [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ws index_floor_analyzeSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        
        _reloading = NO;
        [ws restoreCachedData];
        [MyTableView reloadData];
        
        
    }];

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
-(void)index_floor_analyzeSuccess:(NSDictionary *)dic{
//    int statuscode2 = [request responseStatusCode];
//    if (statuscode2 == 200) {
        if (secontionArray.count!=0) {
            [secontionArray removeAllObjects];
        }
        if (secontionTitleArray.count!=0) {
            [secontionTitleArray removeAllObjects];
        }
        NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    
#if 1
    
    NSMutableArray *mlh_dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *mlh_secontionTitleArray = [[NSMutableArray alloc]init];
    NSMutableArray *mlh_secontionArray = [[NSMutableArray alloc]init];
    //返回code值判断登录是否成功
    NSDictionary *dicBig =dic;
    NSLog(@"dicBig_floor:%@",dicBig);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
                [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            }
        }
        
    });
    
    //保存得到的楼层数据
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"homepage.txt"];
    NSArray *array = [NSArray arrayWithObjects:dicBig, nil];
    [array writeToFile:filePaht atomically:NO];
    
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
            [mlh_secontionTitleArray addObject:[dic objectForKey:@"title"]];
            [mlh_secontionArray addObject:arrcc];
        }
    }
    [mlh_dataArray addObject:mlh_secontionTitleArray];
    [mlh_dataArray addObject:mlh_secontionArray];

    
#endif
    
    
    arr =mlh_dataArray;
        

        
        secontionTitleArray = [arr objectAtIndex:0];
        secontionArray = [arr objectAtIndex:1];
        [MyTableView reloadData];
//    }else{
//        [SYObject failedPrompt:@"楼层请求出错"];
//        [self restoreCachedData];
//    }
    _reloading = NO;
}

-(void)index_ad_network{
    
    
//    index_ad_request = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_AD_URL] setKey:nil setValue:nil];
//    [index_ad_request setDidFailSelector:@selector(index_ad_analyzeFaild:)];
//    [index_ad_request setDidFinishSelector:@selector(index_ad_analyzeSuccess:)];
//    index_ad_request.delegate = self;
//    [index_ad_request startAsynchronous];
//    
    __weak typeof(self) ws=self;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_AD_URL];
    [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ws index_ad_analyzeSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [ws restoreCachedAd];
        [SYObject failedPrompt:@"广告网络请求失败"];
        
        
    }];
    
}
-(void)index_ad_analyzeSuccess:(NSDictionary  *)dic{

        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }

#if 1
    NSMutableArray *mlh_dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =dic;
    //保存得到的广告数据
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"indexAdData.txt"];
    NSArray *array = [NSArray arrayWithObjects:dicBig, nil];
    [array writeToFile:filePaht atomically:NO];
    
    if (dicBig) {
        if (mlh_dataArray.count != 0) {
            [mlh_dataArray removeAllObjects];
        }
        for(NSDictionary *dic in [dicBig objectForKey:@"ad_list"]){
            firstModel *first = [[firstModel alloc]init];
            first.click_url = [dic objectForKey:@"click_url"];
            first.index_id = [dic objectForKey:@"click_info"];
            first.img_url = [dic objectForKey:@"img_url"];
            [mlh_dataArray addObject:first];
        }
    }
#endif
    dataArray = mlh_dataArray;

    [MyTableView reloadData];
     [SYObject endLoading];
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
        CGFloat h1 = 165+ ScreenFrame.size.width*150/320 -25;
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
#pragma mark -为了返回title跟价格而增加高度50
                if([[[first.line_info objectAtIndex:1]objectForKey:@"click_type"] isEqualToString:@"goods"]){
                    return ScreenFrame.size.width/2*hhh/www+1 +50;

                }else if([[[first.line_info objectAtIndex:1]objectForKey:@"click_type"] isEqualToString:@"goods_class"]){
                     return ScreenFrame.size.width/2*hhh/www+1;
                   
                }
                
                
                
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
    
    NSLog(@"==============%ld",(long)indexPath.row);
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
            
            NSMutableArray *urlsArray = [@[] mutableCopy];
            for (int i = 0; i < dataArray.count; ++i) {
                firstModel *first = [dataArray objectAtIndex:i];
                [urlsArray addObject:first.img_url];
            }
            
            
            __unsafe_unretained FirstViewController *blockself = self;

            NSLog(@"urlsArray==%@",urlsArray);
            //    // 代码创建
            TTLoopView *lpView = [TTLoopView LoopViewWithURLs:urlsArray titles:nil didSelected:^(NSInteger pageIndex) {
                NSLog(@"%zd",pageIndex);
                {
#pragma mark -循环广告点击方法
#pragma mark -循环广告点击方法
                    NSString *str=[NSString stringWithFormat:@"%ld",(long)pageIndex+1];
                    [blockself getIndexAdClick:str];
                    firstModel *first = [blockself->dataArray objectAtIndex:pageIndex];
                    
                    //                app://goods?id=3&name=hh
                    if ([first.click_url containsString:@"app://"]) {
#pragma mark ---
                        //id
                        NSString *IDID;
                        //type
                        NSString *type;
                        //name
                        NSString *name;
                        
                        NSString *s=first.click_url;
                        //                NSString *s=first.click_url;
                        NSArray *temparr=[s componentsSeparatedByString:@"://"];
                        if (![temparr.firstObject containsString:@"http"]) {
                            NSString *str=temparr[1];
                            
                            if ([str containsString:@"?"]) {
                                NSArray *arr=[str componentsSeparatedByString:@"?"];
                                type=arr[0];//获取goods
                                if ([arr[1] containsString:@"&"]) {//如果有多个参数,id=23&name=jjkk
                                    NSArray *jjjj=[arr[1] componentsSeparatedByString:@"&"];
                                    
                                    NSString * jj=  jjjj[0]; //id =23
                                    IDID=[jj  componentsSeparatedByString:@"="][1];
                                    
                                    NSString * jj2=  jjjj[1]; //name=jjkk
                                    name=[jj2  componentsSeparatedByString:@"="][1];
                                    
                                }
                                
                                else{
                                    NSString * jj=  arr[1]; //id =23
                                    IDID=[jj  componentsSeparatedByString:@"="][1];
                                }
                                
                                
                            }else{
                                //                            如果没有问号，则str就是type
                                type=str;
                            }
                        }
                        
                        //如果是goods
                        if([type isEqualToString:@"goods"]){
                            blockself->sec.detail_id = IDID;
                            DetailViewController *detail = [[DetailViewController alloc]init];
                            [blockself.navigationController pushViewController:detail animated:YES];
                        }else if([type isEqualToString:@"activity"]){
                            
                            getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
                            
                            all.classifyModel=[[ClassifyModel alloc]init];
                            all.classifyModel.coupon_name=name;
                            all.classifyModel.goods_id=IDID;
                            getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
                            get.hidesBottomBarWhenPushed=YES;
                            
                            [blockself.navigationController pushViewController:get animated:YES];
                            
                            
                        }else if ([type isEqualToString:@"cloudbuy"]){
                            
//                            if (IDID.length>0) {
//                                CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
//                                detail.ID = IDID;
//                                detail.hidesBottomBarWhenPushed=YES;
//                                
//                                [blockself.navigationController pushViewController:detail animated:YES];
//                            }else{
//                                OneYuanViewController *vc =[OneYuanViewController new] ;
//                                vc.hidesBottomBarWhenPushed=YES;
//                                
//                                [blockself.navigationController pushViewController:vc animated:YES];
//                                
//                                
//                            }
//                            
                            
                        }
                        
                    }else{//跳到网页的
                        NSLog(@"====%@",first.click_url);
#pragma mark -如果是空 的话就不让它点进去
                        if(first.click_url){
                            return ;
                        }
                        NotifWebViewController *notifVC = [[NotifWebViewController alloc]init];
                        
                        
                        NSString *urlStr = [NSString stringWithFormat:@"http://%@",first.click_url];
                        NSURL *url = [NSURL URLWithString:urlStr];
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        notifVC.request = request;
                        [blockself.navigationController pushViewController:notifVC animated:YES];
                    }
                    
                    
                    
                    
                }
                
            }];
            // 添加
            [cell addSubview:lpView];
            // 设置frame或约束
            lpView.frame =CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width*400/720) ;
                  }
        
        //8个按钮
        CGFloat scrollViewH = ScreenFrame.size.width * 400 / 720;
        CGFloat cell1Hx = 165+ ScreenFrame.size.width*150/320 + 27.8;
        CGFloat eW = ScreenFrame.size.width / 4.0;
        CGFloat eH = (cell1Hx - scrollViewH) / 2;
        NSArray *indexArrx = [self getRealArray];
        
        float maxY=0;
        for (int i=0; i<indexArrx.count; i++) {
            FirstIndexxCell *viewXYZ = indexArrx[i];
            CGFloat eX = (i % 4) * eW;
            CGFloat eY = (i / 4) * eH + scrollViewH;
            viewXYZ.frame = CGRectMake(eX, eY, eW, eH);
            [cell.contentView addSubview:viewXYZ];
            viewXYZ.delegate = self;
            maxY=eY+eH;
        }
        //重新请求网络图片
        [self setNetImages];
        
        
        
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, maxY+1, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
//        UIImageView *newsImg=[LJControl imageViewFrame:CGRectMake(10, maxY+4, 77, 20) setImage:@"todayNews.png" setbackgroundColor:nil];
//        newsImg.userInteractionEnabled=YES;
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, maxY, ScreenFrame.size.width, 30)];
        [cell  addSubview:bottomView];
        bottomView.backgroundColor=UIColorFromRGB(0xdddddd);
        
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 0, 70, 29)];
        headLabel.text=@"e网快报";
        headLabel.textColor=[UIColor redColor];
        headLabel.font=[UIFont systemFontOfSize:15];
        headLabel.textAlignment=NSTextAlignmentCenter;
        headLabel.userInteractionEnabled=YES;
        [bottomView addSubview:headLabel];
//        cell.backgroundColor=[UIColor grayColor];
        NSLog(@"maxY==%f",maxY);
       showScrollView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(80, 5, ScreenFrame.size.width-80-60-10, 20)];
        showScrollView.delegate = self;
//        showScrollView.layer.borderWidth = 1.0;  /*为了看的清楚加个边*/
//        showScrollView.layer.borderColor = [UIColor blackColor].CGColor;
//        [showScrollView animationWithTexts:[NSArray arrayWithObjects:@"这是第1条",@"这是第2条",@"这是第3条", nil]];
        if (_newsArr.count!=0) {//如果存在新闻
            __block  NSMutableArray *titleArr=[NSMutableArray array];

            [_newsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titleArr addObject:obj[@"title"]];
            }];
            
            [showScrollView animationWithTexts:titleArr];
            

        }
        
        UIView *gray=[LJControl viewFrame:CGRectMake(90, 5, 1, 21) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [bottomView addSubview:gray];
        [bottomView addSubview:showScrollView];
        
        
        UIButton *moreBut=[[UIButton alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-60,5, 50, 20)];
        [moreBut setTitle:@"更多>" forState:UIControlStateNormal];
        [moreBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        moreBut.titleLabel.font=[UIFont systemFontOfSize:15];

        [moreBut addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:moreBut];
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
                
#pragma mark -添加价格与title的cell
                templet_single_two_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"templet_single_two_Cell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"templet_single_two_Cell" owner:self options:nil] lastObject];
                }
                
                if([[[first.line_info objectAtIndex:1]objectForKey:@"click_type"] isEqualToString:@"goods"]){
//  修改约束的值

                    cell.leftImageBottom.constant=50;
                    cell.rightImageBottom.constant=50;

                }else {


                    cell.leftImageBottom.constant=0;
                    cell.rightImageBottom.constant=0;

//                    cell.contentView.backgroundColor=[UIColor yellowColor];
                }

                
                [cell.photoImageLeft sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:0]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                [cell.photoImageRight sd_setImageWithURL:[NSURL URLWithString:[[first.line_info objectAtIndex:1]objectForKey:@"img_url"]]  placeholderImage:[self grayImage]];
                
                cell.LeftBtn.tag = indexPath.section*100+indexPath.row*2;
                cell.RightBtn.tag = indexPath.section*100+indexPath.row*2+1;
                [cell.LeftBtn addTarget:self action:@selector(templet_singleTwoLeftAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.RightBtn addTarget:self action:@selector(templet_singleTwoLeftAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
//                如果click_type是goods，就显示他的价格
                if([[[first.line_info objectAtIndex:1]objectForKey:@"click_type"] isEqualToString:@"goods"]){
                    cell.leftTitle.text=[[first.line_info objectAtIndex:0]objectForKey:@"goods_name"];
                    
                    
                    cell.rightTitle.text=[[first.line_info objectAtIndex:1]objectForKey:@"goods_name"];
                    NSString *left=[[first.line_info objectAtIndex:0]objectForKey:@"goods_sales_price"];
                    NSLog(@"leftleft==%@",left);
                    cell.leftPrice.text=[NSString stringWithFormat:@"¥%@",left];
                    
                    NSString *right=[[first.line_info objectAtIndex:1]objectForKey:@"goods_sales_price"];

                    cell.rightPrice.text=[NSString stringWithFormat:@"¥%@",right];
                    

                }else{//防止复用
                    
                    cell.leftTitle.text=@"";
                    
                    cell.rightTitle.text=@"";
                    cell.leftPrice.text=@"";
                    
                    cell.rightPrice.text=@"";
                    
                }
                
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
        my.hidesBottomBarWhenPushed=YES;
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
