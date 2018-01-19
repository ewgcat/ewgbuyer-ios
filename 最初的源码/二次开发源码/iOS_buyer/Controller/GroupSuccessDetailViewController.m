//
//  GroupSuccessDetailViewController.m
//  My_App
//
//  Created by barney on 15/12/16.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupSuccessDetailViewController.h"

@interface GroupSuccessDetailViewController ()

@end

@implementation GroupSuccessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"订单详情";
    [self createBackBtn];
    self.orderStatus.text=self.orderSta;
    self.orderID.text=self.orderId;
    self.addTime.text=self.time;
    self.payType.text=self.type;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
