//
//  IndexNewsViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/8/31.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "IndexNewsViewController.h"
#import <WebKit/WebKit.h>
@interface IndexNewsViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    
}
@end

@implementation IndexNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    webview.delegate=self;
    [self.view addSubview:webview];
    [self loadPage];
    [webview.scrollView addHeaderWithTarget:self action:@selector(loadwebPage)];
    [SYObject startLoading];
}


-(void)loadwebPage{
    [self loadPage];
}


-(void)loadPage{
    NSString *url=[NSString stringWithFormat:@"%@%@",FIRST_URL,_urlString];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webview.scrollView headerEndRefreshing];
    [SYObject endLoading];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webview.scrollView headerEndRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
