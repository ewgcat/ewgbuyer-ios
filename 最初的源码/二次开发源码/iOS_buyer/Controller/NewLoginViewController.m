//
//  NewLoginViewController.m
//  My_App
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NewLoginViewController.h"
#import "ThirdViewController.h"
#import "FirstViewController.h"
#import "loginFastViewController.h"
#import "forgetViewController.h"
#import "WXApi.h"

@interface NewLoginViewController ()

@end

@implementation NewLoginViewController{
    ASIFormDataRequest *request3;
}
- (IBAction)forgetBtnClicked:(id)sender {
    forgetViewController *forget = [[forgetViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (IBAction)QQBtnClicked:(id)sender {
    NSLog(@"QQ登录");
    [UMSocialData openLog:YES];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            // 如果是授权到qq，SSO之后如果想获取用户的昵称、头像等需要再获取一次账户信息
            NSString *usid=[[response.data objectForKey:@"qq"] objectForKey:@"usid"];
            NSString *username=[[response.data objectForKey:@"qq"] objectForKey:@"username"];
            [self getAppThirdLoginType:@"qq" andValue:usid andUserName:username];
        }else{
//            [SYObject failedPrompt:@"QQ登录只支持SSO登录方式，必须具备手机QQ客户端"];
        }
    });

}

#pragma mark -WXApiManagerDelegate
-(void)managerDidGetBackType:(WXApiManager *)manager backType:(backType)backtype{
    NSLog(@"managerDidGetBackType");
//    manager.codestring
    if (manager.codestring != nil) {
        [self getAppThirdLoginType:@"wechat" andValue:manager.codestring andUserName:@""];
    }else{
        
    }
   
}

- (IBAction)WXBtnClicked:(id)sender {
    NSLog(@"微信登录");
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq* req = [[SendAuthReq alloc] init] ;
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
        req.state = @"xxx";
        req.openID =@"0c806938e2413ce73eef92cc3";
        WXApiManager *amanager=[WXApiManager sharedManager];
        amanager.delegate=self;
        [WXApi sendAuthReq:req viewController:self delegate:amanager];
    }else{
        [SYObject failedPrompt:@"微信登录需要用户安装微信客户端才能配合使用"];
    }

//    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:15];
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
//    NSLog(@"platformName:%@",platformName);
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        //          获取微博用户名、uid、token等
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            // 如果是授权到qq，SSO之后如果想获取用户的昵称、头像等需要再获取一次账户信息
//            NSString *usid=[[response.data objectForKey:@"wechat"] objectForKey:@"usid"];
//            NSString *username=[[response.data objectForKey:@"wechat"] objectForKey:@"username"];
//            [self getAppThirdLoginType:@"wechat" andValue:usid andUserName:username];
//        }else{
//            [SYObject failedPrompt:@"微信登录需要用户安装微信客户端才能配合使用"];
//        }

       // 这里可以获取到腾讯微博openid,Qzone的token等
        /*
         if ([platformName isEqualToString:UMShareToTencent]) {
         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
         NSLog(@"get openid  response is %@",respose);
         }];
         }
//         */
//    });
    
    
}

- (IBAction)sinaBtnClicked:(id)sender {
//    新浪登录
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    WBApiManager *manager=[WBApiManager sharedManager];
    manager.detegate=self;
    
    [WeiboSDK sendRequest:request];
//    // 使用Sina微博账号登录
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
//        NSLog(@"response is %@", response);
//        // 如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再获取一次账户信息
//        NSString *usid=[[response.data objectForKey:@"sina"] objectForKey:@"usid"];
//        NSString *username=[[response.data objectForKey:@"sina"] objectForKey:@"username"];
//        [self getAppThirdLoginType:@"weibo" andValue:usid andUserName:username];
//    });
}
#pragma mark -WBApiManagerDetegate
-(void)weiBoApiManagerUid:(NSString *)uid andUsername:(NSString *)Username{
    if (uid != nil) {
         [self getAppThirdLoginType:@"weibo" andValue:uid andUserName:Username];
    }else{
    
    }
    
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userPasswordField.delegate = self;
    _userNameField.delegate = self;
    _userNameField.returnKeyType = UIReturnKeyNext;
    _userPasswordField.returnKeyType = UIReturnKeyDone;
    
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:4.0f];
    [loginBtn addTarget:self action:@selector(btnLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [fastregesterBtn addTarget:self action:@selector(btnFast) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];

    [self createBackBtn];
    self.title = @"登录";
    
    if ([WXApi isWXAppInstalled]) {
        _WCView.hidden=NO;
    }else{
        _WCView.hidden=YES;
    }

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [SYObject endLoading];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request102 clearDelegatesAndCancel];
    [request3 clearDelegatesAndCancel];
    [request101 clearDelegatesAndCancel];
}
#pragma mark - UI搭构
//创建返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        //返回code值判断登录是否成功
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"new用户中心dicBig:%@",dicBig);
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
                //发送绑定请求
                [SYShopAccessTool pushBind];
                //将没登陆的数据清空
                ThirdViewController *th = [ThirdViewController sharedUserDefault];//购物车
                th.jiesuan.text = @"0";
                [th.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",th.jiesuan.text] forState:UIControlStateNormal];
                [th.btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
                th.btnQ2.backgroundColor = [UIColor grayColor];
                th.cart_meideng = @"";
                //购物车数量提示
                [SYShopAccessTool getItemBadgeValue];
                
                [SYObject failedPrompt:@"登录成功!"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_success) userInfo:nil repeats:NO];
            }
        }
    }
}
-(void)myy_urlRequestSucceeded:(ASIFormDataRequest *)request{
//    loadingV.hidden = YES;
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
}
-(void)myy_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}


