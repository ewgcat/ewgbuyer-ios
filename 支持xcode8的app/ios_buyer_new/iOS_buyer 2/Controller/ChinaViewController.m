//
//  ChinaViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/14.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ChinaViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "getActivityGoodsViewController.h"
#import "getAllActivityNavViewController.h"
#import "Seconde_sub2ViewController.h"
#import "BrandGoodListViewController.h"
#import "ExchangeHomeViewController.h"
#import "IntegraDetialViewController.h"
#import "ClassifyModel.h"
@interface ChinaViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}
@end

@implementation ChinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];

    webview.delegate=self;
    [self.view addSubview:webview];
    [self loadPage];
    [webview.scrollView addHeaderWithTarget:self action:@selector(loadwebPage)];
    
}
-(void)loadwebPage{
    [self loadPage];
}


-(void)loadPage{
    NSString *url=[NSString stringWithFormat:@"%@/app/topics_1.htm?device_type=iOS",FIRST_URL];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webview.scrollView headerEndRefreshing];
   
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webview.scrollView headerEndRefreshing];
    
}
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//    NSLog(@"===%@",[webView stringByEvaluatingJavaScriptFromString:lJs]);
//    NSLog(@"----%zd",[[webView stringByEvaluatingJavaScriptFromString:lJs] length]);
//
//
//}
//webview代理方法 实现点击webview后做跳转
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
 



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
