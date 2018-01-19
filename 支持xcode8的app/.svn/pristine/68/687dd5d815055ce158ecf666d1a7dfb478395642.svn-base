//
//  PhysicalOrderViewController.m
//  My_App
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PhysicalOrderViewController2.h"
#import "ASIFormDataRequest.h"
#import "orderCell.h"
#import "Model.h"
#import "OrderDetailsViewController2.h"
#import "ThirdViewController.h"
#import "EnsureestimateViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "FirstViewController.h"


@interface PhysicalOrderViewController2 ()

@end

@implementation PhysicalOrderViewController2

static PhysicalOrderViewController2 *singleInstance=nil;


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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestPhysicalOrder1 clearDelegatesAndCancel];
    [requestPhysicalOrder2 clearDelegatesAndCancel];
    [requestPhysicalOrder4 clearDelegatesAndCancel];
    [requestPhysicalOrder5 clearDelegatesAndCancel];
    [requestPhysicalOrder13 clearDelegatesAndCancel];
    [MyTableView setEditing:NO];
}
-(void)netWork{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL]];
    requestPhysicalOrder13 = [ASIFormDataRequest requestWithURL:url];
    
    [requestPhysicalOrder13 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestPhysicalOrder13 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestPhysicalOrder13 setPostValue:@"0" forKey:@"order_cat"];
    [requestPhysicalOrder13 setPostValue:@"0" forKey:@"beginCount"];
    [requestPhysicalOrder13 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestPhysicalOrder13 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestPhysicalOrder13.tag = 303;
    [requestPhysicalOrder13 setDelegate:self];
    [requestPhysicalOrder13 setDidFailSelector:@selector(my303_urlRequestFailed:)];
    [requestPhysicalOrder13 setDidFinishSelector:@selector(my303_urlRequestSucceeded:)];
    [requestPhysicalOrder13 startAsynchronous];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    [SYObject startLoading];
    [self netWork];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    
    requestBool = NO;
    
    _popBool = NO;
    dataArray = [[NSMutableArray alloc]init];
    dataArrShangla = [[NSMutableArray alloc]init];
    [SYObject startLoading];
    
    self.title = @"商品订单";
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    MyTableView.showsVerticalScrollIndicator= NO;
    MyTableView.backgroundColor =[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    MyTableView.showsHorizontalScrollIndicator = NO;
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    muchBool = NO;
    muchView.hidden = YES;
    [muchGray.layer setMasksToBounds:YES];
    [muchGray.layer setCornerRadius:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-页面相关创建
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    self.navigationItem.rightBarButtonItem =bar3;
}
-(void)More{
    if (muchBool == NO) {
        muchView.hidden = NO;
        muchBool = YES;
    }else{
        muchView.hidden = YES;
        muchBool = NO;
    }
}

#pragma mark-scrollView 添加
-(void)setupPage:(id)sender{
    myScrollView.canCancelContentTouches = YES;
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    myScrollView.clipsToBounds = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.directionalLockEnabled = NO;
    myScrollView.alwaysBounceHorizontal = NO;
}
#pragma mark-tableView方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source.
        NSLog(@"要删除啦~~~~~");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        return 180;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"orderCell";
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"orderCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    }
    if (dataArray.count != 0) {
        Model *shjM = [dataArray objectAtIndex:indexPath.row];
        cell.order_id.text = [NSString stringWithFormat:@"订单号:%@",shjM.order_num];
        
        NSArray *arr = (NSArray*)shjM.order_photo_list;
        NSArray *name_Array = (NSArray*)shjM.order_name_list;
        if (arr.count ==0) {
        }else if (arr.count==1){
            cell.muchView.hidden = YES;
            for(int i=0;i<arr.count;i++){
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                cell.nameLabel.text = [name_Array objectAtIndex:i];
            }
        }else{
            cell.muchView.hidden = NO;
            cell.scrollView.tag = 102;
            cell.scrollView.bounces = YES;
            cell.scrollView.delegate = self;
            cell.scrollView.userInteractionEnabled = YES;
            cell.scrollView.showsHorizontalScrollIndicator = NO;
            cell.scrollView.contentSize=CGSizeMake(65*arr.count+15,65);
            for(int i=0;i<arr.count;i++){
                UIImageView *imgTrademark = [[UIImageView alloc]initWithFrame:[SYObject orderCellImgFrameAtIndex:i]];
                imgTrademark.userInteractionEnabled = YES;
                [imgTrademark sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                [cell.scrollView addSubview:imgTrademark];
            }
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"商品金额:￥%@",shjM.order_total_price];
        
        if ([shjM.order_status intValue]==10) {
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待付款";
            [cell.btn setTitle:@"立即支付" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+200;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==30){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待收货";
            [cell.btn setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+400;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==20){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"待发货";
        }else if([shjM.order_status intValue]==16){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"待发货";//详情 货到付款
        }else if([shjM.order_status intValue]==0){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"订单已取消";
        }else if([shjM.order_status intValue]==50){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"订单已完成";
        }else if([shjM.order_status intValue]==40){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待评价";
            [cell.btn setTitle:@"立即评价" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+600;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==65){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"不可评价";
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *mode = [dataArray objectAtIndex:indexPath.row];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.select_order_id = [NSString stringWithFormat:@"%@",mode.order_id];
    
    OrderDetailsViewController2 *or = [[OrderDetailsViewController2 alloc]init];
    [self.navigationController pushViewController:or animated:YES];
}
#pragma mark-支付宝
- (NSString *)generateTradeNO
{
    const int N = 15;
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand((int)time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    ThirdViewController *th = [[ThirdViewController alloc]init];
    result= (NSMutableString*)[NSString stringWithFormat:@"order-%@-%@-goods",result,th.ding_hao]; //订单ID（由商家自行制定）
    th.strout_trade_no = result;
    return result;
}
-(void)paymentResult:(NSString *)result{
    NSLog(@"reesu:%@",result);
}
#pragma mark-点击事件
-(void)backBtnClicked{
    [requestPhysicalOrder13 cancel];
    [requestPhysicalOrder1 cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClicked:(UIButton *)btn{
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag == i+200){
            Model *shi = [dataArray objectAtIndex:btn.tag-200];
            third.ding_hao = [NSString stringWithFormat:@"%@",shi.order_num];
            third.ding_order_id = [NSString stringWithFormat:@"%@",shi.order_id];
            third.jie_order_goods_price = [NSString stringWithFormat:@"%@",shi.order_total_price];
            
            //这里应该跳转进入选择页面
            OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
            [self.navigationController pushViewController:on animated:YES];
        }
    }
    //确认收货按钮
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag == i+400) {
            querenshouhuo = btn.tag;
            [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要收货吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    //发起确认收货的请求
                    for(int i=0;i<dataArray.count;i++){
                        if (querenshouhuo-400==i) {
                            Model *shi = [dataArray objectAtIndex:querenshouhuo-400];
                            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            NSString *documentsPath = [docPath objectAtIndex:0];
                            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                            [SYObject startLoading];
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL]];
                            requestPhysicalOrder1 = [ASIFormDataRequest requestWithURL:url];
                            
                            [requestPhysicalOrder1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                            [requestPhysicalOrder1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                            [requestPhysicalOrder1 setPostValue:shi.order_id forKey:@"order_id"];
                            
                            [requestPhysicalOrder1 setRequestHeaders:[LJControl requestHeaderDictionary]];
                            requestPhysicalOrder1.tag = 101;
                            [requestPhysicalOrder1 setDelegate:self];
                            [requestPhysicalOrder1 setDidFailSelector:@selector(urlRequestFailed:)];
                            [requestPhysicalOrder1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
                            [requestPhysicalOrder1 startAsynchronous];
                        }
                    }
                }else if (buttonIndex == 1){
                }

            }];
        }
    }
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag == i+600){
            Model *shi = [dataArray objectAtIndex:btn.tag-600];
            third.ding_order_id = shi.order_id;
            EnsureestimateViewController *ensure = [[EnsureestimateViewController alloc]init];
            [self.navigationController pushViewController:ensure animated:YES];
        }
    }
}
-(void)rightBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    NSLog(@"statuscode2:%d",statuscode2);
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"确认收货:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            //刷新页面
            [self netWork];
        }
    }else{
        [self failedPrompt:@"操作失败，请重试"];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    promptView.hidden = NO;
    [self failedPrompt:@"网络请求失败"];
}
-(void)my303_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单1:%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArray addObject:shjM];
        }
    }
    if (dataArray.count ==0) {
        
        MyTableView.hidden = YES;
        promptView.hidden = NO;
    }else{
        
        MyTableView.hidden = NO;
        promptView.hidden = YES;
    }
    [SYObject endLoading];
    [MyTableView reloadData];
}
-(void)my303_urlRequestFailed:(ASIFormDataRequest *)request{
    promptView.hidden = NO;
    [self failedPrompt:@"网络请求失败"];
}

