//
//  PaySettingViewController.m
//  My_App
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PaySettingViewController.h"
#import "BundlingViewController.h"

@interface PaySettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textVerifyCode;
@property (weak, nonatomic) IBOutlet UITextField *textNewPayPsw;
@property (weak, nonatomic) IBOutlet UITextField *textConfirmPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnGetVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic,strong) NSMutableString *phoneNumber;



@end

@implementation PaySettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    self.btnGetVerifyCode.tag=101;
    self.btnSubmit.tag=102;
    
    // 设置保存按钮弧度
    [self.btnGetVerifyCode.layer setMasksToBounds:YES];
    [self.btnGetVerifyCode.layer setCornerRadius:4];
    [self.btnSubmit.layer setMasksToBounds:YES];
    [self.btnSubmit.layer setCornerRadius:4];
    
    //  设置textField的文字
    
    self.phoneNumberTextField.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.phoneNumberTextField.placeholder = @"请输入手机号码";
    self.phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    self.phoneNumberTextField.textColor = [UIColor blackColor];
    self.phoneNumberTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [self.phoneNumberTextField setInputAccessoryView:inputView];
    
    
    // 设置前判断是否绑定手机
    NSString *isPhoneBundleUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,HASPHONE_URL];
    // 获取本地文件
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{@"user_id":fileContent[3],@"token":fileContent[1]};
    [[Requester managerWithHeader]POST:isPhoneBundleUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        if (code==100) {
            self.phoneNumberTextField.text=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"mobile"]];
            self.phoneNumber=[NSMutableString stringWithFormat:@"%@",[resultDict objectForKey:@"mobile"]];
        }else{
            self.phoneNumberTextField.text=@"";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求出现错误"];
    }];
    
    self.textVerifyCode.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.textVerifyCode.placeholder = @"请输入验证码";
    self.textVerifyCode.backgroundColor = [UIColor whiteColor];
    self.textVerifyCode.textColor = [UIColor blackColor];
    self.textVerifyCode.textAlignment = NSTextAlignmentLeft;
    self.textVerifyCode.delegate = self;
    self.textVerifyCode.keyboardType = UIKeyboardTypeNumberPad;
    
    WDInputView *inputView1=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard1) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard1)];
    [self.textVerifyCode setInputAccessoryView:inputView1];
    
    
    
    self.textNewPayPsw.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.textNewPayPsw.placeholder = @"请输入新密码";
    self.textNewPayPsw.backgroundColor = [UIColor whiteColor];
    self.textNewPayPsw.textColor = [UIColor blackColor];
    self.textNewPayPsw.textAlignment = NSTextAlignmentLeft;
    self.textNewPayPsw.secureTextEntry = YES;
    self.textNewPayPsw.delegate = self;
    
    self.textConfirmPsw.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.textConfirmPsw.placeholder = @"请再次确认新密码";
    self.textConfirmPsw.backgroundColor = [UIColor whiteColor];
    self.textConfirmPsw.textColor = [UIColor blackColor];
    self.textConfirmPsw.textAlignment = NSTextAlignmentLeft;
    self.textConfirmPsw.secureTextEntry = YES;
    self.textConfirmPsw.delegate = self;
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}
-(void)dismissKeyBoard{
    [self.phoneNumberTextField resignFirstResponder];
    
}
-(void)dismissKeyBoard1{
   [self.textVerifyCode resignFirstResponder];
    
}
#pragma mark -textFieldDelegate
// return 注销键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textVerifyCode resignFirstResponder];
    [self.textNewPayPsw resignFirstResponder];
    [self.textConfirmPsw resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    return YES;
}
#pragma mark -自定义提示信息框
-(void)createBackBtn{
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"修改支付密码" setTitleFont:19 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=titleLabel;
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnClicked:(UIButton*)sender {
    
    if (![self isPhoneNumField]) {
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }
    // 获取验证码
    if (sender.tag==101) {
        if (self.phoneNumberTextField.text.length==0) {
            [SYObject failedPrompt:@"请输入手机号码"];
        }else{
            // 设置前判断是否绑定手机
            NSString *isPhoneBundleUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,VERIFYCODE_URL];
            // 获取本地文件
            NSArray *fileContent=[MyUtil returnLocalUserFile];
            NSDictionary *par ;
            if ([self.phoneNumberTextField.text isEqualToString:self.phoneNumber]) {
                par = @{@"user_id":fileContent[3],
                        @"token":fileContent[1],
                        @"use":@"pay_password"};
            }else{
                par = @{@"user_id":fileContent[3],
                        @"token":fileContent[1],
                        @"mobile":self.phoneNumberTextField.text,
                        @"use":@"binding_mobile"};
            }
           
            [[Requester managerWithHeader]POST:isPhoneBundleUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *resultDict = responseObject;
                NSInteger code=[resultDict[@"code"] integerValue];
                if (code==100) {
                    // 发送成功后60秒重发整体队列
                    __block int timeout=60; //倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if(timeout<=0){ //倒计时结束，关闭
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示 根据自己需求设置
                                self.btnGetVerifyCode.backgroundColor = MY_COLOR;
                                [self.btnGetVerifyCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                                self.btnGetVerifyCode.userInteractionEnabled = YES;
                            });
                        }else{
                            int seconds = timeout % 61;
                            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示 根据自己需求设置
                                self.btnGetVerifyCode.backgroundColor = [UIColor lightGrayColor];
                                [self.btnGetVerifyCode setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                                self.btnGetVerifyCode.titleLabel.font = [UIFont systemFontOfSize:15];
                                self.btnGetVerifyCode.userInteractionEnabled = NO;
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_timer);
                    [SYObject failedPrompt:@"验证码已发到手机，请查收"];
                }else if (code==200){
                  [SYObject failedPrompt:@"获取验证码失败"];
                }else if (code==300){
                    [SYObject failedPrompt:@"系统没开启短信"];
                }else if (code==400){
                    [SYObject failedPrompt:@"此手机号已绑定其他用户"];
                }else{
                    [SYObject failedPrompt:@"获取验证码失败，请联系后台"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SYObject failedPrompt:@"网络请求出现错误"];
            }];
        }
    }
    // 提交请求修改支付密码
    if (sender.tag==102) {
        [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
        if (self.textNewPayPsw.text.length == 0||self.textConfirmPsw.text.length == 0) {
            [SYObject failedPrompt:@"输入密码不能为空!"];
        }else  if (self.textVerifyCode.text.length == 0) {
            [SYObject failedPrompt:@"输入手机验证码不能为空!"];
        }else if (![self.textNewPayPsw.text isEqualToString: self.textConfirmPsw.text]){
            [SYObject failedPrompt:@"两次密码输入不一致!"];
        }else{
            [SYObject startLoading];
            // 设置前判断是否绑定手机
            NSString *isPhoneBundleUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,HASPHONE_URL];
            // 获取本地文件
            NSArray *fileContent=[MyUtil returnLocalUserFile];
            NSDictionary *par = @{
                                  @"user_id":fileContent[3],
                                  @"token":[SYObject currentToken]
                                  };
            [[Requester managerWithHeader]POST:isPhoneBundleUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict= responseObject;
                NSString *code = dict[@"code"];
                if (code.integerValue == -100) {
                    [SYObject endLoading];
                    [SYObject failedPrompt:@"没有绑定手机" complete:^{
                        BundlingViewController * bund=[[BundlingViewController alloc] init];
                        [self.navigationController pushViewController:bund animated:YES];
                    }];
                }else if (code.integerValue == 100){
                    //已绑定手机，继续发请求，做修改密码操作 IDENTIFYINGCODE_URL
                    [SYObject endLoading];
                    
                    NSString *urlModPswd = [NSString stringWithFormat:@"%@%@",FIRST_URL,IDENTIFYINGCODE_URL];
                    NSDictionary *par = @{
                                          @"user_id":[SYObject currentUserID],
                                          @"token":[SYObject currentToken],
                                          @"new_password":self.textNewPayPsw.text,
                                          @"code":self.textVerifyCode.text
                                          };
                    [[Requester managerWithHeader]POST:urlModPswd parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *dict = responseObject;
                        NSString *code = dict[@"code"];
                        if (code.integerValue == 100) {
                            [SYObject failedPrompt:@"修改成功" complete:^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }];
                        }else if (code.integerValue == -100){
                            [SYObject failedPrompt:@"修改失败"];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SYObject failedPrompt:[error localizedDescription]];
                    }];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SYObject endLoading];
                [SYObject failedPrompt:[error localizedDescription]];
            }];
        }
    }
}
- (BOOL)isPhoneNumField
{
    NSString *phoneRegex = @"[1][0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:self.phoneNumberTextField.text];
    if (!isMatch) {
        [self.phoneNumberTextField setText:@""];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
