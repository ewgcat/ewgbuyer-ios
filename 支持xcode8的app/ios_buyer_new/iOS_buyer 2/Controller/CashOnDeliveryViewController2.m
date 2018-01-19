//
//  CashOnDeliveryViewController2.m
//  My_App
//
//  Created by shiyuwudi on 15/12/8.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "CashOnDeliveryViewController2.h"
#import "OrderListViewController.h"
#import "LoginViewController.h"
#import "SYOrderDetailsModel.h"


@interface CashOnDeliveryViewController2 ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *deliverDetailsTF;
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;
@property (weak, nonatomic) IBOutlet UIView *aboveView;
@property (strong,nonatomic)SYOrderDetailsModel *orderDetailsModel;

@end

@implementation CashOnDeliveryViewController2

#pragma mark - 生命周期方法
-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBtn];
    [self setupUI];
    [self getOrderDetails];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"货到付款信息填写";
    self.orderNumLabel.text = self.orderNum;
    self.orderNumLabel.textColor=[UIColor blackColor];
    self.realPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.realPrice];
    [self.payNowBtn addTarget:self action:@selector(payNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.deliverDetailsTF.delegate=self;
    self.payNowBtn.layer.cornerRadius = 5.f;
    [self.payNowBtn.layer setMasksToBounds:YES];
}
-(void)getOrderDetails{
    [SYShopAccessTool orderDetailsByOrderID:self.orderID s:^(SYOrderDetailsModel *model) {
        self.orderDetailsModel = model;
    } failure:^(NSString *errStr) {
        [SYObject failedPrompt:errStr];
    }];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self.deliverDetailsTF resignFirstResponder];
    return YES;
}
#pragma mark - 点击方法
-(IBAction)payNowBtnClicked:(id)sender{
    NSString *msg = self.deliverDetailsTF.text;
    if (self.orderDetailsModel==nil) {
        [SYObject failedPrompt:@"正与服务器沟通..."];
        return;
    }
    [self.view endEditing:YES];
    [SYObject startLoading];
    [SYShopAccessTool payAfterWithOrderID:self.orderID message:msg s:^(BOOL success) {
        [SYObject endLoading];
        if (success) {
            
            //货到付款申请成功,跳转订单列表页
            [SYObject failedPrompt:@"下单成功!"];
            NSString *nameNphone = [NSString stringWithFormat:@"%@ %@",_orderDetailsModel.order_username,_orderDetailsModel.order_mobile];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [SYObject redirectAfterPayOnDel:self.navigationController nameNphone:nameNphone address:_orderDetailsModel.order_address realprice:self.realPriceLabel.text];
            });
        }
    } failure:^(NSString *errStr) {
        [SYObject endLoading];
        [SYObject failedPrompt:errStr];
    }];
}
@end