-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            //发起确认收货的请求
            for(int i=0;i<dataArray.count;i++){
                if (querenshouhuo-400==i) {
                    Model *shi = [dataArray objectAtIndex:querenshouhuo-400];
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    [SYObject startLoading];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL]];
                    requestPhysicalOrder1 = [ASIFormDataRequest requestWithURL:url];
                    
                    [requestPhysicalOrder1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [requestPhysicalOrder1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [requestPhysicalOrder1 setPostValue:shi.order_id forKey:@"order_id"];
                    
                    [requestPhysicalOrder1 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    requestPhysicalOrder1.tag = 101;
                    [requestPhysicalOrder1 setDelegate:self];
                    [requestPhysicalOrder1 setDidFailSelector:@selector(urlRequestFailed:)];
                    [requestPhysicalOrder1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
                    [requestPhysicalOrder1 startAsynchronous];
                }
            }
        }else if (buttonIndex == 1){
        }
    }
}



-(void)my105_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单2:%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArrShangla.count!=0) {
            [dataArrShangla removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArrShangla addObject:shjM];
        }
    }
    requestBool = YES;
    [dataArray addObjectsFromArray:dataArrShangla];
    [MyTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)my105_urlRequestFailed:(ASIFormDataRequest *)request{
    promptView.hidden = NO;
    [self failedPrompt:@"网络请求失败"];
}
#pragma mark - 上拉刷新
-(void)footerRereshing{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL]];
    requestPhysicalOrder5 = [ASIFormDataRequest requestWithURL:url];
    
    [requestPhysicalOrder5 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestPhysicalOrder5 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestPhysicalOrder5 setPostValue:@"0" forKey:@"order_cat"];
    [requestPhysicalOrder5 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"beginCount"];
    [requestPhysicalOrder5 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestPhysicalOrder5 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestPhysicalOrder5.tag = 105;
    [requestPhysicalOrder5 setDelegate:self];
    [requestPhysicalOrder5 setDidFailSelector:@selector(my105_urlRequestFailed:)];
    [requestPhysicalOrder5 setDidFinishSelector:@selector(my105_urlRequestSucceeded:)];
    [requestPhysicalOrder5 startAsynchronous];
}

- (IBAction)tabbarBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIButton *btn = (UIButton *)sender;
    FirstViewController *first = [FirstViewController sharedUserDefault];
    
    if (btn.tag == 101) {
        [first tabbarIndex:0];
    }else if (btn.tag == 102) {
        [first tabbarIndex:1];
    }else if (btn.tag == 103) {
        [first tabbarIndex:2];
    }else if (btn.tag == 104) {
        [first tabbarIndex:3];
    }else{
        [first tabbarIndex:4];
    }
}
@end
