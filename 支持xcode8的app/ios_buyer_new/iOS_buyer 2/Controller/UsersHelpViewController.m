//
//  UsersHelpViewController.m
//  My_App
//
//  Created by apple on 14-8-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UsersHelpViewController.h"

@interface UsersHelpViewController ()

@end

@implementation UsersHelpViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"使用帮助";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    
    myWebView.scalesPageToFit = YES;
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,HELPME_URL]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url2];
    [myWebView loadRequest:requestweb];
    myWebView.delegate = self;
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [myWebView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SYObject endLoading];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    myWebView.delegate = nil;
    myWebView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
