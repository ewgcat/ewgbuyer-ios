//
//  AppDelegate.h
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDPageControl;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    UITextField *userNameField;//姓名
    UITextField *userPasswordField;//密码
    DDPageControl *pageControl ;//点击放大后 的滑动原点
    UIScrollView *myScrollView;//可滑动scrollView
    UILabel *label_prompt;//提示label
    UIView *loadingV;//正在加载视图
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIView *fist_View;//提示登录View
@property (strong,nonatomic) UIView *log_View;//登录View

+(id)sharedUserDefault;
-(void)logView;
@end

