//
//  onlinePayTypesIntegralViewController.m
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "onlinePayTypesIntegralViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataVerifier.h"
#import "Order.h"
#import "MoneyPayIntegralViewController.h"
#import "LoginViewController.h"
#import "wIntegralOrderDetailViewController.h"
#import "FirstViewController.h"

@interface onlinePayTypesIntegralViewController (){
    ASIFormDataRequest *request102;
    ASIFormDataRequest *request101;
    ASIFormDataRequest *request106;
    ASIFormDataRequest *request105;
    ASIFormDataRequest *requestOnlinePayTypeSelect_wx;
    ASIFormDataRequest *requestWX_back;
}

@end

static onlinePayTypesIntegralViewController *singleInstance=nil;

@implementation onlinePayTypesIntegralViewController

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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request105 clearDelegatesAndCancel];
    [request106 clearDelegatesAndCancel];
    [request101 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
    [requestWX_back clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect_wx clearDelegatesAndCancel];
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



-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    FirstViewController *firest = [FirstViewController sharedUserDefault];
    firest.payType = @"integral";
    self.tabBarController.tabBar.hidden = YES;
    if (_MyBool == NO) {
        
    }else{
        _MyBool = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ALLPAYTYPE_URL]];
    request102 = [ASIFormDataRequest requestWithURL:url2];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    request102.delegate = self;
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    [super viewWillAppear:YES];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"2dicBig:%@",dicBig);
        if(dicBig){
            MyTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            if (dataArray.count !=0) {
                [dataArray removeAllObjects];
            }
            NSArray *arr = [dicBig objectForKey:@"datas"];
            for(NSDictionary *dic in arr){
                [dataArray addObject:dic];
            }
            [MyTableView reloadData];
        }
        [SYObject endLoading];
    }
    
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"3dicBig:%@",dicBig);
        if (arrayPay.count != 0) {
            [arrayPay removeAllObjects];
        }
        ClassifyModel *class = [[ClassifyModel alloc]init];
        class.dingdetail_store_name = [dicBig objectForKey:@"store_name"];
        class.dingdetail_ship_price = [dicBig objectForKey:@"ship_price"];
        class.dingdetail_receiver_zip = [dicBig objectForKey:@"receiver_zip"];
        class.dingdetail_receiver_Name = [dicBig objectForKey:@"receiver_Name"];
        class.dingdetail_receiver_mobile = [dicBig objectForKey:@"receiver_mobile"];
        class.dingdetail_receiver_area_info = [dicBig objectForKey:@"receiver_area_info"];
        class.dingdetail_receiver_area = [dicBig objectForKey:@"receiver_area"];
        class.dingdetail_payType = [dicBig objectForKey:@"payType"];
        class.dingdetail_order_total_price = [dicBig objectForKey:@"order_total_price"];
        class.dingdetail_order_status = [dicBig objectForKey:@"order_status"];
        class.dingdetail_order_num = [dicBig objectForKey:@"order_num"];
        class.dingdetail_order_id = [dicBig objectForKey:@"order_id"];
        class.dingdetail_invoiceType = [dicBig objectForKey:@"invoiceType"];
        class.dingdetail_invoice = [dicBig objectForKey:@"invoice"];
        class.dingdetail_goods_price = [dicBig objectForKey:@"goods_price"];
        class.dingdetail_goods_list = [dicBig objectForKey:@"goods_list"];
        class.dingdetail_coupon_price = [dicBig objectForKey:@"coupon_price"];
        
        if ([[dicBig allKeys] containsObject:@"express_company"]){
            class.dingdetail_express_company = [dicBig objectForKey:@"express_company"];
        }
        if ([[dicBig allKeys] containsObject:@"shipTime"]){
            class.dingdetail_shipTime = [dicBig objectForKey:@"shipTime"];
        }
        if ([[dicBig allKeys] containsObject:@"shipCode"]){
            class.dingdetail_shipCode = [dicBig objectForKey:@"shipCode"];
        }
        [arrayPay addObject:class];
         [SYObject endLoading];
        _result = @selector(paymentResult:);
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.ding_jine = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,PAYBAO_URL]];
        request101=[ASIFormDataRequest requestWithURL:url3];
        [request101 setPostValue:online_mark forKey:@"mark"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 101;
        request101.delegate = self;
        [request101 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"支付宝App:%@",dicBig);
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.priteKey = [dicBig objectForKey:@"private"];
        PartnerID = [dicBig objectForKey:@"partner"];
        SellerID = [dicBig objectForKey:@"seller"];
        PartnerPrivKey = [dicBig objectForKey:@"private"];
        AlipayPubKey = [dicBig objectForKey:@"public"];
        MD5_KEY = [dicBig objectForKey:@"safekey"];
        
        if (dataArray.count!=0) {
            NSString *partner = [dicBig objectForKey:@"partner"];
            NSString *seller = [dicBig objectForKey:@"seller"];
            NSString *privateKey = [dicBig objectForKey:@"private"];
            
            //partner和seller获取失败,提示
            if ([partner length] == 0 ||[seller length] == 0 ||[privateKey length] == 0){
                [OHAlertView showAlertWithTitle:@"提示" message:@"缺少partner或者seller或者私钥。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                }];
               return;
            }
            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order *order = [[Order alloc] init];
            order.partner = partner;
            order.seller = seller;
            order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
            order.productName = th.ding_hao; //商品标题
            order.productDescription = th.ding_hao; //商品描述
            order.amount = [NSString stringWithFormat:@"%.2f",[th.jie_order_goods_price floatValue]]; //商品价格
            order.notifyURL = [NSString stringWithFormat:@"%@%@",FIRST_URL,ALIPAY_NOTIFY_INTEGRAL_URL]; //回调URL
            
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"alisdkdemo";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
                        //支付成功
                        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,LIFEPAY_REYURN_URL]];
                        request106=[ASIFormDataRequest requestWithURL:url3];
                        [request106 setPostValue:th.strout_trade_no forKey:@"out_trade_no"];
                        [request106 setPostValue:th.priteKey forKey:@"private"];
                        
                        [request106 setRequestHeaders:[LJControl requestHeaderDictionary]];
                        request106.delegate = self;
                        [request106 setDidFailSelector:@selector(my3_urlRequestFailed:)];
                        [request106 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
                        [request106 startAsynchronous];
                    }else{
                        //支付失败
                    }
                }];
            }
        }
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"回调:%@",dicBig);
        if(dicBig){
            if ([[dicBig objectForKey:@"code"] intValue]==100){
                //回调成功则成功
                myWebView.hidden = NO;
                ThirdViewController *th = [ThirdViewController sharedUserDefault];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,th.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
                NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
                [myWebView loadRequest:requestweb];
            }
        }
    }
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
        if (ScreenFrame.size.height>480) {//说明是5 5s
//            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height)];
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height)];
        }else{
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height)];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        MyTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        [self.view addSubview:MyTableView];
        
        ThirdViewController *third = [ThirdViewController sharedUserDefault];
        myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        myWebView.backgroundColor = [UIColor whiteColor];
        myWebView.scalesPageToFit = YES;
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,third.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
        NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
        [myWebView loadRequest:requestweb];
        myWebView.delegate = self;
        myWebView.hidden = YES;
        [self.view addSubview:myWebView];
        
       
    }
    return self;
}
-(void)webVIewRefresh{
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    myWebView.hidden = NO;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,third.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
    [myWebView loadRequest:requestweb];
    
    // 发起回调请求
    NSURL *urlB = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,WXPAY_INTERGRAL_BACKURL]];
    requestWX_back = [ASIFormDataRequest requestWithURL:urlB];
    
    [requestWX_back setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestWX_back setPostValue:third.ding_hao forKey:@"id"];
    [requestWX_back setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestWX_back.delegate = self;
    [requestWX_back setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestWX_back setDidFinishSelector:@selector(wxBack_urlRequestSucceeded:)];
    [requestWX_back startAsynchronous];
}
-(void)wxPayFaild{
     [SYObject endLoading];
    [SYObject failedPrompt:@"支付错误，请重试"];
}
-(void)wxPayCancel{
     [SYObject endLoading];
    [SYObject failedPrompt:@"您已取消微信支付"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择支付方式";
    tagZHI = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc]init];
    [self createBackBtn];
    
    
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        return 20+40*dataArray.count+20+94;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        ThirdViewController *th  = [ThirdViewController sharedUserDefault];
        UILabel *lableD = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenFrame.size.width, 30)];
        lableD.text = @"    订单号:";
        lableD.backgroundColor = [UIColor whiteColor];
        lableD.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:lableD];
        UILabel *lableH = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, ScreenFrame.size.width-50, 30)];
        lableH.text = [NSString stringWithFormat:@"%@",th.ding_order_id];
        lableH.textAlignment = NSTextAlignmentRight;
        lableH.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:lableH];
        UILabel *lableJ = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenFrame.size.width, 30)];
        lableJ.text = @"    订单金额:";
        lableJ.font = [UIFont boldSystemFontOfSize:15];
        lableJ.backgroundColor = [UIColor whiteColor];
        [cell addSubview:lableJ];
        UILabel *lableJM = [[UILabel alloc]initWithFrame:CGRectMake(30, 35, ScreenFrame.size.width-50, 30)];
        lableJM.text = [NSString stringWithFormat:@"￥%0.2f",[th.jie_order_goods_price floatValue]];
        lableJM.font = [UIFont boldSystemFontOfSize:15];
        lableJM.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lableJM];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 70, ScreenFrame.size.width, dataArray.count*40)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        for(int i=0;i<dataArray.count;i++){
            
            UIImageView *lableLL = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70+40*i, ScreenFrame.size.width-20, 0.5)];
            if (i == 0) {
                lableLL.hidden = YES;
            }else{
                lableLL.hidden = NO;
            }
            lableLL.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:lableLL];
            
            UILabel *lablec = [[UILabel alloc]initWithFrame:CGRectMake(0, 70+40*i, 280, 40)];
            lablec.text = [NSString stringWithFormat:@"    %@",[[dataArray objectAtIndex:i] objectForKey:@"pay_name"]];
            lablec.font = [UIFont boldSystemFontOfSize:15];
            [cell addSubview:lablec];
            UILabel *labledc = [[UILabel alloc]initWithFrame:CGRectMake(0, 70+40*i, ScreenFrame.size.width-20, 40)];
            if (tagZHI == i) {
                labledc.text = @"✅";
            }else{
                labledc.text = @"☑️";
            }
            labledc.font = [UIFont boldSystemFontOfSize:15];
            labledc.textAlignment = NSTextAlignmentRight;
            [cell addSubview:labledc];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            button.frame =CGRectMake(0, 70+40*i, ScreenFrame.size.width, 40);
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100+i;
            button.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        button.frame =CGRectMake((ScreenFrame.size.width-100)/2, 80 + dataArray.count*40, 100, 34);
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 201;
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        button.backgroundColor = MY_COLOR;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:4.0];
        button.titleLabel.font  = [UIFont boldSystemFontOfSize:17];
        [cell addSubview:button];
    }
    return cell;
}

