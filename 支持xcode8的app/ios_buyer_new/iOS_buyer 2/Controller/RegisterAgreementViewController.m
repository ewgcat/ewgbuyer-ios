//
//  RegisterAgreementViewController.m
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "RegisterAgreementViewController.h"

@interface RegisterAgreementViewController ()

@end

@implementation RegisterAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册协议";
        // Custom initialization
    }
    return self;
}

-(void)backBtnClicked{
    webView.delegate = nil;
    webView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(15, 30, 15, 23.5);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    [view addSubview:button];
    
//    UIButton *button = [LJControl backBtn];
//    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem =bar;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"注册协议";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    //请求加载webView
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height - 64)];
    //webView.center = CGPointMake(ScreenFrame.size.width/2, 270);
    webView.scalesPageToFit = YES;
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGISTERAGREE_URL]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:requestweb];

    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SYObject endLoading];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

@end
