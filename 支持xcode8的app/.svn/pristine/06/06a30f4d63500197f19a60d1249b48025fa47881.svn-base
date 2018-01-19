//
//  CashOnDeliveryViewController.m
//  My_App
//
//  Created by apple on 15-2-2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CashOnDeliveryViewController.h"
#import "ThirdViewController.h"
#import "OrderDetailsViewController2.h"
#import "onlinePayTypesIntegralViewController.h"
#import "LoginViewController.h"

@interface CashOnDeliveryViewController ()

@end

static CashOnDeliveryViewController *singleInstance=nil;

@implementation CashOnDeliveryViewController

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
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [request101 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (myBool == NO) {
        
    }else{
        myBool = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = after_pay;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self createBackBtn];
    
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    self.lblOrderNum.text = [NSString stringWithFormat:@"%@",th.ding_hao];
    self.lblOrderPrice.text = [NSString stringWithFormat:@"￥%@",th.jie_order_goods_price];
    self.payPassField.delegate = self;
    
    [_sureBtn.layer setMasksToBounds:YES];
    [_sureBtn.layer setCornerRadius:6.0f];
    [_sureBtn addTarget:self action:@selector(btnSubmit) forControlEvents:UIControlEventTouchUpInside];
    
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
    bottomView.hidden = NO;
    [self.view addSubview:myWebView];
    if ([third.jie_order_goods_price floatValue]<=0) {
        myWebView.hidden = NO;
        bottomView.hidden = YES;
        NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@&order_type=integral",FIRST_URL,PAYOVER_URL,third.ding_order_id,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
        NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
        [myWebView loadRequest:requestweb];
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
//立即付款按钮被点击
-(void)btnSubmit{
    [SYObject startLoading];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, PAYAFTER_URL]];
    request101 = [ASIFormDataRequest requestWithURL:url];
    
    [request101 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request101 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request101 setPostValue:th.ding_order_id forKey:@"order_id"];
    [request101 setPostValue:_payPassField.text forKey:@"pay_msg"];
    
    [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request101.delegate = self;
    [request101 setDidFailSelector:@selector(urlRequestFailed:)];
    [request101 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request101 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dibBig3-->>%@",dicBig);
        NSString *code = [dicBig objectForKey:@"code"];
        if (code.intValue == 100) {
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?type=ios&order_id=%@&user_id=%@&token=%@",FIRST_URL,PAYOVER_URL,th.ding_order_id,[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1]]];
            NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
            [myWebView loadRequest:requestweb];
            myWebView.hidden = NO;
            bottomView.hidden = YES;
            
            
        }
        if (code.intValue == -100) {
            [SYObject failedPrompt:@"用户信息错误!"];
        }
        if (code.intValue == -200) {
            [SYObject failedPrompt:@"订单信息错误!"];
        }
        if (code.intValue == -300) {
            [SYObject failedPrompt:@"订单支付方式信息错误!"];
        }
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
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
                bottomView.hidden = NO;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_payPassField resignFirstResponder];
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

@end
