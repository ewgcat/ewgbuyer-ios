//
//  OrderDetailsViewController2.m
//  My_App
//
//  Created by apple on 14-10-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "OrderDetailsViewController2.h"
#import "ThirdViewController.h"
#import "CheckViewController.h"
#import "EnsureestimateViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "order_top_Cell.h"
#import "order_middle_Cell.h"

@interface OrderDetailsViewController2 ()

@property (nonatomic, weak)UIButton *wlBtn;

@end

@implementation OrderDetailsViewController2

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestOrderDetails1 clearDelegatesAndCancel];
    [requestOrderDetails2 clearDelegatesAndCancel];
    [requestOrderDetails3 clearDelegatesAndCancel];
    [requestOrderDetails4 clearDelegatesAndCancel];
    [requestOrderDetails12 clearDelegatesAndCancel];
}
-(void)wlBtnClicked{
    [self backBtnClicked:_wlBtn];
}
-(void)btnGoodsClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        NSArray *arr = (NSArray *)class.dingdetail_goods_list;
        for(int i=0;i<arr.count;i++){
            NSDictionary *dic = [arr objectAtIndex:i];
            if (btn.tag == 100 + i) {
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                sec.detail_id = [dic objectForKey:@"goods_id"];
                DetailViewController *detail = [[DetailViewController alloc]init];
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL]];
    requestOrderDetails1 = [ASIFormDataRequest requestWithURL:url3];
    [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestOrderDetails1 setPostValue:th.select_order_id forKey:@"order_id"];
    
    [requestOrderDetails1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestOrderDetails1.tag = 101;
    [requestOrderDetails1 setDelegate:self];
    [requestOrderDetails1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestOrderDetails1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestOrderDetails1 startAsynchronous];
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单详情:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == -200) {
            [self failedPrompt:@"订单信息错误"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == -100) {
            [self failedPrompt:@"订单信息错误"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            //成功查询了
            if (dataArray.count !=0 ) {
                [dataArray removeAllObjects];
            }
            
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.dingdetail_store_name = [dicBig objectForKey:@"store_name"];
            class.dingdetail_ship_price = [dicBig objectForKey:@"ship_price"];
            class.dingdetail_receiver_zip = [dicBig objectForKey:@"receiver_zip"];
            class.dingdetail_receiver_Name = [dicBig objectForKey:@"receiver_Name"];
            NSString *Str = [dicBig objectForKey:@"receiver_telephone" ];
            if (Str.length == 0) {
                class.dingdetail_receiver_mobile = [dicBig objectForKey:@"receiver_mobile"];
            }else{
                class.dingdetail_receiver_mobile = [dicBig objectForKey:@"receiver_telephone"];
            }
            class.dingdetail_receiver_area_info = [dicBig objectForKey:@"receiver_area_info"];
            class.dingdetail_receiver_area = [dicBig objectForKey:@"receiver_area"];
            class.dingdetail_payType = [dicBig objectForKey:@"payType"];
            class.dingdetail_order_total_price = [dicBig objectForKey:@"order_total_price"];
            class.dingdetail_order_status = [dicBig objectForKey:@"order_status"];
            if ([[dicBig objectForKey:@"order_status"] intValue]==0){
                buttonquxiao.hidden = YES;
            }else if ([[dicBig objectForKey:@"order_status"] intValue]< 16) {
                buttonquxiao.hidden = NO;
            }else {
                buttonquxiao.hidden = YES;
            }
            class.dingdetail_order_num = [dicBig objectForKey:@"order_num"];
            class.dingdetail_order_id = [dicBig objectForKey:@"order_id"];
            class.dingdetail_invoiceType = [dicBig objectForKey:@"invoiceType"];
            class.dingdetail_invoice = [dicBig objectForKey:@"invoice"];
            class.dingdetail_goods_price = [dicBig objectForKey:@"goods_price"];
            class.dingdetail_goods_list = [dicBig objectForKey:@"goods_list"];
            class.dingdetail_coupon_price = [dicBig objectForKey:@"coupon_price"];
            class.dingdetail_trans_list = [dicBig objectForKey:@"trans_list"];
            class.goods_addTime = [dicBig objectForKey:@"addTime"];
            [dataArray addObject:class];
        }
    }
    [MyTableView reloadData];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}

