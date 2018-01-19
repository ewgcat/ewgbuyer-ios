//
//  ExchangeHomeViewController.m
//  My_App
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ExchangeHomeViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "ExchangeListViewController.h"
#import "writeViewController.h"
#import "IntegraDetialViewController.h"
#import "Model.h"
#import "IntegralCell.h"
#import "NewLoginViewController.h"
#import "MJRefresh.h"
#import "SignViewController.h"

#import "StandingsViewController.h"
#import "IntegralExchangeViewController.h"

@interface ExchangeHomeViewController ()<UIGestureRecognizerDelegate>
{
    ASIFormDataRequest *request101;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_7;
}

@end

static ExchangeHomeViewController *singleInstance = nil;

@implementation ExchangeHomeViewController


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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    filterIntrgralView.hidden = YES;
    NSString *rangBegin = @"";
    NSString *rangEnd = @"";
    if (filterTag == 1) {
        rangBegin = @"";
        rangEnd = @"";
    }else if (filterTag == 2){
        rangBegin = @"0";
        rangEnd = @"49";
    }else if (filterTag == 3){
        rangBegin = @"50";
        rangEnd = @"99";
    }else if (filterTag == 4){
        rangBegin = @"100";
        rangEnd = @"199";
    }else if (filterTag == 5){
        rangBegin = @"200";
        rangEnd = @"499";
    }else if (filterTag == 6){
        rangBegin = @"500";
        rangEnd = @"2147483647";
    }
    [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:rangBegin rang_end:rangEnd];
    
    [super viewWillAppear:YES];
//
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分商城";
    nothingView.hidden = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //设置layer
    dataArr = [[NSMutableArray alloc]init];
    filterIntrgralView.hidden = YES;
    filterBool = NO;
    
    dataArrShangla = [[NSMutableArray alloc]init];
    
    //初始化
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    //注册
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    
    //初始化collectionView
    integralCollectionView.collectionViewLayout = fl;
//    = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
    integralCollectionView.backgroundColor = [UIColor clearColor];
    [integralCollectionView registerClass:[IntegralCell class] forCellWithReuseIdentifier:@"IntegralCell"];
    integralCollectionView.delegate = self;
    integralCollectionView.dataSource = self;
    [self.view addSubview:integralCollectionView];
    [integralCollectionView addFooterWithTarget:self action:@selector(addFooter)];
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStyleDone target:self action:@selector(signAction)];
//    [self.navigationItem setRightBarButtonItem:leftButton animated:YES];
    filterTag = 1;
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}


- (void)addFooter
{
    NSString *rangBegin = @"";
    NSString *rangEnd = @"";
    if (filterTag == 1) {
        rangBegin = @"";
        rangEnd = @"";
    }else if (filterTag == 2){
        rangBegin = @"0";
        rangEnd = @"49";
    }else if (filterTag == 3){
        rangBegin = @"50";
        rangEnd = @"99";
    }else if (filterTag == 4){
        rangBegin = @"100";
        rangEnd = @"199";
    }else if (filterTag == 5){
        rangBegin = @"200";
        rangEnd = @"499";
    }else if (filterTag == 6){
        rangBegin = @"500";
        rangEnd = @"2147483647";
    }
    [self netWorking_Refresh_beginCount:[NSString stringWithFormat:@"%lu",(unsigned long)dataArr.count] selectCount:@"10" rang_begin:rangBegin rang_end:rangEnd];
    NSLog(@"%@",dataArr);
}
#pragma mark  - collection
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (dataArr.count != 0) {
        return dataArr.count;
    }
    return 0;
}
//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntegralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntegralCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil] lastObject];
    }
    if (dataArr.count != 0) {
        Model *shjm = [dataArr objectAtIndex:indexPath.row];
        [cell setData:shjm];
    }
    
    return cell;
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,0,0,0};
    return top;
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenFrame.size.width,116);
}
//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Model *shjm = [dataArr objectAtIndex:indexPath.row];
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    exc.ig_id = shjm.ig_id;
    IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
    [self.navigationController pushViewController:integraDetialVC animated:YES];
}

