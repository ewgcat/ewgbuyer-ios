//
//  NotifWebViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/12/21.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "NotifWebViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "getActivityGoodsViewController.h"
#import "getAllActivityNavViewController.h"
#import "Seconde_sub2ViewController.h"
#import "BrandGoodListViewController.h"
#import "ExchangeHomeViewController.h"
#import "IntegraDetialViewController.h"
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
    webView.frame = CGRectMake(0, 0, ScreenFrame.size.width,  ScreenFrame.size.height-10);
    [self.view addSubview:webView];

    [webView.scrollView addHeaderWithTarget:self action:@selector(loadwebPage)];

}
-(void)loadwebPage{
    [self handleRequest];
}

-(void)handleRequest{
    if (self.request) {
        [SYObject startLoading];
        [self.webView loadRequest:self.request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView.scrollView headerEndRefreshing];
    [SYObject endLoading];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView.scrollView headerEndRefreshing];
    [SYObject endLoading];

    
}
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//
//    NSLog(@"----%@",[webView stringByEvaluatingJavaScriptFromString:lJs]);
//    NSLog(@"----%zd",[[webView stringByEvaluatingJavaScriptFromString:lJs] length]);
//
//    [SYObject endLoading];
//}
//webview代理方法 实现点击webview后做跳转
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    
    
    
    [SYObject endLoading];

    NSString *s= [[request URL] absoluteString];
    NSString *urlString = [s stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    NSLog(@"urlCompsurlComps:%@",urlComps);
    NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
    
    
    NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
    NSLog(@"funcStr:%@",arrFucnameAndParameter);
    //去到商品详情界面
    if ([funcStr isEqualToString:@"gotoGoods"]) {
        
        SecondViewController * sec=[SecondViewController sharedUserDefault];
        //        detail.detail_id=arrFucnameAndParameter[1];
        sec.detail_id=arrFucnameAndParameter[1];
        DetailViewController *detail = [[DetailViewController alloc]init];
        detail.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:detail animated:YES];
        return NO;
    }
    //去到活动页面
    else if ([funcStr isEqualToString:@"gotoActivity"]) {
        
        
        NSArray *arr= [arrFucnameAndParameter[1] componentsSeparatedByString:@"|"];
        
        getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
        all.classifyModel=[[ClassifyModel alloc]init];

        all.classifyModel.goods_id=arr[0];
        all.classifyModel.coupon_name=arr[1];

        getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
        get.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:get animated:YES];
        return NO;
    }
    else if([funcStr isEqualToString:@"gotoGoodsClass"]){
        
        
        SecondViewController *thire = [SecondViewController sharedUserDefault];
        NSArray *arr= [arrFucnameAndParameter[1] componentsSeparatedByString:@"|"];
        thire.sub_id2=arr[0];
        thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        Seconde_sub2ViewController *vc=[[Seconde_sub2ViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:vc animated:YES];
        return NO;
        
        
    }else if([funcStr isEqualToString:@"gotoGoodsBrand"]){
        
        SecondViewController *thire = [SecondViewController sharedUserDefault];
        
        
        
        NSArray *arr= [arrFucnameAndParameter[1] componentsSeparatedByString:@"|"];
        thire.sub_id2=arr[0];
        thire.sub_title2=[arr[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        BrandGoodListViewController *secddd = [[BrandGoodListViewController alloc]init];
        secddd.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:secddd animated:YES];
        return NO;
        
        
    }else if([funcStr isEqualToString:@"gotoIntegral"]){
        
        ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
        NSArray *arr= [arrFucnameAndParameter[1] componentsSeparatedByString:@"|"];
        exc.ig_id =arr[0];
        
        
        
        IntegraDetialViewController *integraDetialVC = [[IntegraDetialViewController alloc]init];
        integraDetialVC.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:integraDetialVC animated:YES];
        return NO;
        
    }

    
    return YES;
    
}
@end
