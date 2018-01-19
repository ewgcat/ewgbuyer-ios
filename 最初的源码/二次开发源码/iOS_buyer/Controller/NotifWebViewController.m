//
//  NotifWebViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/12/21.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "NotifWebViewController.h"

@interface NotifWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NotifWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self handleRequest];
    [self createBackBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
-(void)setupUI{
//    self.title = @"推送网页";
    
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    webView.delegate = self;
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
}
-(void)handleRequest{
    if (self.request) {
        [SYObject startLoading];
        [self.webView loadRequest:self.request];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SYObject endLoading];
}

@end
