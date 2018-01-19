//
//  AgreeViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/7/6.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "AgreeViewController.h"
#import "InfoViewController.h"
@interface AgreeViewController ()

@end

@implementation AgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(15, 30, 15, 23.5);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    [view addSubview:button];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"e会员协议";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    

    
    //请求加载webView
 UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height - 64)];
    //webView.center = CGPointMake(ScreenFrame.size.width/2, 270);
    webView.scalesPageToFit = YES;
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/vip_join_doc.htm"]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
    [self.view addSubview:webView];
    [webView loadRequest:requestweb];
}
-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];

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
