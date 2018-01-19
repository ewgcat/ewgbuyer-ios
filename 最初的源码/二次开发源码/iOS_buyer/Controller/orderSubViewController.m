//
//  orderSubViewController.m
//  My_App
//
//  Created by apple on 15-1-22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "orderSubViewController.h"
#import "PhysicalOrderViewController2.h"
#import "buyer_returnViewController.h"
#import "myzeroViewController.h"
#import "IntegralExchangeViewController.h"
#import "GroupOrdListViewController.h"
#import "returnMoneyViewController.h"

@interface orderSubViewController ()

@end

@implementation orderSubViewController

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    // Do any additional setup after loading the view.
    self.title = @"订单管理";
    [self createBackBtn];
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

- (IBAction)goodsOrder:(id)sender {
    PhysicalOrderViewController2 *oooo = [[PhysicalOrderViewController2 alloc]init];
    [self.navigationController pushViewController:oooo animated:YES];
}

- (IBAction)integralOrder:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    IntegralExchangeViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];;
    [self.navigationController pushViewController:ordrt animated:YES];
}

- (IBAction)lifeOrder:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    GroupOrdListViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"GroupOrdListViewController"];;
    [self.navigationController pushViewController:ordrt animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)freeOrder:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    myzeroViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"myzeroViewController"];;
    [self.navigationController pushViewController:ordrt animated:YES];
}

- (IBAction)returnGoods:(id)sender {
    buyer_returnViewController *oooo = [[buyer_returnViewController alloc]init];
    [self.navigationController pushViewController:oooo animated:YES];
}

- (IBAction)returnmoneyOrder:(id)sender {
    returnMoneyViewController *ret = [[returnMoneyViewController alloc]init];
    [self.navigationController pushViewController:ret animated:YES];
}
@end
