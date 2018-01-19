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
    _canPayMoneyTF.delegate=self;
    _canPayMoneyTF.keyboardType=UIKeyboardTypeNumberPad;
    
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, 0, 20, _canPayMoneyTF.frame.size.height)];
    leftLabel.text=@" ¥";
    _canPayMoneyTF.leftViewMode=UITextFieldViewModeAlways;
    _canPayMoneyTF.leftView=leftLabel;
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
        ThirdViewController *third = [ThirdViewController sharedUserDefault];
        float price= [third.jie_order_goods_price floatValue];
        if ([model.balance floatValue]>=price) {//如果预存款金额>=价格，那么直接全部付完订单价格
            self.canPayMoneyTF.text=[NSString stringWithFormat:@"%.2f",price];
        }else{
            self.canPayMoneyTF.text=[NSString stringWithFormat:@"%.2f",[model.balance floatValue]];

        
        }
    } failure:nil];
}
#pragma mark UITextField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _canPayMoneyTF) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
    }
    
    return YES;
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
    
    
#pragma mark - 这里判断一下可支付金额是否小于或者是等于订单金额
    ThirdViewController *third = [ThirdViewController sharedUserDefault];

    float price= [third.jie_order_goods_price floatValue];

    if (_canPayMoneyTF.text.floatValue>price) {
        [SYObject endLoading];

        [SYObject failedPrompt:@"支付金额不可以大于订单金额"];
        return;

    }
    
    if (_payStyleArr.count==1) {//如果不选择混合支付，且支付金额小于订单金额
        if (_canPayMoneyTF.text.floatValue<price) {
            [SYObject endLoading];
            
            UIAlertController *vc=[UIAlertController alertControllerWithTitle:@"提示" message:@"支付金额小于订单金额，建议选择混合支付" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [vc addAction:action];
            [self presentViewController:vc animated:YES completion:nil];
            return;
        }
    }
   
//
    
    
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
        [SYShopAccessTool cloudPurchase:pswd orderID:th.ding_order_id andOtherPar:nil ofBalancePay:^(BOOL valid) {
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
        
        
        NSMutableDictionary *dic=@{@"balance_pay":_canPayMoneyTF.text}.mutableCopy;
        
        
        if ([_payStyleArr containsObject:weixin_mark]) {
            [dic addEntriesFromDictionary:@{@"pay_type_radio":@"wx_pay"} ];
            
        }else if ([_payStyleArr containsObject:online_mark]){
            [dic addEntriesFromDictionary: @{@"pay_type_radio":@"ali_pay"}];
            
        }
        
        
        [SYShopAccessTool checkIntegral:pswd orderID:th.ding_order_id andOtherPar:dic  ofBalancePay:^(BOOL valid) {
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
        NSMutableDictionary *dic=@{@"balance_pay":_canPayMoneyTF.text}.mutableCopy;
  
            
        if ([_payStyleArr containsObject:weixin_mark]) {
            [dic addEntriesFromDictionary:@{@"pay_type_radio":@"wx_pay"} ];

        }else if ([_payStyleArr containsObject:online_mark]){
           [dic addEntriesFromDictionary: @{@"pay_type_radio":@"ali_pay"}];

        }
//        unionpay_mark 银联支付
        [SYShopAccessTool checkPassword:pswd orderID:th.ding_order_id  andOtherPar:dic ofBalancePay:^(BOOL valid) {
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
            
            NSLog(@"errStrerrStr==%@",errStr);
        }];
    }
    
    
}
@end
