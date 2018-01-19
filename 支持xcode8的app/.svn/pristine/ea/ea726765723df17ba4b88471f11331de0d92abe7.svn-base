//
//  FreeCouponsViewController.m
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FreeCouponsViewController.h"
#import "FreeCouponsCell.h"
#import "RemainderCouponsListCell.h"
#import "ReceiveCouponsViewController.h"


@interface FreeCouponsViewController ()<UIGestureRecognizerDelegate>
{
    ASIFormDataRequest *RequestStoreCouponsList;
}

@end

static FreeCouponsViewController *singleInstance=nil;

@implementation FreeCouponsViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.title = @"免费领券";
    [self createBackBtn];
    
    //tableview代理
    CouponsTableView.delegate = self;
    CouponsTableView.dataSource = self;
    dataArray = [[NSMutableArray alloc]init];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
//重写返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [SYObject startLoading];
    [self netWorking];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [RequestStoreCouponsList clearDelegatesAndCancel];
}

#pragma mark - 网络
-(void)netWorking{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"store_id",@"type", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],@"",@"all", nil];
    RequestStoreCouponsList = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_COUPONS_URL] setKey:keyArr setValue:valueArr];
    
    RequestStoreCouponsList.delegate = self;
    [RequestStoreCouponsList setDidFailSelector:@selector(RequestFailed:)];
    [RequestStoreCouponsList setDidFinishSelector:@selector(RequestStoreCouponsListSucceeded:)];
    [RequestStoreCouponsList startAsynchronous];
}
-(void)RequestStoreCouponsListSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataStore_CouponsListData:request];
//        LoadingView.hidden = YES;
        [SYObject endLoading];
        [CouponsTableView reloadData];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
//-(void)failedPrompt:(NSString *)prompt{
////    LoadingView.hidden = YES;
//    [SYObject endLoading];
//    PromptLabel.hidden = NO;
//    PromptLabel.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//}
-(void)TimeOutdoTimer{
    
}
#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count != 0) {
        return dataArray.count+1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 117;
    }else{
        return 175;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataArray.count!=0) {
        if (indexPath.row == 0) {
            FreeCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeCouponsCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FreeCouponsCell" owner:self options:nil] lastObject];
            }
            return cell;
        }else{
            RemainderCouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainderCouponsListCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RemainderCouponsListCell" owner:self options:nil] lastObject];
            }
            ClassifyModel *class = [dataArray objectAtIndex:indexPath.row-1];
            [cell setData:class];
            
            return cell;
        }
    }else{
        FreeCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeCouponsCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FreeCouponsCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataArray.count!=0) {
        if (indexPath.row != 0) {
            ClassifyModel *class = [dataArray objectAtIndex:indexPath.row-1];
            if ([class.coupon_status intValue] == 0) {
                _ReceiveModel = class;
                ReceiveCouponsViewController *receive = [[ReceiveCouponsViewController alloc]init];
                [self.navigationController pushViewController:receive animated:YES];
            }
        }
    }
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
