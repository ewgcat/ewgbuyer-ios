//
//  ScanLoginViewController.m
//  My_App
//
//  Created by apple on 15-2-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ScanLoginViewController.h"
#import "ASIFormDataRequest.h"
#import "FirstViewController.h"

@interface ScanLoginViewController (){
    ASIFormDataRequest *request3;
}

@end

@implementation ScanLoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request3 clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码登陆";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackBtn];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width- 187)/2, 10+64, 187, 76)];
    imageView.image = [UIImage imageNamed:@"pc.png"];
    [self.view addSubview:imageView];
    
     UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 96+64, ScreenFrame.size.width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.numberOfLines = 0;
     label.text = @"e网购电脑端登录确认";
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake((ScreenFrame.size.width-260)/2, 146+50+64, 260, 34);
    [button setTitle:@"确认登陆电脑端" forState:UIControlStateNormal];
    button.backgroundColor = MY_COLOR;
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont boldSystemFontOfSize:18];
    button.tag = 101;
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
    button2.frame =CGRectMake((ScreenFrame.size.width-260)/2, 146+50+40+64, 260, 34);
    button2.tag = 102;
    button2.backgroundColor = [UIColor colorWithRed:115/255.0f green:190/255.0f blue:75/255.0f alpha:1];
    [button2 setTitle:@"取消" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font  = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:button2];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;

}
#pragma mark - UI搭构
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark  - 点击事件
-(void)backBtnClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)doTimer_success{
   [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissToRootViewController];
}
-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        //发起同意的请求了
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSArray *arrObjc3;
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            //提示登陆后可实现扫码登录
            [SYObject failedPrompt:@"手机端登录后才可实现扫码登录"];
        }else{
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SCAN_LOGIN_URL]];
            request3=[ASIFormDataRequest requestWithURL:url3];
            if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
            }else{
                arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                [request3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            }
            FirstViewController *th = [FirstViewController sharedUserDefault];
            NSArray *arr = [th.scanStr componentsSeparatedByString:@"qr_session_id="];
            NSString *str1 = arr[1];
            NSString *str2 = [str1 componentsSeparatedByString:@","][0];
            [request3 setPostValue:str2 forKey:@"qr_id"];
            NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
            [request3 setRequestHeaders:dicMy3];
            request3.tag = 101;
            request3.delegate = self;
            [request3 setDidFailSelector:@selector(urlRequestFailed:)];
            [request3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request3 startAsynchronous];
        }
    }
    if (btn.tag == 102) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"扫码登陆：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] intValue] == 100) {
            //提示登陆成功 并返回前一页面
            [SYObject failedPrompt:@"电脑端登陆成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_success) userInfo:nil repeats:NO];
        }else{
            //提示登陆事变
            [SYObject failedPrompt:@"电脑端登录失败"];
        }
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

@end
