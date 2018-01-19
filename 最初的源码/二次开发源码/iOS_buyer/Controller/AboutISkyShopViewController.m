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
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];

    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
