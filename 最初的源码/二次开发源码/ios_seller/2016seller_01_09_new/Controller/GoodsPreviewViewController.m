//
//  GoodsPreviewViewController.m
//  2016seller_01_09_new
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "GoodsPreviewViewController.h"

@interface GoodsPreviewViewController ()<UIWebViewDelegate>
{
    UIWebView *_webview;
}

@end

@implementation GoodsPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBackBtn];
    [self designPage];
}
-(void)createBackBtn{
    self.title=@"商品详情";
}
-(void)designPage {
    _webview =[[ UIWebView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height+50)];
    _webview.backgroundColor=[UIColor whiteColor];
    [ _webview setUserInteractionEnabled:YES ];  //是否支持交互
    [ _webview setDelegate: self ];  //委托
    [ _webview setOpaque: NO ];  //透明
    [ self.view  addSubview : _webview];
    if (self.staticID.length>0) {
         NSString *urlstr=[NSString stringWithFormat:@"%@%@?id=%@",SELLER_URL,GOODSPREVIEW_URL,self.staticID];
        NSURL *url = [[ NSURL alloc ] initWithString :urlstr];
        [ _webview loadRequest:[ NSURLRequest requestWithURL: url ]];
    }else
    {
        NSString *urlstr=[NSString stringWithFormat:@"%@%@?id=%@",SELLER_URL,GOODSPREVIEW_URL,_model.goods_id];
        NSURL *url = [[ NSURL alloc ] initWithString :urlstr];
        [ _webview loadRequest:[ NSURLRequest requestWithURL: url ]];
    }
   
}
#pragma mark -UIWebViewDelegate
//当网页视图已经开始加载一个请求之后得到通知
- (void) webViewDidStartLoad:(UIWebView  *)webView {
    [MyObject startLoading];

}
//当网页视图结束加载一个请求之后得到通知
- (void) webViewDidFinishLoad:(UIWebView *)webView{
    [MyObject endLoading];
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
