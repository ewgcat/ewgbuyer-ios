//
//  forgetViewController.m
//  My_App
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "forgetViewController.h"

@interface forgetViewController ()

@end

@implementation forgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回密码";
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FORGET_URL]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
    [myWebview loadRequest:requestweb];
    myWebview.delegate = self;
    myWebview.scrollView.delegate = self;
    [self createBackBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    myWebview.delegate = nil;
}
#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SYObject endLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SYObject endLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网页加载出错"];
}
#pragma mark - UI搭构
//创建返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;

}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
//webview代理方法 实现点击webview后做跳转
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    NSLog(@"urlCompsurlComps:%@",urlComps);
    NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
    
    NSString *funcStr = [arrFucnameAndParameter objectAtIndex:2];
    NSLog(@"funcStr:%@",arrFucnameAndParameter);
    if (3 == [arrFucnameAndParameter count])
    {
        if ([funcStr isEqualToString:@"forget4.htm"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    return YES;
}

@end
