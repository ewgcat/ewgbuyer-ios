//
//  BaseTableViewControllerNoTabbar.m
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "BaseTableViewControllerNoTabbar.h"

@interface BaseTableViewControllerNoTabbar ()<UIGestureRecognizerDelegate>

@end

@implementation BaseTableViewControllerNoTabbar

#pragma mark - 视图的生命周期方法
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBtn];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    NSLog(@"%@ 视图加载完毕!",self.classForCoder);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 导航栏按钮
-(void)setLeftBtn{
    [self setLeftBtnWithTitle:@"" normalImg:@"back_lj" highlightImg:nil target:self action:@selector(backAction)];
}
-(void)setRightBtn{
    [self setRightBtnWithTitle:@"" normalImg:@"delete" highlightImg:nil target:self action:@selector(logout)];
}
#pragma mark - 抽象方法
-(void)setLeftBtnWithTitle:(NSString *)title normalImg:(NSString *)normalImg highlightImg:(NSString *)highlightImg target:(id)target action:(SEL)action{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:title forState:UIControlStateNormal];
    if (normalImg) {
        [leftButton setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    }
    if (highlightImg) {
        [leftButton setBackgroundImage:[UIImage imageNamed:highlightImg] forState:UIControlStateHighlighted];
    }
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = backBar;
}
-(void)setRightBtnWithTitle:(NSString *)title normalImg:(NSString *)normalImg highlightImg:(NSString *)highlightImg target:(id)target action:(SEL)action{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    [rightButton setTitle:title forState:UIControlStateNormal];
    if (normalImg) {
        [rightButton setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    }
    if (highlightImg) {
        [rightButton setBackgroundImage:[UIImage imageNamed:highlightImg] forState:UIControlStateHighlighted];
    }
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    NSArray *oldRight = self.navigationItem.rightBarButtonItems;
    NSMutableArray *newRight = nil;
    if (oldRight) {
        newRight = [oldRight mutableCopy];
    }else{
        newRight = [NSMutableArray array];
    }
    [newRight addObject:rightBar];
    self.navigationItem.rightBarButtonItems = newRight;
}
#pragma mark - 返回动作
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)logout{
    [LJControl cleanAll];
    AppDelegate * app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
#pragma mark - 界面手势滑动
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}

@end