#pragma mark  - 点击事件
-(void)signAction{
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        SignViewController *sign = [[SignViewController alloc]init];
        [self.navigationController pushViewController:sign animated:YES];
    }
    
}
- (IBAction)filterBtnAction:(id)sender {
    if (filterBool == NO) {
        filterIntrgralView.hidden = NO;
        filterBool = YES;
    }else{
        filterIntrgralView.hidden = YES;
        filterBool = NO;
    }
}

#pragma mark - 网络
-(void)netWorking_Refresh_beginCount:(NSString *)begin selectCount:(NSString *)select rang_begin:(NSString *)rang_begin rang_end:(NSString *)rang_end{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"begincount",@"selectcount",@"rang_begin",@"rang_end", nil];
    NSArray *valueArr;
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
        valueArr = [[NSArray alloc]initWithObjects:@"",@"",begin,select,rang_begin,rang_end, nil];
    }else{
        valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],begin,select,rang_begin,rang_end, nil];
    }
    request_7 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALLIST_URL] setKey:keyArr setValue:valueArr];
    
    request_7.delegate = self;
    [request_7 setDidFailSelector:@selector(RequestFailed:)];
    [request_7 setDidFinishSelector:@selector(RefreshRequestSucceeded:)];
    [request_7 startAsynchronous];
}
-(void)RefreshRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"123exchange_dibBig-->>%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
                NSArray *array = [dicBig objectForKey:@"recommend_igs"];
                if (dataArrShangla.count != 0) {
                    [dataArrShangla removeAllObjects];
                }
                for (NSDictionary *dic in array) {
                    Model *shjm = [[Model alloc]init];
                    shjm.ig_goods_img = [dic objectForKey:@"ig_goods_img"];
                    shjm.ig_goods_integral = [dic objectForKey:@"ig_goods_integral"];
                    shjm.ig_goods_name = [dic objectForKey:@"ig_goods_name"];
                    shjm.ig_id = [dic objectForKey:@"ig_id"];
                    shjm.ig_user_level = [dic objectForKey:@"ig_user_level"];
                    
                    shjm.igc_count=[dic objectForKey:@"ig_goods_count"];
                    shjm.ig_goods_pay_price=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"ig_goods_pay_price"]]; ;

                    [dataArrShangla addObject:shjm];
                }
                [dataArr addObjectsFromArray:dataArrShangla];
                
            }else{
                [SYObject failedPrompt:@"登录已过期,请重新登录" complete:^{
                    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                    [self.navigationController pushViewController:new animated:YES];
                }];
                
            }
            [integralCollectionView reloadData];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [integralCollectionView reloadData];
        // 结束刷新
        [integralCollectionView footerEndRefreshing];
    });
}
-(void)netWorking_beginCount:(NSString *)begin selectCount:(NSString *)select rang_begin:(NSString *)rang_begin rang_end:(NSString *)rang_end{
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"begincount",@"selectcount",@"rang_begin",@"rang_end", nil];
    NSArray *valueArr;
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
        valueArr = [[NSArray alloc]initWithObjects:@"",@"",begin,select,rang_begin,rang_end, nil];
    }else{
        valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],begin,select,rang_begin,rang_end, nil];
    }
    request_8 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALLIST_URL] setKey:keyArr setValue:valueArr];
//    NSMutableDictionary *par=[[NSMutableDictionary alloc]initWithObjects:valueArr forKeys:keyArr];
    
    request_8.delegate = self;
    [request_8 setDidFailSelector:@selector(RequestFailed:)];
    [request_8 setDidFinishSelector:@selector(GetuserMsgSucceeded:)];
    [request_8 startAsynchronous];
//    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALLIST_URL] ;
//    
//    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
//    }];
}
-(void)GetuserMsgSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        [dataArr removeAllObjects];
        dataArr = [[consultViewNetwork dataIntegralRecommendData:request] objectAtIndex:1];
        
        myIntegral= [NSString stringWithFormat:@"%@",[[[consultViewNetwork dataIntegralRecommendData:request] objectAtIndex:0] objectForKey:@"integral"]];
        NSLog(@"====:%@",[NSString stringWithFormat:@"%@",[[[consultViewNetwork dataIntegralRecommendData:request] objectAtIndex:0] objectForKey:@"integral"]]);
        if (dataArr.count == 0) {
            nothingView.hidden = NO;
        }else {
            nothingView.hidden = YES;
        }
        [integralCollectionView reloadData];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    
}


