//
//  BecomeMemberTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/7/31.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "BecomeMemberTableViewController.h"
#import "BecomeMemberTableViewCell.h"
#import "InfoViewController.h"
#import "CurrentRankViewController.h"

@interface BecomeMemberTableViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}
@end

@implementation BecomeMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SYObject startLoading];

    // Do any additional setup after loading the view.
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-15)];
    
    webview.delegate=self;
    [self.view addSubview:webview];
    [self loadPage];
    [webview.scrollView addHeaderWithTarget:self action:@selector(loadwebPage)];

    
}
-(void)loadwebPage{
    [self loadPage];
}


-(void)loadPage{
    NSString *url=[NSString stringWithFormat:@"%@/wap/buyer/vip-privilege.htm",FIRST_URL];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SYObject endLoading];

    [webview.scrollView headerEndRefreshing];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webview.scrollView headerEndRefreshing];
    
}

//webview代理方法 实现点击webview后做跳转
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
     NSString *s= [[request URL] absoluteString];
    NSString *urlString = [s stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString===%@",urlString);
    //截取请求，进行判断，页面跳转
    if ([urlString containsString:@"vip_level_up.htm"]) {
        [self action2];//跳到升级页面
        return NO;
    }else if([urlString containsString:@"index.htm"]){
        [self action1];//跳到首页
        return NO;
        
    }
    
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)action1{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)action2{
   
    InfoViewController *vc=[[InfoViewController alloc ]init];
    vc.isScanRegister=_isScanRegister;
    vc.pushClass= NSStringFromClass([CurrentRankViewController class]);
    vc.pushtitle=@"VIP升级";
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
