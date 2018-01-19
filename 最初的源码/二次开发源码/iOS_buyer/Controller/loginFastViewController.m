//
//  FastRegisterViewController.m
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "loginFastViewController.h"
#import "RegisterAgreementViewController.h"
#import "ASIFormDataRequest.h"
#import "SetLogPassViewController.h"
#import "LoginViewController.h"
#import "FirstViewController.h"

@interface loginFastViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    
}

@end

@implementation loginFastViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
    [request_6 clearDelegatesAndCancel];
    [request_7 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    self.tabBarController.tabBar.hidden = YES;
    if (self.third_username.length>0) {
        self.registerNameField.text=self.third_username;
    }

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = BACKGROUNDCOLOR;
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"注册";
    [self createBackBtn];
    btnBool = YES;
    btnBool2 = YES;
    NSArray *array=@[@"用户名注册",@"手机号注册"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake(30, 20, ScreenFrame.size.width - 60, 30);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor = UIColorFromRGB(0xf15353);
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    [self createView1];
    [self createView2];
    [super didReceiveMemoryWarning];
}
#pragma mark - UI搭构
//创建返回按钮
-(void)createBackBtn{

    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"注册" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=titleLabel;
    
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void) createView1{
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, ScreenFrame.size.width, 250)];
    view1.userInteractionEnabled = YES;
    [self.view addSubview:view1];
    
   
     UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 120)];
    imageV.center = CGPointMake(ScreenFrame.size.width / 2, 60);
    [imageV.layer setMasksToBounds:YES];
    [imageV.layer setCornerRadius:8];
    imageV.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:imageV];
    
    UILabel *lblRegisterName = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 80 , 39)];
    lblRegisterName.text = @"用  户  名:";
    lblRegisterName.font = [UIFont systemFontOfSize:17];
    lblRegisterName.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:lblRegisterName];
    
    UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(40,39, ScreenFrame.size.width-40, 1)];
    l.backgroundColor=UIColorFromRGB(0Xededed);
    [view1 addSubview:l];

    UILabel *lblRegisterPassword = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 80 , 39)];
    lblRegisterPassword.text = @"密       码:";
    lblRegisterPassword.font = [UIFont systemFontOfSize:17];
    lblRegisterPassword.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:lblRegisterPassword];
    
    UILabel *ll=[[UILabel alloc]initWithFrame:CGRectMake(40,79, ScreenFrame.size.width-40, 1)];
    ll.backgroundColor=UIColorFromRGB(0Xededed);
    [view1 addSubview:ll];
    
    UILabel *lblRegisterPasswordAgain = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 100 , 39)];
    lblRegisterPasswordAgain.text = @"确认密码:";
    lblRegisterPasswordAgain.font = [UIFont systemFontOfSize:17];
    lblRegisterPasswordAgain.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:lblRegisterPasswordAgain];
    
    UILabel *lblRegisterAgree = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200 , 34)];
    lblRegisterAgree.center = CGPointMake(130, 200);
    lblRegisterAgree.text = @"注：点击注册即同意";
    lblRegisterAgree.textColor=UIColorFromRGB(0Xacacac);
    lblRegisterAgree.font = [UIFont systemFontOfSize:17];
    lblRegisterAgree.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:lblRegisterAgree];
    
    self.registerNameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, 155, 39)];
    self.registerNameField.placeholder = @"请输入用户名";
    self.registerNameField.font = [UIFont fontWithName:@"Arial" size:17];
    self.registerNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerNameField.clearsOnBeginEditing = YES;
    self.registerNameField.textAlignment = NSTextAlignmentLeft;
    self.registerNameField.keyboardType = UIKeyboardTypeDefault;
    self.registerNameField.keyboardAppearance = UIKeyboardTypeDefault;
    self.registerNameField.userInteractionEnabled = YES;
    self.registerNameField.delegate = self;
    
    [view1 addSubview:self.registerNameField];
    
    self.registerPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(120, 40, 155, 39)];
    self.registerPasswordField.placeholder = @"请输入密码";
    self.registerPasswordField.font = [UIFont fontWithName:@"Arial" size:17];
    self.registerPasswordField.secureTextEntry = YES;
    self.registerPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerPasswordField.clearsOnBeginEditing = YES;
    self.registerPasswordField.textAlignment = NSTextAlignmentLeft;
    self.registerPasswordField.keyboardType = UIKeyboardTypeDefault;
    self.registerPasswordField.keyboardAppearance = UIKeyboardTypeDefault;
    self.registerPasswordField.userInteractionEnabled = YES;
    self.registerPasswordField.delegate = self;
    [view1 addSubview:self.registerPasswordField];
    
    self.registerPasswordAgainField = [[UITextField alloc]initWithFrame:CGRectMake(120, 80, 155, 39)];
    self.registerPasswordAgainField.backgroundColor = [UIColor clearColor];
    self.registerPasswordAgainField.placeholder = @"请再次输入密码";
    self.registerPasswordAgainField.font = [UIFont fontWithName:@"Arial" size:17];
    self.registerPasswordAgainField.secureTextEntry = YES;
    self.registerPasswordAgainField.textColor = [UIColor blackColor];
    self.registerPasswordAgainField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerPasswordAgainField.clearsOnBeginEditing = YES;
    self.registerPasswordAgainField.textAlignment = NSTextAlignmentLeft;
    self.registerPasswordAgainField.keyboardType = UIKeyboardTypeDefault;
    self.registerPasswordAgainField.keyboardAppearance = UIKeyboardTypeDefault;
    self.registerPasswordAgainField.delegate = self;
    self.registerPasswordAgainField.userInteractionEnabled = YES;
    [view1 addSubview:self.registerPasswordAgainField];
    
    self.btnRegister1 = [UIButton buttonWithType: UIButtonTypeCustom];
    self.btnRegister1.frame = CGRectMake(0, 0, ScreenFrame.size.width-60, 34);
    self.btnRegister1.center = CGPointMake(ScreenFrame.size.width/2, 150);
    self.btnRegister1.backgroundColor = UIColorFromRGB(0xf15353);
    [self.btnRegister1 setTitle:@"注  册" forState:UIControlStateNormal];
    self.btnRegister1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.btnRegister1.layer setMasksToBounds:YES];
    [self.btnRegister1.layer setCornerRadius:4.0];
    [self.btnRegister1 addTarget:self action:@selector(btnRegisterFirst) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:self.btnRegister1];
    

    
    self.btnRegisterAgreement = [UIButton buttonWithType: UIButtonTypeCustom];
    self.btnRegisterAgreement.frame = CGRectMake(0, 0, 120, 26);
    self.btnRegisterAgreement.center = CGPointMake(230, 200);
    self.btnRegisterAgreement.backgroundColor = [UIColor clearColor];
    [self.btnRegisterAgreement setTitle:@"《注册协议》" forState:UIControlStateNormal];

    [self.btnRegisterAgreement setTitleColor:UIColorFromRGB(0Xf15353) forState:UIControlStateNormal];
    [self.btnRegisterAgreement setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.btnRegisterAgreement.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.btnRegisterAgreement addTarget:self action:@selector(btnRegister2) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:self.btnRegisterAgreement];
}
-(void) createView2{
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, ScreenFrame.size.width, 250)];
    view2.hidden = YES;
    view2.userInteractionEnabled = YES;
    [self.view addSubview:view2];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 120)];
    imageV.center = CGPointMake(ScreenFrame.size.width / 2, 60);
    [imageV.layer setMasksToBounds:YES];
    [imageV.layer setCornerRadius:8];
    imageV.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:imageV];
    
    UILabel *lblRegisterName = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 80 , 39)];
    lblRegisterName.text = @"手  机  号:";
    lblRegisterName.font = [UIFont systemFontOfSize:17];
    lblRegisterName.textAlignment = NSTextAlignmentLeft;
    [view2 addSubview:lblRegisterName];
    
    UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(40,39, ScreenFrame.size.width-40, 1)];
    l.backgroundColor=UIColorFromRGB(0Xededed);
    [view2 addSubview:l];
    
    UILabel *lblRegisterPassword = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 80 , 39)];
    lblRegisterPassword.text = @"验  证  码:";
    lblRegisterPassword.font = [UIFont systemFontOfSize:17];
    lblRegisterPassword.textAlignment = NSTextAlignmentLeft;
    [view2 addSubview:lblRegisterPassword];
    
    UILabel *ll=[[UILabel alloc]initWithFrame:CGRectMake(40,79, ScreenFrame.size.width-40, 1)];
    ll.backgroundColor=UIColorFromRGB(0Xededed);
    [view2 addSubview:ll];
    
    UILabel *lblRegisterPasswordAgain = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 100 , 39)];
    lblRegisterPasswordAgain.text = @"密       码:";
    lblRegisterPasswordAgain.font = [UIFont systemFontOfSize:17];
    lblRegisterPasswordAgain.textAlignment = NSTextAlignmentLeft;
    [view2 addSubview:lblRegisterPasswordAgain];
    
    
    
    self.registerPhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, 155, 39)];
    self.registerPhoneNum.placeholder = @"请输入您的手机号码";
    self.registerPhoneNum.font = [UIFont fontWithName:@"Arial" size:17];
    self.registerPhoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerPhoneNum.keyboardType = UIKeyboardTypePhonePad;
    self.registerPhoneNum.autocorrectionType = UITextAutocorrectionTypeYes;
    self.registerPhoneNum.keyboardAppearance = UIKeyboardTypeDefault;
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [self.registerPhoneNum setInputAccessoryView:inputView];
    
    self.registerPhoneNum.delegate = self;
    [view2 addSubview:_registerPhoneNum];


    self.codeField = [[UITextField alloc]initWithFrame:CGRectMake(120, 40, 155, 39)];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.font = [UIFont fontWithName:@"Arial" size:17];
    self.codeField.secureTextEntry = YES;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.clearsOnBeginEditing = YES;
    self.codeField.textAlignment = NSTextAlignmentLeft;
    self.codeField.keyboardType = UIKeyboardTypeDefault;
    self.codeField.keyboardAppearance = UIKeyboardTypeDefault;
    self.codeField.userInteractionEnabled = YES;
    self.codeField.delegate = self;
    [view2 addSubview:self.codeField];
    
    self.registerPhonePassField = [[UITextField alloc]initWithFrame:CGRectMake(120, 80, 155, 39)];
    self.registerPhonePassField.backgroundColor = [UIColor clearColor];
    self.registerPhonePassField.placeholder = @"请输入密码";
    self.registerPhonePassField.font = [UIFont fontWithName:@"Arial" size:17];
    self.registerPhonePassField.secureTextEntry = YES;
    self.registerPhonePassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.registerPhonePassField.clearsOnBeginEditing = YES;
    self.registerPhonePassField.textAlignment = NSTextAlignmentLeft;
    self.registerPhonePassField.keyboardType = UIKeyboardTypeDefault;
    self.registerPhonePassField.keyboardAppearance = UIKeyboardTypeDefault;
    self.registerPhonePassField.userInteractionEnabled = YES;
    self.registerPhonePassField.delegate = self;
    [view2 addSubview:self.registerPhonePassField];

    
    
    self.btnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    self.btnTime.frame =CGRectMake(190,130, ScreenFrame.size.width - 230, 30);
    [self.btnTime setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.btnTime addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    self.btnTime.titleLabel.font  = [UIFont boldSystemFontOfSize:14];
    self.btnTime.backgroundColor = UIColorFromRGB(0xf15353);
    self.btnTime.layer.cornerRadius=4;
    self.btnTime.layer.masksToBounds=YES;
    [view2 addSubview:self.btnTime];
    
    UIButton *buttonZHU = [UIButton buttonWithType: UIButtonTypeCustom];
    buttonZHU.frame = CGRectMake(0, 0, ScreenFrame.size.width-60, 34);
    buttonZHU.center = CGPointMake(ScreenFrame.size.width/2, 190);
    buttonZHU.backgroundColor = UIColorFromRGB(0xf15353);
    [buttonZHU setTitle:@"注  册" forState:UIControlStateNormal];
    buttonZHU.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [buttonZHU.layer setMasksToBounds:YES];
    [buttonZHU.layer setCornerRadius:4.0];
    [buttonZHU addTarget:self action:@selector(btnRegisterRelex1) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:buttonZHU];
    
    
    UILabel *lblRegisterAgree2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,200 , 34)];
    lblRegisterAgree2.center = CGPointMake(130, 230);
    lblRegisterAgree2.text = @"注：点击注册即同意";
    lblRegisterAgree2.textColor=UIColorFromRGB(0Xacacac);
    lblRegisterAgree2.font = [UIFont systemFontOfSize:17];
    lblRegisterAgree2.textAlignment = NSTextAlignmentLeft;
    lblRegisterAgree2.backgroundColor = [UIColor clearColor];
    [view2 addSubview:lblRegisterAgree2];
    
    self.btnRegisterAgreement = [UIButton buttonWithType: UIButtonTypeCustom];
    self.btnRegisterAgreement.frame = CGRectMake(0, 0, 120, 26);
    self.btnRegisterAgreement.center = CGPointMake(230, 230);
    self.btnRegisterAgreement.backgroundColor = [UIColor clearColor];
    [self.btnRegisterAgreement setTitle:@"《注册协议》" forState:UIControlStateNormal];
    [self.btnRegisterAgreement setTitleColor:UIColorFromRGB(0Xf15353) forState:UIControlStateNormal];
    [self.btnRegisterAgreement setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.btnRegisterAgreement.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.btnRegisterAgreement addTarget:self action:@selector(btnRegister2) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:self.btnRegisterAgreement];

}
-(void)dismissKeyBoard{
    [self.registerPhoneNum resignFirstResponder];
}
#pragma mark - 点击事件
-(void)doTimer_success{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doTimer_third_success{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)btnRegister2
{
    RegisterAgreementViewController *registerAgreementVC = [[RegisterAgreementViewController alloc]init];
    [self presentViewController:registerAgreementVC animated:YES completion:nil];
    
}

- (void)checkboxClick:(UIButton *)btn
{
    if (btnBool==NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
        btnBool = YES;
        
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        btnBool = NO;
    }
}
-(void)checkboxClick2:(UIButton *)btn{
    if (btnBool2==NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
        btnBool2 = YES;
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        btnBool2 = NO;
    }
}
-(void)backBtnClicked{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnRegisterRelex1{
    if (self.registerPhoneNum.text.length == 0 ) {
        [SYObject failedPrompt:@"手机号码不能为空!"];
    }else if(_codeField.text.length == 0){
        [SYObject failedPrompt:@"请输入验证码!"];
    }else if(_registerPhonePassField.text.length == 0){
        [SYObject failedPrompt:@"请输入密码!"];
    }else{
        _type = MOBILEREGI;
        [SYObject startLoading];
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGISTERFINISH_URL]];
        request_2 = [ASIFormDataRequest requestWithURL:url2];
        [request_2 setPostValue:@"" forKey:@"userName"];
        [request_2 setPostValue:_registerPhoneNum.text forKey:@"mobile"];
        [request_2 setPostValue:_codeField.text forKey:@"verify_code"];
        [request_2 setPostValue:_registerPhonePassField.text forKey:@"password"];
        [request_2 setPostValue:_type forKey:@"type"];
       
        if ([self.third_type isEqualToString:@"wechat"]||[self.third_type isEqualToString:@"weibo"]||[self.third_type isEqualToString:@"qq"]) {
            [request_2 setPostValue:self.third_type forKey:@"third_type"];
            [request_2 setPostValue:self.third_info forKey:@"third_info"];
        }

        NSArray *arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        NSArray *arrkey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrkey];
        [request_2 setRequestHeaders:dicMy];
        request_2.tag = 400;
        [request_2 setDelegate:self];
        [request_2 setDidFailSelector:@selector(my5_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(my5_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
    }
}

-(void)change:(UISegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex == 0) {
        [view1 setHidden:NO];
        [view2 setHidden:YES];
        _type = USERNAMEREGI;
    }
    else{
        [view1 setHidden:YES];
        [view2 setHidden:NO];
        _type = MOBILEREGI;
    }
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_registerNameField resignFirstResponder];
    [_registerPasswordField resignFirstResponder];
    [_registerPasswordAgainField resignFirstResponder];
    [_registerPhoneNum resignFirstResponder];
    [_registerPhonePassField resignFirstResponder];
    [_registerPhonePassAgainField resignFirstResponder];
    [_codeField resignFirstResponder];
}
- (BOOL)isRegisterPhoneNum:(NSString *)phoneNumber
{
    if (self.registerPhoneNum.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"[1][0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [SYObject failedPrompt:@"请输入正确的手机号码!"];
        return NO;
    }
    return YES;
}
-(BOOL)text:(NSString *)text matchesRegex:(NSString *)regex{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return  [p evaluateWithObject:text];
}
- (void)btnRegisterFirst
{
    NSString *newStr = self.registerNameField.text;
    
    if (self.registerNameField.text.length == 0||self.registerPasswordField.text.length == 0||self.registerPasswordAgainField.text.length == 0) {
        [SYObject failedPrompt:@"用户名或密码均不能为空!"];
    }
    else{

        if (![self text:newStr matchesRegex:@"^[\u4e00-\u9fa5a-zA-Z0-9]+$"]) {
            
            [SYObject failedPrompt:@"用户名不能包含特殊字符"];
            
        }
        else if (![self.registerPasswordAgainField.text isEqualToString: self.registerPasswordField.text]){
            [SYObject failedPrompt:@"两次输入密码不一致!"];
        }
        else if (btnBool == NO){
            //判断的是是否点击了同意
            [SYObject failedPrompt:@"请勾选注册协议!"];
        }
        //密码验证正则表达式
        else if (![self text:self.registerPasswordField.text matchesRegex:@"^[a-zA-Z0-9]{6,16}$"]){
            [SYObject failedPrompt:@"长度6~16字母数字"];
        }
//        else if (![self text:self.registerPasswordField.text matchesRegex:@"^[a-zA-Z0-9\u4e00-\u9fa5]{6,16}$"]){
//            [SYObject failedPrompt:@"长度6~16字母数字"];
//        }

        //则注册成功
        else{
            _type = USERNAMEREGI;
            [SYObject startLoading];
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGISTERFINISH_URL]];
            request_3 = [ASIFormDataRequest requestWithURL:url2];
            [request_3 setPostValue:self.registerNameField.text forKey:@"userName"];
            [request_3 setPostValue:@"userName" forKey:@"type"];
            [request_3 setPostValue:_registerPasswordField.text forKey:@"password"];
          
            if ([self.third_type isEqualToString:@"wechat"]||[self.third_type isEqualToString:@"weibo"]||[self.third_type isEqualToString:@"qq"]) {
                [request_3 setPostValue:self.third_type forKey:@"third_type"];
                [request_3 setPostValue:self.third_info forKey:@"third_info"];
            }

            NSArray *arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
            NSArray *arrkey = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrkey];
            [request_3 setRequestHeaders:dicMy];
            request_3.tag = 202;
            [request_3 setDelegate:self];
            [request_3 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_3 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_3 startAsynchronous];
        }
    }
}
#pragma mark - 倒计时后重新发送
- (void) startTime{
    if (self.registerPhoneNum.text.length == 0) {
        [SYObject failedPrompt:@"手机号码不能为空!"];
    }
    else if (self.registerPhoneNum.text.length < 10 || self.registerPhoneNum.text.length > 11) {
    }else if(![self isRegisterPhoneNum:self.registerPhoneNum.text]){
    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, REGISTERPHONE_URL]];
        request_1 = [ASIFormDataRequest requestWithURL:url];
        [request_1 setPostValue:_registerPhoneNum.text forKey:@"mobile"];
        NSArray *arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request_1 setRequestHeaders:dicMy];
        request_1.tag = 303;
        [request_1 setDelegate:self];
        [request_1 setDidFailSelector:@selector(my4_urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(my4_urlRequestSucceeded:)];
        [request_1 startAsynchronous];
        
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.btnTime.backgroundColor = MY_COLOR;
                    [self.btnTime setTitle:@"发送验证码" forState:UIControlStateNormal];
                    self.btnTime.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 61;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.btnTime.backgroundColor = [UIColor lightGrayColor];
                    [self.btnTime setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    self.btnTime.titleLabel.font = [UIFont systemFontOfSize:11];
                    self.btnTime.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

#pragma mark - textField 代理
//隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

//    if (textField == _registerNameField) {
//        [textField resignFirstResponder];
//        [_registerPasswordField becomeFirstResponder];
//    }else if (textField == _registerPasswordField){
//        [textField resignFirstResponder];
//        [_registerPasswordAgainField becomeFirstResponder];
//    }else if (textField == _registerPasswordAgainField){
//        [textField resignFirstResponder];
//        [self btnRegisterFirst];
//    }
    
    return YES;
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    [SYObject endLoading];
    if (statuscode2 == 200) {
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        //返回code值判断登录是否成功
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            if (code.intValue == -100) {
                [SYObject failedPrompt:@"账号不存在!"];
            }
            else if(code.intValue == -200){
                [SYObject failedPrompt:@"密码不正确!"];
            }
            else if(code.intValue == -300){
                [SYObject failedPrompt:@"登录失败!"];
            }
            else if(code.intValue == 0){
                [SYObject failedPrompt:@"数据异常"];
            }else{
                
                //保存得到的token userid
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"code"],[dicBig objectForKey:@"token"],[dicBig objectForKey:@"userName"],[dicBig objectForKey:@"user_id"],[dicBig objectForKey:VERIFY], nil];
                [array writeToFile:filePaht atomically:NO];
                
                [SYObject failedPrompt:@"登录成功!"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_success) userInfo:nil repeats:NO];
            }
        }
    }else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int stauscode2 = [request responseStatusCode];
    if (stauscode2 == 200) {
        [SYObject endLoading];
        //返回code值判断注册是否成功
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            if(code.intValue == -200){
                [SYObject failedPrompt:@"用户名已存在！"];
                
            }else if(code.intValue == 100){
                [SYObject startLoading];
               
                //自动登录 若自动登录成功则dismiss 并提示正在登录
                 [SYShopAccessTool pushBind];
                //保存得到的token userid
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"code"],[dicBig objectForKey:@"token"],[dicBig objectForKey:@"userName"],[dicBig objectForKey:@"user_id"],[dicBig objectForKey:VERIFY], nil];
                [array writeToFile:filePaht atomically:NO];
                
                [SYObject failedPrompt:@"注册成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_third_success) userInfo:nil repeats:NO];
                
//                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGISTER_URL]];
//                request_4 = [ASIFormDataRequest requestWithURL:url1];
//                [request_4 setPostValue:self.registerNameField.text forKey:@"userName"];
//                [request_4 setPostValue:self.registerPasswordField.text forKey:@"password"];
//                
//                if ([self.third_type isEqualToString:@"wechat"]||[self.third_type isEqualToString:@"weibo"]||[self.third_type isEqualToString:@"qq"]) {
//                    [request_4 setPostValue:self.third_type forKey:@"third_type"];
//                    [request_4 setPostValue:self.third_info forKey:@"third_info"];
//                }
//                NSArray *arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
//                NSArray *arrkey = [[NSArray alloc]initWithObjects:VERIFY, nil];
//                NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrkey];
//                [request_4 setRequestHeaders:dicMy];
//                request_4.tag = 101;
//                [request_4 setDelegate:self];
//                [request_4 setDidFailSelector:@selector(my6_urlRequestFailed:)];
//                [request_4 setDidFinishSelector:@selector(my6_urlRequestSucceeded:)];
//                [request_4 startAsynchronous];
            }
        }
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        //返回code值判断登录是否成功
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString *ret = [dicBig objectForKey:@"ret"];
        NSLog(@"短信接收:%@",dicBig);
        if (ret.intValue == 100) {
            [SYObject failedPrompt:@"发送成功！"];
        }
        if (ret.intValue == 200) {
            [SYObject failedPrompt:@"发送失败！"];
        }
        if (ret.intValue == 300) {
            [SYObject failedPrompt:@"系统未开启短信功能!"];
        }
    }
    
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my5_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        //返回code值判断登录是否成功
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"手机注册%@",dicBig);
        NSString *code = [dicBig objectForKey:@"code"];
        if (code.intValue == -100) {
            [SYObject failedPrompt:@"验证码错误!"];
        }
        if (code.intValue == -200) {
            [SYObject failedPrompt:@"用户名已存在!"];
        }
        if (code.intValue == 100) {

            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];

            [SYShopAccessTool pushBind];
            [OHAlertView showAlertWithTitle:@"提  示" message:@"恭喜您注册账号成功,默认密码为“123456”,是否要修改密码?" cancelButton:nil otherButtons:@[@"默认",@"更改"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (buttonIndex == 1){
                    [self.navigationController popViewControllerAnimated:YES];
                    LoginViewController *log = [LoginViewController sharedUserDefault];
                    [log setPassword];
                }
            }];
            
            //保存得到的token userid
            NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"code"],[dicBig objectForKey:@"token"],[dicBig objectForKey:@"userName"],[dicBig objectForKey:@"user_id"], [dicBig objectForKey:VERIFY], nil];
            [array writeToFile:filePaht atomically:NO];
        }
    }
    
}
-(void)my5_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
//-(void)my6_urlRequestSucceeded:(ASIFormDataRequest *)request{
//    int stauscode2 = [request responseStatusCode];
//    if (stauscode2 == 200) {
//        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//        //自动登录 若自动登录成功则dismiss 并提示正在登录
//        [SYShopAccessTool pushBind];
//        //保存得到的token userid
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"information.txt"];
//        NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"code"],[dicBig objectForKey:@"token"],[dicBig objectForKey:@"userName"],[dicBig objectForKey:@"user_id"],[dicBig objectForKey:VERIFY], nil];
//        [array writeToFile:filePaht atomically:NO];
//        
//        [SYObject failedPrompt:@"注册成功"];
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_third_success) userInfo:nil repeats:NO];
//
////        //在这个位置做 --- 自动登录 若自动登录成功则dismiss 并提示正在登录
////        [SYShopAccessTool pushBind];
////        [SYObject failedPrompt:@"注册成功,请登录"];
////        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_success) userInfo:nil repeats:NO];
//    }else{
//        [SYObject failedPrompt:@"请求出错"];
//    }
//    
//}
//-(void)my6_urlRequestFailed:(ASIFormDataRequest *)request{
//    [SYObject failedPrompt:@"网络请求失败"];
//}


-  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
        LoginViewController *log = [LoginViewController sharedUserDefault];
        [log setPassword];
    }
}
@end