-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"information.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
        }else{
            NewLoginViewController *new = [[NewLoginViewController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.cart_ids=@"";
        th.cart_meideng = @"";
        th.jiesuan.text = @"";
        th.zongji.text = @"0.00";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)filterIntegralAction:(id)sender {
    [integralCollectionView setContentOffset:CGPointMake(0,0) animated:YES];
    UIButton *btn = (UIButton *)sender;
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    filterIntrgralView.hidden = YES;
    filterBool = NO;
    if (btn.tag == 101) {
        filterTag = 1;
        FilterAllLabel.textColor = [UIColor redColor];
        Filter1999.textColor = [UIColor darkGrayColor];
        Filter2000.textColor = [UIColor darkGrayColor];
        Filter4000.textColor = [UIColor darkGrayColor];
        Filter6000.textColor = [UIColor darkGrayColor];
        Filter10000.textColor = [UIColor darkGrayColor];
        filterIntegralLabel.text = @"全部";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"" rang_end:@""];
    }
    if (btn.tag == 102) {
        filterTag = 2;
        FilterAllLabel.textColor = [UIColor darkGrayColor];
        Filter1999.textColor = [UIColor redColor];
        Filter2000.textColor = [UIColor darkGrayColor];
        Filter4000.textColor = [UIColor darkGrayColor];
        Filter6000.textColor = [UIColor darkGrayColor];
        Filter10000.textColor = [UIColor darkGrayColor];
        filterIntegralLabel.text = @"50以下";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"0" rang_end:@"49"];
    }
    if (btn.tag == 103) {
        filterTag = 3;
        FilterAllLabel.textColor = [UIColor darkGrayColor];
        Filter1999.textColor = [UIColor darkGrayColor];
        Filter2000.textColor = [UIColor redColor];
        Filter4000.textColor = [UIColor darkGrayColor];
        Filter6000.textColor = [UIColor darkGrayColor];
        Filter10000.textColor = [UIColor darkGrayColor];
        filterIntegralLabel.text = @"50~99";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"50" rang_end:@"99"];
    }
    if (btn.tag == 104) {
        filterTag = 4;
        FilterAllLabel.textColor = [UIColor darkGrayColor];
        Filter1999.textColor = [UIColor darkGrayColor];
        Filter2000.textColor = [UIColor darkGrayColor];
        Filter4000.textColor = [UIColor redColor];
        Filter6000.textColor = [UIColor darkGrayColor];
        Filter10000.textColor = [UIColor darkGrayColor];
        filterIntegralLabel.text = @"100~199";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"100" rang_end:@"199"];
    }
    if (btn.tag == 105) {
        filterTag = 5;
        FilterAllLabel.textColor = [UIColor darkGrayColor];
        Filter1999.textColor = [UIColor darkGrayColor];
        Filter2000.textColor = [UIColor darkGrayColor];
        Filter4000.textColor = [UIColor darkGrayColor];
        Filter6000.textColor = [UIColor redColor];
        Filter10000.textColor = [UIColor darkGrayColor];
        filterIntegralLabel.text = @"200~499";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"200" rang_end:@"499"];
    }
    if (btn.tag == 106) {
        filterTag = 6;
        FilterAllLabel.textColor = [UIColor darkGrayColor];
        Filter1999.textColor = [UIColor darkGrayColor];
        Filter2000.textColor = [UIColor darkGrayColor];
        Filter4000.textColor = [UIColor darkGrayColor];
        Filter6000.textColor = [UIColor darkGrayColor];
        Filter10000.textColor = [UIColor redColor];
        filterIntegralLabel.text = @"500分以上";
        [self netWorking_beginCount:@"0" selectCount:@"10" rang_begin:@"500" rang_end:@"2147483647"];
    }
}
- (IBAction)standingsViewController:(id)sender {
    StandingsViewController *svc=[[StandingsViewController alloc]init];
    svc.myIntegral=myIntegral;
    svc.fty=@"1";
    [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)exchangeRecordAction:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    IntegralExchangeViewController *ievc = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];
    [self.navigationController pushViewController:ievc animated:YES];
}
@end