-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"订单详情";
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClicked)];
        rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
        [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
        [SYObject startLoading];
    }
    return self;
}
-(void)rightBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    NSLog(@"确认收货:%d",statuscode2);
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"确认收货:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            [self failedPrompt:@"已确认收货"];
            
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL]];
            requestOrderDetails1 = [ASIFormDataRequest requestWithURL:url3];
            [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [requestOrderDetails1 setPostValue:th.select_order_id forKey:@"order_id"];
            
            [requestOrderDetails1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestOrderDetails1.tag = 101;
            [requestOrderDetails1 setDelegate:self];
            [requestOrderDetails1 setDidFailSelector:@selector(urlRequestFailed:)];
            [requestOrderDetails1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [requestOrderDetails1 startAsynchronous];
        }
    }
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
-(void)MyBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(MyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    buttonquxiao = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonquxiao.frame =CGRectMake(0, 0, 65, 30);
    buttonquxiao.tag = 102;
    [buttonquxiao setTitle:@"取消订单" forState:UIControlStateNormal];
    [buttonquxiao addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonquxiao.titleLabel.font  = [UIFont systemFontOfSize:14];
    buttonquxiao.hidden = YES;
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonquxiao];
    self.navigationItem.rightBarButtonItem = bar2;
}
-(void)paymentResult:(NSString *)result{
    NSLog(@"result:%@",result);
}
-(void)backBtnClicked:(UIButton *)btn{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    if (btn.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 102) {
        [OHAlertView showAlertWithTitle:nil message:@"您确定要取消订单吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                buttonquxiao.hidden = YES;
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERCANCEL_URL]];
                requestOrderDetails12 = [ASIFormDataRequest requestWithURL:url4];
                [requestOrderDetails12 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [requestOrderDetails12 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                ThirdViewController *th = [ThirdViewController sharedUserDefault];
                [requestOrderDetails12 setPostValue:th.select_order_id forKey:@"order_id"];
                
                [requestOrderDetails12 setRequestHeaders:[LJControl requestHeaderDictionary]];
                requestOrderDetails12.tag = 303;
                [requestOrderDetails12 setDelegate:self];
                [requestOrderDetails12 setDidFailSelector:@selector(my1_urlRequestFailed:)];
                [requestOrderDetails12 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
                [requestOrderDetails12 startAsynchronous];
            }else if (buttonIndex == 1){
            }

        }];
    }
    if (btn.tag == 201) {
        if (dataArray.count!=0) {
            OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
            [self.navigationController pushViewController:on animated:YES];
        }
    }
    ClassifyModel *class222 = [dataArray objectAtIndex:0];
    if (btn.tag == 202) {
        //发起查看物流的请求
        NSDictionary *dic = [class222.dingdetail_trans_list objectAtIndex:0];
        th.train_order_id = [dic objectForKey:@"train_order_id"];
        CheckViewController *checek = [[CheckViewController alloc]init];
        [self.navigationController pushViewController:checek animated:YES];
        
    }
    for(int i=0;i<class222.dingdetail_trans_list.count;i++){
        if (btn.tag == 400+i) {
            NSDictionary *dic = [class222.dingdetail_trans_list objectAtIndex:i];
            th.train_order_id = [dic objectForKey:@"train_order_id"];
            CheckViewController *checek = [[CheckViewController alloc]init];
            [self.navigationController pushViewController:checek animated:YES];
        }
    }
    if (btn.tag == 203) {
        [OHAlertView showAlertWithTitle:@"提示信息" message:@"您确定要收货吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //发起确认收货的请求
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL]];
                requestOrderDetails3 = [ASIFormDataRequest requestWithURL:url];
                
                [requestOrderDetails3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [requestOrderDetails3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                
                [requestOrderDetails3 setPostValue:th.select_order_id forKey:@"order_id"];
                
                [requestOrderDetails3 setRequestHeaders:[LJControl requestHeaderDictionary]];
                requestOrderDetails3.tag = 103;
                [requestOrderDetails3 setDelegate:self];
                [requestOrderDetails3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
                [requestOrderDetails3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
                [requestOrderDetails3 startAsynchronous];
            }else if (buttonIndex == 1){
            }

        }];
    }
    if (btn.tag == 204) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        th.ding_order_id = class.dingdetail_order_id;
        EnsureestimateViewController *ensur = [[EnsureestimateViewController alloc]init];
        [self.navigationController pushViewController:ensur animated:YES];
    }
}
#pragma mark-取消订单
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            //发起确认收货的请求
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL]];
            requestOrderDetails3 = [ASIFormDataRequest requestWithURL:url];
            
            [requestOrderDetails3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestOrderDetails3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            
            [requestOrderDetails3 setPostValue:th.select_order_id forKey:@"order_id"];
            
            [requestOrderDetails3 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestOrderDetails3.tag = 103;
            [requestOrderDetails3 setDelegate:self];
            [requestOrderDetails3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
            [requestOrderDetails3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
            [requestOrderDetails3 startAsynchronous];
        }else if (buttonIndex == 1){
        }
    }
    if (alertView.tag == 102) {
        if (buttonIndex == 0) {
            buttonquxiao.hidden = YES;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERCANCEL_URL]];
            requestOrderDetails12 = [ASIFormDataRequest requestWithURL:url4];
            [requestOrderDetails12 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestOrderDetails12 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            [requestOrderDetails12 setPostValue:th.select_order_id forKey:@"order_id"];
            
            [requestOrderDetails12 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestOrderDetails12.tag = 303;
            [requestOrderDetails12 setDelegate:self];
            [requestOrderDetails12 setDidFailSelector:@selector(my1_urlRequestFailed:)];
            [requestOrderDetails12 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
            [requestOrderDetails12 startAsynchronous];
        }else if (buttonIndex == 1){
        }
    }
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode3 = [request responseStatusCode];
    if (statuscode3 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:requestOrderDetails12.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            if (code.intValue == -100 ) {
                [self failedPrompt:@"用户信息不正确"];
            }
            else if (code.intValue == -200){
                [self failedPrompt:@"订单信息错误"];
            }
            else {
                [self failedPrompt:@"成功取消订单"];
                
                ThirdViewController *th = [ThirdViewController sharedUserDefault];
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL]];
                requestOrderDetails1 = [ASIFormDataRequest requestWithURL:url3];
                [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [requestOrderDetails1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [requestOrderDetails1 setPostValue:th.select_order_id forKey:@"order_id"];
                
                [requestOrderDetails1 setRequestHeaders:[LJControl requestHeaderDictionary]];
                requestOrderDetails1.tag = 101;
                [requestOrderDetails1 setDelegate:self];
                [requestOrderDetails1 setDidFailSelector:@selector(urlRequestFailed:)];
                [requestOrderDetails1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
                [requestOrderDetails1 startAsynchronous];
            }
        }
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
#pragma mark-tableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 390;
    }
    else if(indexPath.row == 1){
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            NSArray *arr = (NSArray *)class.dingdetail_goods_list;
            return arr.count*70+50;
        }
    }
    else if(indexPath.row == 2){
        if (dataArray.count!=0) {
            return 178;
        }
    }
    else if(indexPath.row == 3){
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            if (class.dingdetail_trans_list.count!=0) {
                NSDictionary *dic = [class.dingdetail_trans_list objectAtIndex:0];
                if ([[dic allKeys] containsObject:@"express_company"]){
                    return 30+class.dingdetail_trans_list.count*60+10+54;
                }else{
                    return 100+54;
                }
            }
        }
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        order_top_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"order_top_Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"order_top_Cell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (dataArray.count !=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            
            cell.orderPrice.text = [NSString stringWithFormat:@"下单时间：%@",class.goods_addTime];
            cell.goodPrice.text =[NSString stringWithFormat:@"商品金额：￥%@",class.dingdetail_goods_price];
            cell.shipPrice.text = [NSString stringWithFormat:@"物流运费：￥%@",class.dingdetail_ship_price];
            cell.couponPrice.text = [NSString stringWithFormat:@"优  惠  券：￥%@",class.dingdetail_coupon_price];
            cell.ordernum.text = [NSString stringWithFormat:@"订单编号：%@",class.dingdetail_order_num];
            cell.orderTime.text = [NSString stringWithFormat:@"订单金额：￥%@",class.dingdetail_order_total_price];
            if ([class.dingdetail_order_status intValue] == 20) {
                cell.status.text = @"已付款待发货";
            }else if ([class.dingdetail_order_status intValue] == 30) {
                cell.status.text = @"已发货待收货";
                cell.myBtn.tag = 203;
                [cell.myBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.myBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else if([class.dingdetail_order_status intValue]==50){
                cell.status.text = @"订单已完成";
            }else if ([class.dingdetail_order_status intValue] == 40) {
                cell.status.text = @"已收货";
                cell.myBtn.tag = 204;
                [cell.myBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                [cell.myBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([class.dingdetail_order_status intValue] == 16) {
                cell.status.text = @"货到付款";
            }else if ([class.dingdetail_order_status intValue] == 15) {
                cell.status.text = @"线下付款提交已申请";
            }else if ([class.dingdetail_order_status intValue] == 10) {
                cell.status.text = @"待付款";
                cell.myBtn.tag = 201;
                [cell.myBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                [cell.myBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([class.dingdetail_order_status intValue] == 0) {
                cell.status.text = @"订单已取消";
            }
            cell.person.text = [NSString stringWithFormat:@"%@ %@",class.dingdetail_receiver_Name,class.dingdetail_receiver_mobile];;
            cell.address.text = [NSString stringWithFormat:@"收货地址：%@%@",class.dingdetail_receiver_area,class.dingdetail_receiver_area_info];
        }
        return cell;
    }else if (indexPath.row == 1){
        static NSString *myTabelviewCell = @"PhysicalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BACKGROUNDCOLOR;
        }
        if (dataArray.count !=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            UILabel *labelM = [LJControl labelFrame:CGRectMake(0, 10, ScreenFrame.size.width, 44) setText:@"    商品清单" setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
            [cell addSubview:labelM];
            
            NSArray *arr = (NSArray *)class.dingdetail_goods_list;
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 54, ScreenFrame.size.width, 65*arr.count)];
            image.userInteractionEnabled = YES;
            image.userInteractionEnabled = YES;
            image.backgroundColor = [UIColor whiteColor];
            [cell addSubview:image];
            UIImageView *LL = [LJControl imageViewFrame:CGRectMake(15, 54, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
            [cell addSubview:LL];
            for(int i=0;i<arr.count;i++){
                NSDictionary *dic = [arr objectAtIndex:i];
                UIButton *btnToDetails = [UIButton buttonWithType:UIButtonTypeCustom];
                btnToDetails.frame = CGRectMake(0, i*65 , ScreenFrame.size.width - 20, 60);
                btnToDetails.tag = 100+i;
                [btnToDetails addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [image addSubview:btnToDetails];
                
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5+i*60, 55, 55)];
                imageview.userInteractionEnabled = YES;
                [imageview sd_setImageWithURL:(NSURL*)[dic objectForKey:@"goods_mainphoto_path"] placeholderImage:[UIImage imageNamed:@""]];
                [image addSubview:imageview];
                UILabel *status1= [[UILabel alloc]initWithFrame:CGRectMake(85, 0+i*60, ScreenFrame.size.width - 110, 45)];
                status1.numberOfLines = 3;
                status1.text = [dic objectForKey:@"goods_name"];
                status1.textColor = [UIColor grayColor];
                status1.font = [UIFont systemFontOfSize:12];
                [image addSubview:status1];
                UILabel *status2= [[UILabel alloc]initWithFrame:CGRectMake(85, 45+i*60, ScreenFrame.size.width - 180, 20)];
                status2.text = [NSString stringWithFormat:@"%@×%@",[dic objectForKey:@"goods_gsp_val"],[dic objectForKey:@"goods_count"]];
                status2.textColor = [UIColor grayColor];
                status2.font = [UIFont systemFontOfSize:12];
                [image addSubview:status2];
                UILabel *status3= [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 95, 45+i*60, 65, 20)];
                status3.textAlignment = NSTextAlignmentRight;
                status3.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"goods_price"]];
                status3.textColor = [UIColor redColor];
                status3.font = [UIFont systemFontOfSize:12];
                [image addSubview:status3];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                button.frame =CGRectMake(0, 0+i*60, ScreenFrame.size.width, 60);
                button.tag = 100+i;
                [button addTarget:self action:@selector(btnGoodsClicked:) forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font  = [UIFont systemFontOfSize:12];
                [image addSubview:button];
            }
        }
        return cell;
    }else if (indexPath.row == 2){
        order_middle_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"order_middle_Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"order_middle_Cell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (dataArray.count !=0){
            ClassifyModel *class = [dataArray objectAtIndex:0];
            cell.paymethod.text = [NSString stringWithFormat:@"%@",class.dingdetail_payType];
            cell.ticketTitle.text = [NSString stringWithFormat:@"%@",class.dingdetail_invoice ];
            cell.ticketType.text = [NSString stringWithFormat:@"%@",class.dingdetail_invoiceType ];
        }
        return cell;
    }else{
        static NSString *myTabelviewCell = @"PhysicalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BACKGROUNDCOLOR;
        }
        if (dataArray.count !=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            UILabel *labelM = [LJControl labelFrame:CGRectMake(0, 10, ScreenFrame.size.width, 44) setText:@"    物流信息" setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
            [cell addSubview:labelM];
            UIImageView *image3 = [[UIImageView alloc]init];
            image3.backgroundColor = [UIColor whiteColor];
            if (class.dingdetail_trans_list.count!=0) {
                NSDictionary *dic = [class.dingdetail_trans_list objectAtIndex:0];
                if ([[dic allKeys] containsObject:@"express_company"]){
                    image3.frame = CGRectMake(0, 54, ScreenFrame.size.width, 30+class.dingdetail_trans_list.count*60);
                }else{
                    image3.frame = CGRectMake(0, 54, ScreenFrame.size.width, 30+60);
                }
            }
            image3.userInteractionEnabled = YES;
            [cell addSubview:image3];
            
            UIImageView *iamgeL = [LJControl imageViewFrame:CGRectMake(15,54, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
            [cell addSubview:iamgeL];
            
            if (class.dingdetail_trans_list.count==1) {
                UILabel *status11= [[UILabel alloc]initWithFrame:CGRectMake(15, 30, ScreenFrame.size.width - 30, 30)];
                UILabel *status10= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenFrame.size.width -30, 30)];
                status10.textColor = [UIColor grayColor];
                status10.font = [UIFont systemFontOfSize:15];
                [image3 addSubview:status10];
                
                status11.textColor = [UIColor grayColor];
                status11.font = [UIFont systemFontOfSize:15];
                [image3 addSubview:status11];
                
                NSDictionary *dic = [class.dingdetail_trans_list objectAtIndex:0];
                if ([[dic allKeys] containsObject:@"express_company"]){//包含
                    status10.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"express_company"]];
                    status11.text = [NSString stringWithFormat:@"订单号:%@",[dic objectForKey:@"shipCode"]];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                    button.frame =CGRectMake(ScreenFrame.size.width - 95, 10, 80, 25);
                    button.tag = 202;
                    [button setTitle:@"查看物流" forState:UIControlStateNormal];
                    button.backgroundColor = MY_COLOR;
                    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    button.titleLabel.font  = [UIFont systemFontOfSize:14];
                    [image3 addSubview:button];
                    _wlBtn = button;
                    
                }else{//不包含
                    status10.text = @"      暂无物流信息";
                }
            }else if (class.dingdetail_trans_list.count==0) {
                
            }else{
                NSDictionary *dic = [class.dingdetail_trans_list objectAtIndex:0];
                if ([[dic allKeys] containsObject:@"express_company"]){
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, ScreenFrame.size.width - 140, 30)];
                    label.text = @"(该商品由多个物流公司负责)";
                    label.textColor = [UIColor grayColor];
                    label.font = [UIFont systemFontOfSize:12];
                    [image3 addSubview:label];
                    
                    for(int i=0;i<class.dingdetail_trans_list.count;i++){
                        NSDictionary *dic = [class.dingdetail_trans_list objectAtIndex:i];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0+i*60, ScreenFrame.size.width - 100, 30)];
                        label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"express_company"]];
                        label.textColor = [UIColor grayColor];
                        label.font = [UIFont systemFontOfSize:15];
                        [image3 addSubview:label];
                        
                        UILabel *labelt = [[UILabel alloc]initWithFrame:CGRectMake(5, 30+i*60, ScreenFrame.size.width - 30, 30)];
                        labelt.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"订单号:%@",[dic objectForKey:@"shipCode"]]];
                        labelt.textColor = [UIColor grayColor];
                        labelt.font = [UIFont systemFontOfSize:15];
                        [image3 addSubview:labelt];
                        
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                        button.frame =CGRectMake(ScreenFrame.size.width - 95, 10+68*i, 80, 25);
                        button.tag = 400+i;
                        [button setTitle:@"查看物流" forState:UIControlStateNormal];
                        button.backgroundColor = MY_COLOR;
                        [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        button.titleLabel.font  = [UIFont systemFontOfSize:14];
                        [image3 addSubview:button];
                        
                    }
                }else{
                    UILabel *status10= [[UILabel alloc]initWithFrame:CGRectMake(5, 30, ScreenFrame.size.width - 30, 30)];
                    status10.textColor = [UIColor grayColor];
                    status10.font = [UIFont systemFontOfSize:15];
                    [image3 addSubview:status10];
                    status10.text = @"      暂无物流信息";
                }
            }
            UILabel *status12= [[UILabel alloc]initWithFrame:CGRectMake(5, 70, ScreenFrame.size.width - 30, 30)];
            if (class.dingdetail_express_company.length == 0) {
                status12.text = @"";
            }else{
                status12.text = [NSString stringWithFormat:@"发货时间:%@",class.dingdetail_shipTime];
            }
            
            status12.textColor = [UIColor grayColor];
            status12.font = [UIFont systemFontOfSize:15];
            [image3 addSubview:status12];
        }
        
        return cell;
    }
    return nil;
}

-(void) btnClicked:(UIButton *)btn{
    ClassifyModel *class = [dataArray objectAtIndex:0];
    NSArray *arr = (NSArray *)class.dingdetail_goods_list;
    for (int i=0;i<arr.count;i++) {
        if (btn.tag == 100 + i) {
            DetailViewController *det = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:det animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
