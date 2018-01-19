//
//  DeliverySettingViewController.m
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/15.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "DeliverySettingViewController.h"
#import "CommonLogisticsViewController.h"
#import "ShippingInfoViewController.h"

@interface DeliverySettingViewController ()

@end

@implementation DeliverySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发货设置";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)commonLogistic:(id)sender {
    //常用物流 CommonLogistics
    CommonLogisticsViewController *clVC = [[UIStoryboard storyboardWithName:@"WorkBench" bundle:nil]instantiateViewControllerWithIdentifier:@"CommonLogistics"];
    [self.navigationController pushViewController:clVC animated:YES];
}
- (IBAction)delAddress:(id)sender {
    //发货地址 shippinginfo
    ShippingInfoViewController *siVC = [[UIStoryboard storyboardWithName:@"WorkBench" bundle:nil]instantiateViewControllerWithIdentifier:@"shippinginfo"];
    [self.navigationController pushViewController:siVC animated:YES];
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
