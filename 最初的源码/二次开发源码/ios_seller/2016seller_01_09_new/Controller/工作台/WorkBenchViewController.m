//
//  WorkBenchViewController.m
//  SellerApp
//
//  Created by apple on 15/4/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WorkBenchViewController.h"
#import "OrderlistViewController.h"
#import "GoodsViewController.h"
#import "MyOrderViewController.h"
#import "shipmanageViewController.h"
#import "myAfnetwork.h"
#import "myselfParse.h"
#import "AppDelegate.h"
#import "TodayOrderlistViewController.h"
#import "workbenchCell.h"
#import "sqlService.h"


@interface WorkBenchViewController ()
{
    myselfParse * _myParse;
    NSString * store_name;
    NSString * user_name;
    NSString * label_Count;
    NSString * label_Send;
    NSString * label_noestimate;
    NSString * label_money;
    NSString * label_ensure;
    NSString * label_overestimate;
    NSString * store_logo;
}

@end

static WorkBenchViewController *singleInstance=nil;

@implementation WorkBenchViewController

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


-(void)viewWillAppear:(BOOL)animated{
    [self getNetWorking];
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self netExist];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    myTableview.delegate = self;
    myTableview.dataSource=  self;
    myTableview.showsVerticalScrollIndicator=NO;
    myTableview.showsHorizontalScrollIndicator = NO;
    
    [refreshButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    refreshButton.layer.borderWidth = 0.5;
    refreshButton.layer.borderColor = [[UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1] CGColor];
    refreshButton.layer.masksToBounds = YES;
    refreshButton.layer.cornerRadius = 8.0;
    
    grayView.layer.masksToBounds = YES;
    grayView.layer.cornerRadius = 4.0;
    
    [refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    refreshV.hidden = YES;
    
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4];
    label_prompt.hidden = YES;
}

//跳转
-(void)TodayClicked{
    TodayOrderlistViewController *today = [[TodayOrderlistViewController alloc]init];
    [self.navigationController pushViewController:today animated:YES];
}
- (void)getNetWorking
{
    loadingV.hidden = NO;
    NSArray *fileContent = USER_INFORMATION;
    NSString * url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_URL,[fileContent objectAtIndex:2],[fileContent objectAtIndex:0]];
    
    [myAfnetwork url:url verify:[fileContent objectAtIndex:3] getChat:^(myselfParse * myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        NSDictionary * dicBig = _myParse.dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }
            else
            {
                _PhotoStr = [dicBig objectForKey:@"store_logo"];
                user_name = [dicBig objectForKey:@"username"];
                store_name = [dicBig objectForKey:@"store_name"];
                store_logo  = [dicBig objectForKey:@"store_logo"];
                label_Count = [NSString stringWithFormat:@"%d",[[dicBig objectForKey:@"order_today"]intValue]];
                label_Send = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_to_ship"]];
                label_noestimate = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_confirmed"]];
                label_money = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_to_pay"]];
                label_ensure = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_to_confirm"]];
                label_overestimate = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_finished"]];
                [myTableview reloadData];
            }
        }
    } failure:^(){
        myTableview.hidden = YES;
        loadingV.hidden = YES;
    }];
}

- (void)doTimer_signout
{
    label_prompt.hidden = YES;
    [LJControl cleanAll];
    AppDelegate * app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
- (void)doTimer
{
    label_prompt.hidden = YES;
}

//订单管理 点击事件
- (void)orderManagementClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        _selectTag = 2;
    }else if (btn.tag == 102){
        _selectTag = 5;
    }else if (btn.tag == 103){
        _selectTag = 1;
    }else if (btn.tag == 104){
        _selectTag = 3;
    }else if (btn.tag == 105){
        _selectTag = 0;
    }
    OrderlistViewController * orderlistVC = [OrderlistViewController new];
    [self.navigationController pushViewController:orderlistVC animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//商品管理 点击事件
- (void)goodsManagementClicked{
    GoodsViewController * goodsVC = [GoodsViewController new];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

//店铺账单 点击事件
- (void)shopManagementClicked{
    MyOrderViewController * myOrderVC = [MyOrderViewController new];
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

//发货设置 点击事件
- (void)dispatchClicked{
    shipmanageViewController * shipManagementVC = [shipmanageViewController new];
    [self.navigationController pushViewController:shipManagementVC animated:YES];
}

- (void)refreshButtonClicked
{
    [self getNetWorking];
    loadingV.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 判断网络
- (void)netExist
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%d", (int)status);
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                myTableview.hidden = YES;
                refreshV.hidden = NO;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"蜂窝网络");
                break;
            }
            default:
                break;
        }
    }];
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 470;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    workbenchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workbenchCell"];
    cell.username.text = user_name;
    cell.storeName.text = store_name;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:store_logo] placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.todayCountLabel.text = [NSString stringWithFormat:@"%d",[label_Count intValue]];
    cell.waitSendCountLabel.text = [NSString stringWithFormat:@"%@",label_Send];
    cell.waitestimateCountLabel.text = [NSString stringWithFormat:@"%@",label_noestimate];
    cell.waitMoneyCountLabel.text = [NSString stringWithFormat:@"%@",label_money];
    cell.waitsureCountLabel.text = [NSString stringWithFormat:@"%@",label_ensure];
    cell.overCountLabel.text = [NSString stringWithFormat:@"%@",label_overestimate];
    
    [cell.todayBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    [cell.waitSendBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.waitEstimateBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.waitMoneyBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.waitSureBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.overBtn addTarget:self action:@selector(orderManagementClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
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
