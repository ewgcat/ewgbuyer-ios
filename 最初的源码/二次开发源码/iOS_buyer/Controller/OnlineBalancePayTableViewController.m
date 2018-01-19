//
//  OnlineBalancePayTableViewController.m
//  My_App
//  在线付款\预付款支付
//  Created by shiyuwudi on 15/12/7.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "OnlineBalancePayTableViewController.h"
#import "OrderListViewController.h"
#import "ThirdViewController.h"
#import "LoginViewController.h"
#import "SYOrderDetailsModel.h"
#import "UserInfoModel.h"
#import "AFNetworkTool.h"
#import "IntegralExchangeViewController.h"

//#import "PaySuccessViewController.h"

@interface OnlineBalancePayTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalSum;
@property (copy, nonatomic) NSString *orderID;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong,nonatomic)SYOrderDetailsModel *orderDetailsModel;
@property (copy, nonatomic)NSString *groupOrderID;
@property (assign, nonatomic)BOOL touchPay;

@end

@implementation OnlineBalancePayTableViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBtn];
    [self setupUI];
    [self checkTouchID];
    [self netRequest];
    [self getOrderDetails];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"预付款支付";
    
    self.payBtn.layer.cornerRadius = 5.f;
    [self.payBtn.layer setMasksToBounds:YES];
    self.password.delegate=self;
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    self.orderNum.text = third.ding_hao;
    self.orderTotalSum.text = [NSString stringWithFormat:@"￥%.2f",[third.jie_order_goods_price floatValue]];
    self.orderTotalSum.textColor=UIColorFromRGB(0xf15353);
    self.orderID = third.ding_order_id;
}
-(void)checkTouchID {
    if ([SYShopAccessTool localPassword]) {
        [self finger];
    }
}
//验证指纹
-(void)finger {
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"";
    NSString *reasonStr = @"需要验证指纹才能进一步操作";
    NSError *err;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonStr reply:^(BOOL success, NSError * _Nullable evalPolicyError) {
            if (success) {
                NSLog(@"授权成功");
                //把预先保存的密码发送给服务器
                self.password.text = [SYShopAccessTool localPassword];
                [self payBtnClicked:nil];
            }else {
                switch (evalPolicyError.code) {
                    case LAErrorSystemCancel:{
                        [SYObject failedPrompt:@"系统取消授权"];
                        break;
                    }
                    case LAErrorUserCancel:{
                        [SYObject failedPrompt:@"用户取消授权"];
                        break;
                    }
                    default:{
                        [SYObject failedPrompt:@"授权失败"];
                        break;
                    }
                }
            }
        }];
    } else {
        NSString *str = @"";
        switch (err.code) {
            case LAErrorTouchIDNotEnrolled:{
                str = @"没有注册指纹";
                break;
            }
            case LAErrorPasscodeNotSet:{
                str = @"没有注册指纹验证码";
                break;
            }
            default:
                //LAErrorTouchIDNotAvailable
                str = @"指纹识别不可用";
        }
        [SYObject failedPrompt:str];
    }
}
-(void)getOrderDetails{
    [SYShopAccessTool orderDetailsByOrderID:self.orderID s:^(SYOrderDetailsModel *model) {
        self.orderDetailsModel = model;
    } failure:^(NSString *errStr) {
        [SYObject endLoading];
        [SYObject failedPrompt:errStr];
    }];
}
-(void)netRequest{
    [SYShopAccessTool currentUserDetails:^(UserInfoModel *model) {
        self.balance.text = [NSString stringWithFormat:@"￥%.2f",[model.balance floatValue]];
    } failure:nil];
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
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 支付失败
-(void)handleErr:(NSString *)errStr {
    if ([errStr isEqualToString: @"支付密码错误!"] && self.touchPay) {
        [SYObject failedPrompt:@"支付密码更改,请重新绑定指纹"];
        [SYShopAccessTool clearTouchIDInfo];
    } else {
        [SYObject failedPrompt:errStr];
        [SYObject endLoading];
    }
}
#pragma mark - 点击付款按钮
- (IBAction)payBtnClicked:(id)sender {
    if (sender) {
        self.touchPay = false;
    } else {
        self.touchPay = true;
    }
    [SYObject startLoading];
    NSString *pswd = self.password.text;
    if (!pswd || [pswd isEqualToString:@""]) {
        [SYObject endLoading];
        [SYObject failedPrompt:@"请输入支付密码!"];
        return;
    }
    [self.view endEditing:YES];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    SYOrderDetailsModel *odModel = th.order_details_model;
    //这个请求可以同时检测密码和完成支付
    if ([_orderType isEqualToString:@"cloudpurchase"]) {
        [SYShopAccessTool cloudPurchase:pswd orderID:th.ding_order_id  ofBalancePay:^(BOOL valid) {
            if (valid){
                //支付成功1秒后跳转个人订单页
                [SYObject endLoading];
                [SYObject failedPrompt:@"支付成功!"];
                NSString *nameNphone = [NSString stringWithFormat:@"%@ %@",_orderDetailsModel.order_username,_orderDetailsModel.order_mobile];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SYObject redirectPurchaseOfCloud:self.navigationController nameNphone:nameNphone address:_orderDetailsModel.order_address realprice:th.jie_order_goods_price];
                });
            } 
        } failure:^(NSString *errStr) {
            [self handleErr:errStr];
        }];
        //积分商品
    }else if ([_orderType isEqualToString:@"integral"]) {
        [SYShopAccessTool checkIntegral:pswd orderID:th.ding_order_id  ofBalancePay:^(BOOL valid) {
            if (valid){
                //支付成功1秒后跳转个人订单页
                [SYObject endLoading];
                [SYObject failedPrompt:@"支付成功!" complete:^{
                    
//                    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
//                    IntegralExchangeViewController *ievc = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];
//                    [self.navigationController pushViewController:ievc animated:YES];
                    
                    NSDictionary *dict = @{@"orderID":th.ding_order_id,@"orderNum":th.ding_hao,@"price":th.jie_order_goods_price};
//                    [SYObject redirectAfterPayment:self.navigationController orderNum:dict];
                    [SYObject redirectAfterPayment:self.navigationController orderNum:dict orderType:@"integral"];

                    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
                    [arr removeObjectAtIndex:(arr.count - 2)];
                    [arr removeObjectAtIndex:(arr.count - 2)];
                    [arr removeObjectAtIndex:(arr.count - 2)];
                    self.navigationController.viewControllers = arr;
                }];
            }
        } failure:^(NSString *errStr) {
            [self handleErr:errStr];
        }];
        
    }else{
        [SYShopAccessTool checkPassword:pswd orderID:th.ding_order_id ofBalancePay:^(BOOL valid) {
            if (valid){
                //支付成功1秒后跳转个人订单页
                [SYObject endLoading];
                [SYObject failedPrompt:@"支付成功!"];
                NSString *nameNphone = [NSString stringWithFormat:@"%@ %@",_orderDetailsModel.order_username,_orderDetailsModel.order_mobile];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (self.group) {
                        if (self.group1==YES){// 个人中心生活惠
                            NSDictionary *dict = @{@"orderNum":th.ding_hao,@"orderID":th.ding_order_id,@"oid":th.ding_order_id,@"price":th.jie_order_goods_price};
                            [SYObject redirectAfterPayment:self.navigationController orderNum:dict];
                        }else{
                            //首页团购订单
                            NSDictionary *dict = @{@"orderNum":odModel.order_num,@"orderID":th.ding_order_id,@"oid":self.oid,@"price":odModel.order_price4};
                            [SYObject redirectAfterPayment:self.navigationController orderNum:dict];
                        }
                    }else{
                        //普通商品订单
//                        [SYObject redirectAfterPayment:self.navigationController nameNphone:nameNphone address:_orderDetailsModel.order_address realprice:_orderDetailsModel.order_price4];
                        [SYObject redirectAfterPayment:self.navigationController nameNphone:nameNphone address:_orderDetailsModel.order_address realprice:th.jie_order_goods_price];
                    }
                });
            }
        } failure:^(NSString *errStr) {
            [self handleErr:errStr];
        }];
    }
    
    
}
@end
