//
//  MuchViewController.m
//  My_App
//
//  Created by apple on 14-7-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MuchViewController.h"
#import "ContactUsViewController.h"
#import "UsersHelpViewController.h"
#import "AboutISkyShopViewController.h"
#import "LoginViewController.h"
#import "SoftwareAgreementViewController.h"
#import "feedBackViewController.h"
#import "ThirdViewController.h"
@interface MuchViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MuchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"更多";
        [self createBackBtn];
    }
    return self;
}
-(void)createBackBtn{
//    UIButton *button = [LJControl backBtn];
//    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem =bar;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLogoutBtn];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
-(void)setupLogoutBtn{
    BOOL login;
    [SYObject hasUserLogedIn:&login];
    if (!login) {
        _logoutBtn.hidden = YES;
    }else {
        _logoutBtn.hidden = NO;
    }
    _logoutBtn.layer.cornerRadius = 5.f;
    [_logoutBtn.layer setMasksToBounds:YES];
    [_logoutBtn addTarget:self action:@selector(logoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)logoutBtnClicked:(id)sender{
    //退出登录操作
    //1.拿到个人中心控制器
    NSInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[count-2];
    LoginViewController *lvc;
    if ([vc isKindOfClass:[LoginViewController class]]) {
        lvc = (LoginViewController *)vc;
    }
    //2.调用该控制器的方法来清空登录数据(删除本地information文件+清空登录时才显示的数据)
    [lvc logOut];
      //购物车数量提示
    [SYShopAccessTool getItemBadgeValue];
   //3,清除无货商品
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ErrorGoodsData"];
    
    //4.pop
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
                }
            }
            [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });
    }
}

-(void)clearCacheSuccess{
    [SYObject failedPrompt:@"缓存清理成功"];
}
-(void)tiaozhuan{
    LoginViewController *lgo = [LoginViewController sharedUserDefault];
    lgo.logBool = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)contactUsBtnClicked:(id)sender {
    ContactUsViewController *usersHelpVC = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:usersHelpVC animated:YES];
}
- (IBAction)usehelpBtnClicked:(id)sender {
    UsersHelpViewController *usersHelpVC = [[UsersHelpViewController alloc]init];
    [self.navigationController pushViewController:usersHelpVC animated:YES];
}
- (IBAction)clearBtnClicked:(id)sender {
    [OHAlertView showAlertWithTitle:@"清除缓存" message:@"您确认清除缓存吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"area_id"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
                NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [cachPath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
                    }
                }
                [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
            });
        }
    }];

}
- (IBAction)aboutBtnClicked:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    AboutISkyShopViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"AboutISkyShopViewController"];
    [self.navigationController pushViewController:ordrt animated:YES];
}
- (IBAction)agreeBtcClicked:(id)sender {
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    SoftwareAgreementViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"SoftwareAgreementViewController"];
    [self.navigationController pushViewController:ordrt animated:YES];
}

- (IBAction)feedBackBtnClicked:(id)sender {
    feedBackViewController *feed = [[feedBackViewController alloc]init];
    [self.navigationController pushViewController:feed animated:YES];
}

@end
