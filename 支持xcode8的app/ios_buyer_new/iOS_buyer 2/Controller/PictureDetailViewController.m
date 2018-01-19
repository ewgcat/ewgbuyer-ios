//
//  PictureDetailViewController.m
//  My_App
//
//  Created by barney on 16/2/26.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "PictureDetailViewController.h"

@interface PictureDetailViewController ()<UIWebViewDelegate>

@end

@implementation PictureDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [SYObject startLoading];//加载遮罩
    self.tabBarController.tabBar.hidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
   self.tabBarController.tabBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
   
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//设置背景颜色
    self.title = @"图文详情";//界面标题
    self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
   [self createBackBtn];
    //设置webView网页
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    [self.view addSubview:webView];
    webView.delegate=self;//设置代理
   // 加载网页的url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_PICTURE_URL,self.ID];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];//网页加载
    
}
//webView加载完成后的代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SYObject endLoading];//遮罩停止加载
    
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
