//
//  SetLogPassViewController.m
//  My_App
//  zhaohan 20151120 amend
//  Created by apple on 14-8-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SetLogPassViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"

@interface SetLogPassViewController ()

@end

@implementation SetLogPassViewController
{
    ASIFormDataRequest *requestModifyPWD;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestModifyPWD clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    self.tabBarController.tabBar.hidden = YES;
}
// 初始化的事后创建提示lable和返回手势
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
        rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    // 设置保存按钮弧度
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:4];
    [saveBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [saveBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    //  设置textField的文字
    self.oldLoginPassField.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.oldLoginPassField.placeholder = @"请输入您的原密码";
    self.oldLoginPassField.backgroundColor = [UIColor whiteColor];
    self.oldLoginPassField.textColor = [UIColor blackColor];
    self.oldLoginPassField.textAlignment = NSTextAlignmentLeft;
    self.oldLoginPassField.secureTextEntry = YES;
    self.oldLoginPassField.delegate = self;
    
    self.setNewLogPassField.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.setNewLogPassField.placeholder = @"请输入您的新密码";
    self.setNewLogPassField.backgroundColor = [UIColor whiteColor];
    self.setNewLogPassField.textColor = [UIColor blackColor];
    self.setNewLogPassField.textAlignment = NSTextAlignmentLeft;
    self.setNewLogPassField.secureTextEntry = YES;
    self.setNewLogPassField.delegate = self;
    
    self.setNewLogPassAgainField.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.setNewLogPassAgainField.placeholder = @"请再次输入您的新密码";
    self.setNewLogPassAgainField.backgroundColor = [UIColor whiteColor];
    self.setNewLogPassAgainField.textColor = [UIColor blackColor];
    self.setNewLogPassAgainField.textAlignment = NSTextAlignmentLeft;
    self.setNewLogPassAgainField.secureTextEntry = YES;
    self.setNewLogPassAgainField.delegate = self;

    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapGestureRecognizer3];
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
-(void)createBackBtn{
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"修改登录密码" setTitleFont:19 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=titleLabel;
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -textFieldDelegate
//该方法为点击输入文本框要开始输入是调用的代理方法：就是把view上移到能看见文本框的地方
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGFloat keyboardHeight = 216.0f;
//    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
//        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 20);
//        [UIView beginAnimations:@"srcollView" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.275f];
//        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
//}
//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [UIView beginAnimations:@"srcollView" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.275f];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//}
//该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.oldLoginPassField resignFirstResponder];
    [self.setNewLogPassField resignFirstResponder];
    [self.setNewLogPassAgainField resignFirstResponder];
    return YES;
}
#pragma mark -自定义提示信息框
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
//点击提交按钮,请求验证原密码
- (IBAction)btnSetUp:(id)sender {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    if (self.oldLoginPassField.text.length == 0||self.setNewLogPassField.text.length == 0||self.setNewLogPassAgainField.text.length == 0) {
        [self failedPrompt:@"输入密码均不能为空!"];
    }else if (![self.setNewLogPassAgainField.text isEqualToString: self.setNewLogPassField.text]){
        [self failedPrompt:@"输入确认密码与新密码不一致!"];
    }
    else{
        [SYObject startLoading];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,PASSMODIFY_URL]];
        requestModifyPWD = [ASIFormDataRequest requestWithURL:url2];
        [requestModifyPWD setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [requestModifyPWD setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [requestModifyPWD setPostValue:self.oldLoginPassField.text forKey:@"old_password"];
        [requestModifyPWD setPostValue:self.setNewLogPassField.text forKey:@"new_password"];
        
        [requestModifyPWD setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestModifyPWD.tag = 301;
        [requestModifyPWD setDelegate:self];
        [requestModifyPWD setDidFailSelector:@selector(urlRequestFailed:)];
        [requestModifyPWD setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [requestModifyPWD startAsynchronous];
    }
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int stauscode2 = [request responseStatusCode];
    if (stauscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            if (code.intValue == -100) {
                [self failedPrompt:@"原密码不正确"];
            }
            else if (code.intValue == -200) {
                [self failedPrompt:@"用户信息不正确"];
            }
            //当输入无误修改成功后弹出修改成功提示,在本界面停留1秒,1秒后相应跳转
            else if (code.intValue == 100) {
                [self failedPrompt:@"修改成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tiaozhuan) userInfo:nil repeats:NO];
            }
        }
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)tiaozhuan{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)disappear{
    [_setNewLogPassAgainField resignFirstResponder];
    [_setNewLogPassField resignFirstResponder];
    [_oldLoginPassField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