#pragma mark - 点击事件
-(void)doTimer_success{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnClicked{
    [_userNameField resignFirstResponder];
    [_userPasswordField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userNameField resignFirstResponder];
    [_userPasswordField resignFirstResponder];
    CGFloat keyboardHeight = 216.0f;
    if (self.view.frame.size.height - keyboardHeight -64<= _userPasswordField.frame.origin.y + _userPasswordField.frame.size.height) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        [UIView commitAnimations];
    }else{
        [UIView commitAnimations];
    }
}
-(void)btnFast{
    loginFastViewController *fast = [[loginFastViewController alloc]init];
    [self.navigationController pushViewController:fast animated:YES];


}
- (void) btnLogin {
    if (self.userNameField.text.length == 0||self.userPasswordField.text.length == 0) {
        [SYObject failedPrompt:@"用户名或密码不能为空!"];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
        [SYObject startLoading];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,LOGIN_URL]];
        request101=[ASIFormDataRequest requestWithURL:url];
        [request101 setPostValue:self.userNameField.text forKey:@"userName"];
        [request101 setPostValue:self.userPasswordField.text forKey:@"password"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 101;
        [request101 setDelegate:self];
        [request101 setDidFailSelector:@selector(urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
}
#pragma mark - textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _userNameField) {
        [_userNameField resignFirstResponder];
        [_userPasswordField becomeFirstResponder];
    }else if (textField == _userPasswordField){
        [_userPasswordField resignFirstResponder];
        [self btnLogin];
    }
    
    
    CGFloat keyboardHeight = 216.0f;
    if (self.view.frame.size.height - keyboardHeight -64<= textField.frame.origin.y + textField.frame.size.height) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        [UIView commitAnimations];
    }else{
        [UIView commitAnimations];
    }
    return YES;
}
#pragma mark -三方登录
-(void)getAppThirdLoginType:(NSString *)type andValue:(NSString *)value andUserName:(NSString *)userName{
    [SYObject startLoading];
    NSString *url= [NSString stringWithFormat:@"%@%@",FIRST_URL,THIRD_LOGIN_URL];
    NSDictionary *par=@{@"type":type,
                       @"value":value};
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"%@",dic);
        NSInteger code=[[dic objectForKey:@"code"]integerValue];
        if (code==100) {
            //已绑定
            //保存得到的token userid
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *array = [NSArray arrayWithObjects:[dic objectForKey:@"code"],[dic objectForKey:@"token"],[dic objectForKey:@"userName"],[dic objectForKey:@"user_id"],[dic objectForKey:VERIFY], nil];
            [array writeToFile:filePaht atomically:NO];
            
            [SYObject failedPrompt:@"登录成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_third_success) userInfo:nil repeats:NO];
        }else if (code==-100) {
          //未绑定
            NSString *info=[NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
            loginFastViewController *fast = [[loginFastViewController alloc]init];
            fast.third_username=userName;
            fast.third_type=type;
            if ([type isEqualToString:@"wechat"]) {
                fast.third_info=info;
            }else if ([type isEqualToString:@"weibo"]){
                fast.third_info=value;
            }else if ([type isEqualToString:@"qq"]){
                fast.third_info=value;
            }
            [SYObject endLoading];
            [self.navigationController pushViewController:fast animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败,请检查网络"];
        [SYObject endLoading];
    }];
}
-(void)doTimer_third_success{
    [SYObject endLoading];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
