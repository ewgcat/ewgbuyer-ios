//
//  AccountSafetyController.m
//  My_App
//
//  Created by barney on 15/11/19.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "AccountSafetyController.h"
#import "SetLogPassViewController.h"
#import "PaySettingViewController.h"
#import "BundlingViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AccountSafetyController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *payPassword;
@property (weak, nonatomic) IBOutlet UIButton *phoneVerify;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *touchIDView;

@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;


@end

@implementation AccountSafetyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账户安全";
    [self createBackBtn];
    self.loginPassword.tag=101;
    self.payPassword.tag=102;
    self.phoneVerify.tag=103;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

    [self checkTouchIDSupport];
    
    //判断指纹支付是否开启
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![[def valueForKey:kTouchIDDefaulskey]isEqualToString:@"yes"]){
        self.touchIDSwitch.on = false;
    } else {
        self.touchIDSwitch.on = true;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)checkTouchIDSupport {
    NSError *err = nil;
    if(![[LAContext new] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]){
        if (err.code == LAErrorTouchIDNotAvailable) {
            //指纹识别不可用时直接隐藏该行
            [self hideTouchIDChoice];
        }
    }
}
-(void)hideTouchIDChoice {
    for (UIView *view in self.touchIDView) {
        view.hidden  = YES;
    }
}
- (IBAction)switchChanged:(id)sender {
    
    UISwitch *swit = sender;
    
    if (swit.isOn) {
        swit.on = false;
        //关闭->打开(验证支付密码)
        [self finger];
        
    } else {
        //打开->关闭(取消绑定)
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:kTouchIDDefaulskey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kTouchIDSavedPasswordKey];
        [self failedPrompt:@"已取消绑定"];
    }
}

-(void)finger {
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"";
    NSString *reasonStr = @"需要验证指纹才能进一步操作";
    NSError *err;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonStr reply:^(BOOL success, NSError * _Nullable evalPolicyError) {
            if (success) {
                NSLog(@"授权成功");
                //开始绑定
                [self bind];
            }else {
                switch (evalPolicyError.code) {
                    case LAErrorSystemCancel:{
                        [self failedPrompt:@"系统取消授权"];
                        break;
                    }
                    case LAErrorUserCancel:{
                        [self failedPrompt:@"用户取消授权"];
                        break;
                    }
                    default:{
                        [self failedPrompt:@"授权失败"];
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
        [self failedPrompt:str];
    }
}
-(void)failedPrompt:(NSString *)prompt {
    [SYObject failedPrompt:prompt];
}
-(void)bind {
    //这里开始是后台线程！！
    
    //验证是否设置支付密码
    [Requester loginPostWithLastURL:PAY_PASSWORD_CHECK_URL par:nil description:@"检查支付密码" success:^(NSDictionary *dict) {
        NSString *code = dict[@"code"];
        if (code.intValue != 100) {
            //引导设置支付密码
            [OHAlertView showAlertWithTitle:@"您还未设置支付密码！" message:@"是否去设置？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    PaySettingViewController *pay = [[PaySettingViewController alloc]init];
                    [self.navigationController pushViewController:pay animated:YES];
                }
            }];
        } else {
            //已经设置支付密码->弹框输入支付密码
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"输入支付密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.secureTextEntry = YES;
            }];
            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *tf = ac.textFields.firstObject;
                NSDictionary *par = @{
                                      @"user_id":[SYObject currentUserID],
                                      @"password":tf.text
                                      };
                //提交服务器验证
                [Requester loginPostWithLastURL:kTouchIDVerifyURL par:par description:@"验证touch ID" success:^(NSDictionary *dict) {
                    int code = [dict[@"code"]intValue];
                    if (code == 100) {
                        //验证成功->绑定成功
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self failedPrompt:@"开启成功"];
                            [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:kTouchIDDefaulskey];
                            [[NSUserDefaults standardUserDefaults]setValue:tf.text forKey:kTouchIDSavedPasswordKey];
                            self.touchIDSwitch.on = true;
                        });
                        
                    } else {
                        //验证失败
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self failedPrompt:@"支付密码错误"];
                        });
                        
                    }
                }];
            }]];
            [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];
}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
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
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==101)
    {
        // 密码修改
        SetLogPassViewController *setLogPassVC = [[SetLogPassViewController alloc]init];
        [self.navigationController pushViewController:setLogPassVC animated:YES];
    }
    if(sender.tag==102){
        PaySettingViewController *pay = [[PaySettingViewController alloc]init];
        [self.navigationController pushViewController:pay animated:YES];
    }
    if(sender.tag==103)
    {
        BundlingViewController * bund=[[BundlingViewController alloc] init];
        [self.navigationController pushViewController:bund animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
