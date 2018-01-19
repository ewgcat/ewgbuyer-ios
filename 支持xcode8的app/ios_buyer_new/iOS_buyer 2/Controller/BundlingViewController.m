//
//  BundlingViewController.m
//  My_App
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BundlingViewController.h"

@interface BundlingViewController (){
    ASIFormDataRequest *request101;
    ASIFormDataRequest *request102;
}

@end

@implementation BundlingViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.enterType == BUNDLINGVC_ENTER_TYPE_FROM_PAY_SELECT) {
        //做提示
        [OHAlertView showAlertWithTitle:nil message:@"请先绑定手机!" cancelButton:@"好" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
         
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self createBackBtn];
    _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumField.delegate = self;
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [self.phoneNumField setInputAccessoryView:inputView];
//    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
//    [topView setBarStyle:UIBarStyleBlack];
//    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//    [topView setItems:buttonsArray];
//    [self.phoneNumField setInputAccessoryView:topView];
    
    
    self.btnTakeCode.tag = 101;
    [_btnTakeCode.layer setMasksToBounds:YES];
    [_btnTakeCode.layer setCornerRadius:5.0f];
    [self.btnTakeCode addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnBungling.tag = 102;
    CALayer *lay5 = self.btnBungling.layer;
    [lay5 setMasksToBounds:YES];
    [lay5 setCornerRadius:5.0f];
    [self.btnBungling addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodeField.delegate = self;
    
    WDInputView *inputView1=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard1)];
    [self.phoneCodeField setInputAccessoryView:inputView1];
    
//    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
//    [topView1 setBarStyle:UIBarStyleBlack];
//    UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard1)];
//    NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
//    [topView1 setItems:buttonsArray1];
//    [ self.phoneCodeField setInputAccessoryView:topView1];
   
}
//重写返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 手机号判断
- (BOOL)isMobileField:(NSString *)phoneNumber
{
    UITextField *mobileTF = self.phoneNumField;
    if (mobileTF.text.length == 0) {
        return YES;
    }
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        mobileTF.text = 0;
        return NO;
    }
    
    return YES;
}
#pragma mark - 点击事件
-(void) btnClicked:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (btn.tag == 101) {
        if (self.phoneNumField.text.length == 0) {
            [self failedPrompt:@"手机号码不能为空!"];
            return;
        }else if (![self isMobileField:self.phoneNumField.text]) {
            [self failedPrompt:@"请输入正确的手机号码!"];
            return;
        }else{
            [SYObject startLoading];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, VERIFYCODE_URL]];
            request101 = [ASIFormDataRequest requestWithURL:url];
            [request101 setPostValue:[USER_INFORMATION objectAtIndex:3] forKey:@"user_id"];
            [request101 setPostValue:[USER_INFORMATION objectAtIndex:1] forKey:@"token"];
            [request101 setPostValue:@"binding_mobile" forKey:@"use"];
            [request101 setPostValue:self.phoneNumField.text forKey:@"mobile"];
            
            [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request101.delegate = self;
            [request101 setDidFailSelector:@selector(sec_urlRequestFailed:)];
            [request101 setDidFinishSelector:@selector(sec_urlRequestSucceeded:)];
            [request101 startAsynchronous];
        }
    }
    if (btn.tag == 102) {
        
        if (self.phoneNumField.text.length == 0) {
            [self failedPrompt:@"手机号码不能为空!"];
        }
        else if(self.phoneCodeField.text.length == 0){
            [self failedPrompt:@"短信验证码不能为空!"];
        }
        else{
            [SYObject startLoading];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, BUNDLING_URL]];
            request102 = [ASIFormDataRequest requestWithURL:url];
            [request102 setPostValue:[USER_INFORMATION objectAtIndex:3] forKey:@"user_id"];
            [request102 setPostValue:[USER_INFORMATION objectAtIndex:1] forKey:@"token"];
            [request102 setPostValue:_phoneNumField.text forKey:@"mobile"];
            [request102 setPostValue:_phoneCodeField.text forKey:@"mobile_verify_code"];
            
            [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request102.delegate = self;
            [request102 setDidFailSelector:@selector(urlRequestFailed:)];
            [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request102 startAsynchronous];
        }
    }
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"phoneCode-->>%@",dicBig);
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            if (code.intValue == -100) {
                [self failedPrompt:@"验证码错误，手机绑定失败!"];
            }
            if (code.intValue == 100) {
                [self failedPrompt:@"手机绑定成功!"];
            }
        }
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    
}
-(void)sec_urlRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"phone-->>%@",dicBig);
        if (dicBig) {
            NSInteger code=[dicBig[@"code"] integerValue];
            if (code==100) {
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            self.btnTakeCode.backgroundColor = MY_COLOR;
                            [self.btnTakeCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                            self.btnTakeCode.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 61;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            self.btnTakeCode.backgroundColor = [UIColor lightGrayColor];
                            [self.btnTakeCode setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                            self.btnTakeCode.titleLabel.font = [UIFont systemFontOfSize:15];
                            self.btnTakeCode.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
                [SYObject failedPrompt:@"验证码已发送到手机，请查收"];
            }else if (code==200){
                [SYObject failedPrompt:@"获取验证码失败"];
            }else if (code==300){
                [SYObject failedPrompt:@"系统没开启短信"];
            }else if (code==400){
                [SYObject failedPrompt:@"此手机号已绑定其他用户"];
            }else{
                [SYObject failedPrompt:@"获取验证码失败，请联系后台"];
            }
        }
    }
    [SYObject endLoading];
}

-(void)sec_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}

#pragma mark - 提示
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)dismissKeyBoard{
    [self.phoneNumField resignFirstResponder];
    [self isPhoneNumField:self.phoneNumField.text];
}
-(void)dismissKeyBoard1{
    [self.phoneCodeField resignFirstResponder];
}
-(void)doTimer2
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 手机验证
- (BOOL)isPhoneNumField:(NSString *)phoneNumber
{
    if (self.phoneNumField.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"[1][0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [self failedPrompt:@"请输入正确的手机号码!"];
        [self.phoneNumField setText:@""];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
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

@end
