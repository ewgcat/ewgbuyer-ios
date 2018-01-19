//
//  IntegralOrderDetail2ViewController.m
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "IntegralOrderDetail2ViewController.h"
#import "ASIFormDataRequest.h"
#import "IntegralDetailCell.h"
#import "goodsCell.h"
#import "LoginViewController.h"
#import "ExchangeHomeViewController.h"
#import "IntegraDetialViewController.h"
#import "ThirdViewController.h"
#import "onlinePayTypesIntegralViewController.h"
#import "Model.h"

@interface IntegralOrderDetail2ViewController ()

@end

@implementation IntegralOrderDetail2ViewController

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(MyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    
    buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonCancel.frame =CGRectMake(0, 0, 50, 30);
    [buttonCancel setTitle:@"取消订单" forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(BtnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    buttonCancel.titleLabel.font  = [UIFont boldSystemFontOfSize:12];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonCancel];
    self.navigationItem.rightBarButtonItem =bar2;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [SYObject startLoading];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERDETAIL_URL]];
    request_2=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_2 setPostValue:log.return_oid forKey:@"oid"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 101;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_3 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackBtn];
    self.title = @"订单详情";
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc]init];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [self.view addSubview:MyTableView];
    nothingView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        return 1+class.goods_groupinfos.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        if (indexPath.row == 0) {
            return 355;
        }else{
            return 100;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *myTabelviewCell = @"IntegralDetailCell";
        IntegralDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralDetailCell" owner:self options:nil] lastObject];
        }
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            cell.order_status.text = [NSString stringWithFormat:@"    订单状态: %@",class.goods_sudu];
            cell.order_num.text = [NSString stringWithFormat:@"    订单号: %@",class.dingdetail_order_id];
            cell.integralScore.text = [NSString stringWithFormat:@"    兑换积分: %@",class.goods_total_price];
            cell.shipprice.text = [NSString stringWithFormat:@"    运费: %@",class.dingdetail_ship_price];
            cell.payType.text = [NSString stringWithFormat:@"%@",class.dingdetail_order_pay_msg];
            cell.name.text = [NSString stringWithFormat:@"👤:%@",class.goods_receiver_name];
            cell.phone.text = [NSString stringWithFormat:@"📞:%@",class.goods_receiver_mobile];
            cell.address.text = [NSString stringWithFormat:@"%@",class.goods_receiver_address];
            if ([class.goods_status intValue] == 0) {//说明此时是未支付转台呢
                cell.btn.hidden = NO;
                [cell.btn setTitle:@"去支付" forState:UIControlStateNormal];
                [cell.btn addTarget:self action:@selector(btnPayClicked) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.btn.hidden = YES;
            }
            return cell;
        }
    }else{
        static NSString *myTabelviewCell = @"goodsCell";
        goodsCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsCell" owner:self options:nil] lastObject];
        }
        ClassifyModel *class = [dataArray objectAtIndex:0];
        if (class.goods_groupinfos.count!=0) {
            [cell.goodImage sd_setImageWithURL:(NSURL*)[[class.goods_groupinfos objectAtIndex:indexPath.row-1] objectForKey:@"goods_img"]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            cell.count.text = [NSString stringWithFormat:@"数量: %@",[[class.goods_groupinfos objectAtIndex:indexPath.row-1] objectForKey:@"goods_count"]];
            cell.name.text = [[class.goods_groupinfos objectAtIndex:indexPath.row-1] objectForKey:@"goods_name"];
            cell.spec.text = @"";
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
#pragma mark - 点击事件
-(void)refresh{
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERDETAIL_URL]];
    request_3=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request_3 setPostValue:log.return_oid forKey:@"oid"];
    
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.tag = 101;
    request_3.delegate = self;
    [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
    
}
-(void)BtnCancelClicked{
    [OHAlertView showAlertWithTitle:@"系统提示" message:@"您要取消该订单？"   cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 0){
            ClassifyModel *class = [dataArray objectAtIndex:0];
            //发起删除的请求
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERCANCEL_URL]];
            request_1=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_1 setPostValue:class.goods_oid forKey:@"oid"];
            
            [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_1.tag = 101;
            request_1.delegate = self;
            [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request_1 startAsynchronous];
        }else{
        }

    
    }];
}
-(void)MyBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnGoodsClicked:(UIButton *)btn{
    if(dataArray.count!=0){
        ClassifyModel *class = [dataArray objectAtIndex:0];
        ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
        exc.ig_id = [[class.goods_groupinfos objectAtIndex:btn.tag-100] objectForKey:@"id"];
        IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
        [self.navigationController pushViewController:integraDetialVC animated:YES];
    }
}
-(void)btnPayClicked{
    ClassifyModel *class = [dataArray objectAtIndex:0];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.ding_hao = [NSString stringWithFormat:@"%@",class.goods_oid];
    th.ding_order_id = [NSString stringWithFormat:@"%@",class.dingdetail_order_id];
    th.jie_order_goods_price = [NSString stringWithFormat:@"%@",class.dingdetail_ship_price];
    onlinePayTypesIntegralViewController *UUU = [[onlinePayTypesIntegralViewController alloc]init];
    [self.navigationController pushViewController:UUU animated:YES];
}
#pragma mark - 支付宝
-(void)paymentResult:(NSString *)result{
    NSLog(@"result:%@",result);
}
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
    result= (NSMutableString*)[NSString stringWithFormat:@"order-%@-%@-goods",result,th.ding_order_id]; //订单ID（由商家自行制定）
    th.strout_trade_no = result;
    return result;
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            buttonCancel.hidden = YES;
            [self refresh];
            [self failedPrompt:@"已成功取消订单"];
        }else{
            [self failedPrompt:@"取消订单失败"];
        }
    }
    else{
        [self failedPrompt:@"请求出错"];
        nothingView.hidden = NO;
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        ClassifyModel *class = [[ClassifyModel alloc]init];
        class.goods_addTime = [dicBig objectForKey:@"addTime"];
        class.goods_groupinfos = [dicBig objectForKey:@"goods_list"];
        class.goods_status = [dicBig objectForKey:@"igo_status"];
        if([[dicBig objectForKey:@"igo_status"] intValue]==0){
            buttonCancel.hidden = NO;
        }else{
            buttonCancel.hidden = YES;
        }
        class.goods_sudu = [dicBig objectForKey:@"status_msg"];
        class.goods_oid = [dicBig objectForKey:@"oid"];
        class.dingdetail_order_id = [dicBig objectForKey:@"order_id"];
        class.goods_total_price = [dicBig objectForKey:@"order_total_price"];
        class.dingdetail_order_pay_msg =[dicBig objectForKey:@"payType"];
        class.dingdetail_ship_price =[dicBig objectForKey:@"ship_price"];
        class.goods_receiver_address =[dicBig objectForKey:@"receiver_address"];
        if([NSString stringWithFormat:@"%@",[dicBig objectForKey:@"receiver_mobile"]].length != 0 ){
            class.goods_receiver_mobile =[dicBig objectForKey:@"receiver_mobile"];
        }else{
            class.goods_receiver_mobile =[dicBig objectForKey:@"receiver_tel"];
        }
        class.goods_receiver_name =[dicBig objectForKey:@"receiver_name"];
        class.goods_pay_time =[dicBig objectForKey:@"pay_time"];
        [dataArray addObject:class];
        
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"积分订单详情：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        
        ClassifyModel *class = [[ClassifyModel alloc]init];
        class.goods_addTime = [dicBig objectForKey:@"addTime"];
        class.goods_groupinfos = [dicBig objectForKey:@"goods_list"];
        class.goods_status = [dicBig objectForKey:@"igo_status"];
        if([[dicBig objectForKey:@"igo_status"] intValue]==0){
            buttonCancel.hidden = NO;
        }else{
            buttonCancel.hidden = YES;
        }
        class.goods_sudu = [dicBig objectForKey:@"status_msg"];
        class.goods_oid = [dicBig objectForKey:@"oid"];
        class.dingdetail_order_id = [dicBig objectForKey:@"order_id"];
        class.goods_total_price = [dicBig objectForKey:@"order_total_price"];
        class.dingdetail_order_pay_msg =[dicBig objectForKey:@"payType"];
        class.dingdetail_ship_price =[dicBig objectForKey:@"ship_price"];
        class.goods_receiver_address =[dicBig objectForKey:@"receiver_address"];
        if([NSString stringWithFormat:@"%@",[dicBig objectForKey:@"receiver_mobile"]].length != 0 ){
            class.goods_receiver_mobile =[dicBig objectForKey:@"receiver_mobile"];
        }else{
            class.goods_receiver_mobile =[dicBig objectForKey:@"receiver_tel"];
        }
        class.goods_receiver_name =[dicBig objectForKey:@"receiver_name"];
        class.goods_pay_time =[dicBig objectForKey:@"pay_time"];
        [dataArray addObject:class];
        
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}

@end
