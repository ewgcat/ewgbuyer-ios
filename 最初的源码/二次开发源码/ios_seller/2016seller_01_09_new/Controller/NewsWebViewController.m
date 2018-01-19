//
//  NewsWebViewController.m
//  SellerApp
//
//  Created by barney on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewsWebViewController.h"

@interface NewsWebViewController ()<UIWebViewDelegate>

@end

@implementation NewsWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MyObject startLoading];//加载遮罩
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//设置背景颜色
    self.title = @"公告详情";//界面标题
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    //设置webView网页
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    [self.view addSubview:webView];
    webView.delegate=self;//设置代理
    //加载网页的url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?article_id=%@",SELLER_URL,NEWS_WEB_URL,self.list.article_id];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];//网页加载
    
    

}
//webView加载完成后的代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
  [MyObject endLoading];//遮罩停止加载

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
