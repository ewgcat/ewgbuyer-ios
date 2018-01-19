//
//  AboutISkyShopViewController.m
//  My_App
//
//  Created by apple on 14-8-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "AboutISkyShopViewController.h"

@interface AboutISkyShopViewController ()

@end

@implementation AboutISkyShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于";
        self.view.backgroundColor = [UIColor whiteColor];
        // Custom initialization
    }
    return self;
}
-(void)createBackBtn{
//    UIButton *button = [LJControl backBtn];
//    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-100, ScreenFrame.size.width, 20)];
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.text=[NSString stringWithFormat:@"当前版本:%@",app_Version];
    showLabel.textColor=[UIColor lightGrayColor];
//    showLabel.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:showLabel];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
