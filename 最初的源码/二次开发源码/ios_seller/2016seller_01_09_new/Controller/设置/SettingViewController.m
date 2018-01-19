//
//  SettingViewController.m
//  SellerApp
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "NilCell.h"
#import "AppDelegate.h"
#import "sqlService.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [signOutBtn.layer setMasksToBounds:YES];
    [signOutBtn.layer setCornerRadius:4.0];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//清理缓存方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
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
    if (alertView.tag == 102) {
        if (buttonIndex == 0){//删除
            sqlService *del = [[sqlService alloc]init];
            if ([del deleteChatList]) {
                NSLog(@"成功删除");
            }else{
                NSLog(@"删除失败");
            }
            if ([del deleteTestList]) {
                NSLog(@"成功删除");
            }else{
                NSLog(@"删除失败");
            }
        }
    }
    if(alertView.tag == 103){
        if (buttonIndex == 0){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"user_information.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
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
                [self performSelectorOnMainThread:@selector(clearCacheSuccessOut) withObject:nil waitUntilDone:YES];
            });
            
            sqlService *del = [[sqlService alloc]init];
            if ([del deleteChatList]) {
                NSLog(@"成功删除");
            }else{
                NSLog(@"删除失败");
            }
            
            [MyObject failedPrompt:@"已退出当前账户"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_out) userInfo:nil repeats:NO];
        }
    }
}
-(void)doTimer_out{
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
    app.fist_View.hidden = NO;
    label_prompt.hidden = YES;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
-(void)clearCacheSuccess{
    [MyObject failedPrompt:@"缓存清理成功"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)doTimer{
    label_prompt.hidden = YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cleanImageBtnClicked:(id)sender {
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"取消", nil];
    alv.tag = 101;
    [alv show];
}

- (IBAction)cleanChatBtnClicked:(id)sender {
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除聊天记录" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"取消", nil];
    alv.tag = 102;
    [alv show];
}

- (IBAction)signOutBtnClicked:(id)sender {
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出当前账户" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
    alv.tag = 103;
    [alv show];
}
/*
 AboutUsViewController * aboutUsVC = [AboutUsViewController new];
 [self.navigationController pushViewController:aboutUsVC animated:YES];
 */
@end
