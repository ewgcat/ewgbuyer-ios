//
//  MoneyPayViewController2.m
//  My_App
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoneyPayViewController2.h"
#import "ThirdViewController.h"
#import "PaySettingViewController.h"
#import "balancePayCell.h"
#import "OnlinePayTypeSelectViewController.h"
#import "OrderDetailsViewController2.h"

@interface MoneyPayViewController2 ()

@end

static MoneyPayViewController2 *singleInstance=nil;

@implementation MoneyPayViewController2
{
    ASIFormDataRequest *requestMoneyPay1;
}

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
    [requestMoneyPay1 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if (_MyBool == NO) {
        
    }else{
        _MyBool = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    [super viewWillAppear:YES];
    [MyTableView reloadData];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    bianhao.text = [NSString stringWithFormat:@"%@",th.ding_hao];
    jine.text = [NSString stringWithFormat:@"￥%@",th.jie_order_goods_price];
    strPassword = @"";
    //发起请求是否设置了支付密码
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,PAY_PASSWORD_CHECK_URL]];
    requestMoneyPay1 =[ASIFormDataRequest requestWithURL:url3];
    [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestMoneyPay1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestMoneyPay1.tag = 105;
    requestMoneyPay1.delegate = self;
    [requestMoneyPay1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestMoneyPay1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestMoneyPay1 startAsynchronous];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig2:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100){
            pay_password = [dicBig objectForKey:@"pay_password"];
            paymoneyBtn.enabled = YES;
            buttonPass.hidden = YES;
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            bianhao.text = [NSString stringWithFormat:@"%@",th.ding_hao];
            jine.text = [NSString stringWithFormat:@"￥%@",th.jie_order_goods_price];
        }else if([[dicBig objectForKey:@"code"] intValue] == -200){
            if ([self.title isEqualToString:after_pay]) {
                
            }else if([self.title isEqualToString:balance_pay]){
                [self failedPrompt:@"用户信息错误"];
            }
        }else if([[dicBig objectForKey:@"code"] intValue] == -300){
            PaySettingViewController *psVC = [PaySettingViewController new];
            [self.navigationController pushViewController:psVC animated:YES];
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [self failedPrompt:@"参数错误"];
        }else{
        }
    }else{
        NSLog(@"!=200");
    }
    [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    buttonPass = nil;
    bianhao = nil;
    jine = nil;
    paymoneyBtn = nil;myWebView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y+64, ScreenFrame.size.width, self.view.frame.size.height-64)];
        }else{
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        MyTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:MyTableView];
        
        ThirdViewController *third = [ThirdViewController sharedUserDefault];
        myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        myWebView.backgroundColor = [UIColor whiteColor];
        myWebView.scalesPageToFit = YES;
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        
        NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,third.ding_order_id,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
        NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
        [myWebView loadRequest:requestweb];
        myWebView.delegate = self;
        myWebView.hidden = YES;
        [self.view addSubview:myWebView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _MyBool = NO;
    self.title = @"预存款支付";
    [self createBackBtn];
    [self createWebView];
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(void)disappear{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"balancePayCell";
    balancePayCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"balancePayCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [cell addGestureRecognizer:singleTapGestureRecognizer3];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    cell.order_id.text = [NSString stringWithFormat:@"%@",th.ding_hao];
    cell.order_price.text = [NSString stringWithFormat:@"%@",th.jie_order_goods_price];
    
    cell.passwordsTextField.delegate = self;
    
    cell.payBtn.tag = 102;
    [cell.payBtn.layer setMasksToBounds:YES];
    [cell.payBtn.layer setCornerRadius:4.0f];
    [cell.payBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    buttonPass = nil;
    myWebView = nil;
    pay_password = nil;
    bianhao = nil;
    jine = nil;
    paymoneyBtn= nil;
    _moneyPaymethod = nil;
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    buttonPass = nil;
    myWebView = nil;
    pay_password = nil;
    bianhao = nil;
    jine = nil;
    paymoneyBtn= nil;
    _moneyPaymethod = nil;
    
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
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 100002) {
        PaySettingViewController *pa = [[PaySettingViewController alloc]init];
        [self.navigationController pushViewController:pa animated:YES];
    }
    if (btn.tag == 102) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        _moneyPaymethod = balance_pay;
        if (strPassword.length ==0) {
            [self failedPrompt:@"请输入支付密码"];
        }else{
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,YUCUNPAYYAN_URL]];
            requestMoneyPay1=[ASIFormDataRequest requestWithURL:url3];
            
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [requestMoneyPay1 setPostValue:strPassword forKey:@"password"];
            
            [requestMoneyPay1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestMoneyPay1.tag = 103;
            requestMoneyPay1.delegate = self;
            [requestMoneyPay1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
            [requestMoneyPay1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
            [requestMoneyPay1 startAsynchronous];
        }
    }
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig=%@",dicBig);
        if ([[dicBig objectForKey:VERIFY] intValue] == 1) {
            ThirdViewController *third = [ThirdViewController sharedUserDefault];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,BALANCEPAY_URL]];
            requestMoneyPay1=[ASIFormDataRequest requestWithURL:url3];
            [SYObject startLoading];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestMoneyPay1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [requestMoneyPay1 setPostValue:balance_mark forKey:@"pay_msg"];
            [requestMoneyPay1 setPostValue:third.ding_order_id forKey:@"order_id"];
            
            [requestMoneyPay1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestMoneyPay1.tag = 104;
            requestMoneyPay1.delegate = self;
            [requestMoneyPay1 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [requestMoneyPay1 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [requestMoneyPay1 startAsynchronous];
        }else{
            strPassword = @"";
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,密码输入错误，请重试。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }
        
    }else{
        [self failedPrompt:@"请求出错，请重试"];
    }
    [SYObject endLoading];
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig=%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == -300) {
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,订单支付方式信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if([[dicBig objectForKey:@"code"] intValue] == -400){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,预存款余额不足" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];

        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,用户信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if([[dicBig objectForKey:@"code"] intValue] == -200){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,订单信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else{
            //创建webview
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,th.ding_order_id,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
            myWebView.hidden = NO;
        }
    }
    [SYObject endLoading];
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig=%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == -300) {
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,订单支付方式信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];

        }else if([[dicBig objectForKey:@"code"] intValue] == -400){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,预存款余额不足" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,用户信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if([[dicBig objectForKey:@"code"] intValue] == -200){
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,订单信息错误" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else{
            //创建webview
            OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
            on.MyBool = YES;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,th.ding_order_id,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
            myWebView.hidden = NO;
        }
    }else{
        NSLog(@"支付失败了");
    }
    [SYObject endLoading];
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    strPassword = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            PaySettingViewController *pay = [[PaySettingViewController alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            buttonPass = [UIButton buttonWithType:UIButtonTypeCustom ];
            buttonPass.frame =CGRectMake(ScreenFrame.size.width - 95, 75, 80, 24);
            buttonPass.backgroundColor = MY_COLOR;
            [buttonPass addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            buttonPass.tag = 100002;
            buttonPass.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [buttonPass setTitle:@"设置支付密码" forState:UIControlStateNormal];
            [MyTableView addSubview:buttonPass];
            CALayer *lay3  = buttonPass.layer;
            [lay3 setMasksToBounds:YES];
            [lay3 setCornerRadius:2.0];
            
            [self failedPrompt:@"设置支付密码后，才能完成付款"];
        }
    }
}

-(void)createWebView{
    
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
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
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
                _MyBool = YES;
                ThirdViewController *th = [ThirdViewController sharedUserDefault];
                th.select_order_id = th.ding_order_id;
                
                OrderDetailsViewController2 *or = [[OrderDetailsViewController2 alloc]init];
                [self.navigationController pushViewController:or animated:YES];
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
