//
//  MoneyPayIntegralViewController.m
//  My_App
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoneyPayIntegralViewController.h"
#import "ThirdViewController.h"
#import "PaySettingViewController.h"
#import "NilCell.h"
#import "IntegralOrderDetail2ViewController.h"
#import "LoginViewController.h"
#import "onlinePayTypesIntegralViewController.h"

@interface MoneyPayIntegralViewController (){
    ASIFormDataRequest *request105;
    ASIFormDataRequest *request103;
    ASIFormDataRequest *request104;
}

@end

static MoneyPayIntegralViewController *singleInstance=nil;

@implementation MoneyPayIntegralViewController

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
    [request103 clearDelegatesAndCancel];
    [request104 clearDelegatesAndCancel];
    [request105 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if (_Mybool == NO) {
        
    }else{
        _Mybool = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [super viewWillAppear:YES];
    [SYObject startLoading];
    [MyTableView reloadData];
    _moneyType = @"_moneyType1";
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    bianhao.text = [NSString stringWithFormat:@"%@",th.ding_order_id];
    jine.text = [NSString stringWithFormat:@"￥%@",th.jie_order_goods_price];
    password.text = @"";
    //发起请求是否设置了支付密码
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,PAY_PASSWORD_CHECK_URL]];
    request105=[ASIFormDataRequest requestWithURL:url3];
    [request105 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request105 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request105 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request105.tag = 105;
    request105.delegate = self;
    [request105 setDidFailSelector:@selector(urlRequestFailed:)];
    [request105 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request105 startAsynchronous];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
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
    password = nil;
    jine = nil;
    paymoneyBtn = nil;
    myWebView.hidden = YES;
    
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
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, ScreenFrame.size.width, self.view.frame.size.height)];
        }else{
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, ScreenFrame.size.width, self.view.frame.size.height)];
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
        myWebView.delegate = self;
        myWebView.hidden = YES;
        [self.view addSubview:myWebView];
        if ([third.jie_order_goods_price floatValue]<=0) {
            myWebView.hidden = NO;
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@&order_type=integral",FIRST_URL,PAYOVER_URL,third.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
        }
        
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = balance_pay;
    [self createBackBtn];
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height;
}
-(void)disappear{
    [password resignFirstResponder];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
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
    bianhao = [[UILabel alloc]initWithFrame:CGRectMake(84, 20, 216, 21)];
    bianhao.textColor = MY_COLOR;
    bianhao.text = [NSString stringWithFormat:@"%@",th.ding_order_id];
    bianhao.font = [UIFont boldSystemFontOfSize:15];
    [cell addSubview:bianhao];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 56, 21)];
    label.text = @"订单号:";
    [cell addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 49, 86, 21)];
    label2.text = @"应付金额:";
    [cell addSubview:label2];
    jine = [[UILabel alloc]initWithFrame:CGRectMake(101, 49, 199, 21)];
    jine.textColor = MY_COLOR;
    
    jine.text = [NSString stringWithFormat:@"%@",th.jie_order_goods_price];
    jine.font = [UIFont boldSystemFontOfSize:15];
    [cell addSubview:jine];
    UILabel *_shuoming = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, ScreenFrame.size.width - 40, 24)];
    _shuoming.text = @"为了您的账号安全，请输入支付密码";
    _shuoming.textColor = [UIColor darkGrayColor];
    _shuoming.font = [UIFont boldSystemFontOfSize:13];
    [cell addSubview:_shuoming];
    password = [[UITextField alloc] initWithFrame:CGRectMake(20, 131, ScreenFrame.size.width - 40, 30)];
    password.placeholder = @"请输入支付密码";
    password.font = [UIFont systemFontOfSize:15];
    password.keyboardType = UIKeyboardTypeNumberPad;
    password.layer.borderWidth = 1;
    password.secureTextEntry = YES;
    password.layer.borderColor = [[UIColor grayColor] CGColor];
    password.backgroundColor=[UIColor whiteColor];
    [cell addSubview:password];
    
    paymoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paymoneyBtn.backgroundColor = MY_COLOR;
    [paymoneyBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    paymoneyBtn.frame = CGRectMake(ScreenFrame.size.width - 205, 179, 90, 30);
    paymoneyBtn.tag = 102;
    password.delegate = self;
    password.secureTextEntry = YES;
    [paymoneyBtn.layer setMasksToBounds:YES];
    [paymoneyBtn.layer setCornerRadius:4.0f];
    [paymoneyBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:paymoneyBtn];
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
    password = nil;
    paymoneyBtn= nil;
    _moneyPaymethod = nil;
    _moneyType = nil;
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
    password = nil;
    paymoneyBtn= nil;
    _moneyPaymethod = nil;
    _moneyType = nil;
    
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 100002) {
        PaySettingViewController *pa = [[PaySettingViewController alloc]init];
        [self.navigationController pushViewController:pa animated:YES];
    }
    if (btn.tag == 102) {
        [password resignFirstResponder];
        _moneyPaymethod = balance_pay;
        if (password.text.length ==0) {
            [SYObject failedPrompt:@"请输入支付密码"];
        }else{
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,YUCUNPAYYAN_URL]];
            request103=[ASIFormDataRequest requestWithURL:url3];
            
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request103 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request103 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request103 setPostValue:password.text forKey:@"password"];
            
            [request103 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request103.tag = 103;
            request103.delegate = self;
            [request103 setDidFailSelector:@selector(my1_urlRequestFailed:)];
            [request103 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
            [request103 startAsynchronous];
            
            
        }
    }
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
            buttonPass.frame =CGRectMake(ScreenFrame.size.width - 90, 173, 70, 18);
            buttonPass.backgroundColor = MY_COLOR;
            [buttonPass addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            buttonPass.tag = 100002;
            buttonPass.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            [buttonPass setTitle:@"设置支付密码" forState:UIControlStateNormal];
            [self.view addSubview:buttonPass];
            CALayer *lay3  = buttonPass.layer;
            [lay3 setMasksToBounds:YES];
            [lay3 setCornerRadius:4.0];
            [SYObject failedPrompt:@"设置支付密码后，才能完成付款"];
        }
    }
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
            if([funcStr isEqualToString:@"go_integral_order"])
            {
                myWebView.hidden = YES;
                _Mybool = YES;
                LoginViewController *log = [LoginViewController sharedUserDefault];
                
                log.return_oid = [arrFucnameAndParameter objectAtIndex:1];
                UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
                IntegralOrderDetail2ViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralOrderDetail2ViewController"];;
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
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100){
            pay_password = [dicBig objectForKey:@"pay_password"];
            paymoneyBtn.enabled = YES;
            buttonPass.hidden = YES;
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            bianhao.text = [NSString stringWithFormat:@"%@",th.ding_order_id];
            jine.text = [NSString stringWithFormat:@"￥%@",th.jie_order_goods_price];
        }
        else if([[dicBig objectForKey:@"code"] intValue] == -200){
            if ([self.title isEqualToString:after_pay]) {
                
            }else if([self.title isEqualToString:balance_pay]){
                [SYObject failedPrompt:@"用户信息错误"];
            }
            
        }
        else if([[dicBig objectForKey:@"code"] intValue] == -300){
            [OHAlertView showAlertWithTitle:@"重要提醒" message:@"您还没有设置支付密码，设置支付密码后才能使用预存款支付，确定去设置支付密码吗？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    PaySettingViewController *pay = [[PaySettingViewController alloc]init];
                    [self.navigationController pushViewController:pay animated:YES];
                }else{
                    buttonPass = [UIButton buttonWithType:UIButtonTypeCustom ];
                    buttonPass.frame =CGRectMake(ScreenFrame.size.width - 90, 173, 70, 18);
                    buttonPass.backgroundColor = MY_COLOR;
                    [buttonPass addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    buttonPass.tag = 100002;
                    buttonPass.titleLabel.font = [UIFont boldSystemFontOfSize:10];
                    [buttonPass setTitle:@"设置支付密码" forState:UIControlStateNormal];
                    [self.view addSubview:buttonPass];
                    CALayer *lay3  = buttonPass.layer;
                    [lay3 setMasksToBounds:YES];
                    [lay3 setCornerRadius:4.0];
                    [SYObject failedPrompt:@"设置支付密码后，才能完成付款"];
                }

            }];
        }
        else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [SYObject failedPrompt:@"参数错误"];
        }
    }
    
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig=%@",dicBig);
        if ([[dicBig objectForKey:VERIFY] intValue] == 1) {
            ThirdViewController *third = [ThirdViewController sharedUserDefault];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,integral_order_pay_URL]];
            request104=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request104 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request104 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request104 setPostValue:third.ding_hao forKey:@"order_id"];
            
            [request104 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request104.tag = 104;
            request104.delegate = self;
            [request104 setDidFailSelector:@selector(my2_urlRequestFailed:)];
            [request104 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
            [request104 startAsynchronous];
        }else{
            password.text = @"";
            [OHAlertView showAlertWithTitle:@"提示" message:@"支付失败,密码输入错误，请重试。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
            
        }
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
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
            
            onlinePayTypesIntegralViewController *on = [onlinePayTypesIntegralViewController sharedUserDefault];
            on.MyBool = YES;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@&order_type=integral",FIRST_URL,PAYOVER_URL,th.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
            myWebView.hidden = NO;
        }
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
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
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,th.ding_hao,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
            myWebView.hidden = NO;
        }
    }
    
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
