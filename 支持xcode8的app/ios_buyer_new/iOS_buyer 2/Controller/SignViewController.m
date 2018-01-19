//
//  SignViewController.m
//  My_App
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SignViewController.h"
#import "ExchangeHomeViewController.h"

@interface SignViewController (){
    ASIFormDataRequest *requestStatus;
    ASIFormDataRequest *requestSign;
}

@end

@implementation SignViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self netWorking];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [requestSign clearDelegatesAndCancel];
    [requestStatus clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"每日签到";
    [self createBackBtn];
    [SignBtn.layer setMasksToBounds:YES];
    [SignBtn.layer setCornerRadius:18];
    
    //设置layer
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - 网络
-(void)netWorking{

    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3], nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId", nil];
    
    requestStatus = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GET_SIGN_STATUS_URL] setKey:keyArr setValue:valueArr];
    
    requestStatus.delegate = self;
    [requestStatus setDidFailSelector:@selector(RequestFailed:)];
    [requestStatus setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestStatus startAsynchronous];
}
-(void)urlSignRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"22dicBig==%@",dicBig);
        if (dicBig) {
            if (dicBig) {
                if ([[dicBig objectForKey:@"code"] intValue] == 200) {
                    todayLabel.text = @"今日您已经签过了，明天再来";
                    SignBtn.backgroundColor = RGB_COLOR(181, 181, 181);
                    SignBtn.enabled = NO;
                    [SignBtn setTitle:@"已签到" forState:UIControlStateNormal];
                    [SYObject failedPrompt:@"签到成功，明天再来"];
                }else{
                    [SYObject failedPrompt:@"签到失败，请重试"];
                }
            }
        }
    }else{
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig==%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 200) {
                todayLabel.text = [NSString stringWithFormat:@"今日签到可领取%@积分",[dicBig objectForKey:@"integralaviliable"]];
                SignBtn.backgroundColor = RGB_COLOR(241, 83, 83);
                SignBtn.enabled = YES;
                [SignBtn setTitle:@"立即签到" forState:UIControlStateNormal];
            }else{
                todayLabel.text = @"今日您已经签过了，明天再来";
                SignBtn.backgroundColor = RGB_COLOR(181, 181, 181);
                SignBtn.enabled = NO;
                [SignBtn setTitle:@"已签到" forState:UIControlStateNormal];
            }
        }
    }else{
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)SignAction:(id)sender {
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3], nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId", nil];
    
    requestSign = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,SIGNINTEGRAL_URL] setKey:keyArr setValue:valueArr];
    
    requestSign.delegate = self;
    [requestSign setDidFailSelector:@selector(RequestFailed:)];
    [requestSign setDidFinishSelector:@selector(urlSignRequestSucceeded:)];
    [requestSign startAsynchronous];
}
@end