-(void)btnClicked:(UIButton *)btn{
    if (btn.tag <200) {
        if (dataArray.count!=0) {
            tagZHI = btn.tag-100;
            [MyTableView reloadData];
        }
    }
    if (btn.tag == 201) {
        [SYObject startLoading];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        if (dataArray.count!=0) {
            NSDictionary *dic = [dataArray objectAtIndex:tagZHI];
            if ([[dic objectForKey:@"pay_mark"] isEqualToString:online_mark]) {
                //做判断前一个页面是什么
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL]];
                request105=[ASIFormDataRequest requestWithURL:url3];
                [request105 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request105 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request105 setPostValue:th.ding_order_id forKey:@"order_id"];
                
                [request105 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request105.delegate = self;
                [request105 setDidFailSelector:@selector(my1_urlRequestFailed:)];
                [request105 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
                [request105 startAsynchronous];
                
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:balance_mark]){
                MoneyPayIntegralViewController *UUU = [[MoneyPayIntegralViewController alloc]init];
                [self.navigationController pushViewController:UUU animated:YES];
                
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:weixin_mark]){
                NSLog(@"微信支付");
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,WXPAY_URL]];
                requestOnlinePayTypeSelect_wx=[ASIFormDataRequest requestWithURL:url3];
                [requestOnlinePayTypeSelect_wx setPostValue:th.ding_hao forKey:@"id"];
                [requestOnlinePayTypeSelect_wx setPostValue:@"integral" forKey:@"type"];
                
                [requestOnlinePayTypeSelect_wx setRequestHeaders:[LJControl requestHeaderDictionary]];
                requestOnlinePayTypeSelect_wx.delegate = self;
                [requestOnlinePayTypeSelect_wx setDidFailSelector:@selector(wx_urlRequestFailed:)];
                [requestOnlinePayTypeSelect_wx setDidFinishSelector:@selector(wx_urlRequestSucceeded:)];
                [requestOnlinePayTypeSelect_wx startAsynchronous];
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:@"unionpay"]){
                NSLog(@"银联支付");
            }
        }
    }
}
-(void)wxBack_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"INstegral_WXBACK:%@",dicBig);
    }
}
-(void)wx_urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)wx_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1dicBig:%@",dicBig);
        if (dicBig) {
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dicBig objectForKey:@"appId"];
            req.partnerId           = [dicBig objectForKey:@"partnerId"];
            req.prepayId            = [dicBig objectForKey:@"prepayId"];
            req.nonceStr            = [dicBig objectForKey:@"nonceStr"];
            req.timeStamp           = [[dicBig objectForKey:@"timeStamp"] intValue];
            req.package             = [dicBig objectForKey:@"packageValue"];
            req.sign                = [dicBig objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"积分微信支付------appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }
         [SYObject endLoading];
    }
}
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
    result= (NSMutableString*)[NSString stringWithFormat:@"order-%@-%@-goods",result,th.ding_hao]; //订单ID（由商家自行制定）
    th.strout_trade_no = result;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSLog(@"arrFucnameAndParameter:%@",arrFucnameAndParameter);
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            if([funcStr isEqualToString:@"gotoIndex"])
            {
            }
        }
        else if(2 == [arrFucnameAndParameter count])
        {
            if([funcStr isEqualToString:@"go_goods_order"])
            {
                //去我的订单页面 点击返回按钮后进入root页面 购物车页面
                myWebView.hidden = YES;
                LoginViewController *log = [LoginViewController sharedUserDefault];
                
                log.return_oid = [arrFucnameAndParameter objectAtIndex:1];
                UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
                wIntegralOrderDetailViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"wIntegralOrderDetailViewController"];;
                [self.navigationController pushViewController:ordrt animated:YES];
            }
            if([funcStr isEqualToString:@"gotoOrder"])
            {
                
            }
        }
        return NO;
    };
    return YES;
}
@end
