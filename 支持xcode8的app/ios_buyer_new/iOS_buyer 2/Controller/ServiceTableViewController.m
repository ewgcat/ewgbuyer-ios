//
//  ServiceTableViewController.m
//  My_App
//
//  Created by barney on 15/11/23.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "ServiceTableViewController.h"
#import "TSViewController.h"
#import "MyConsultViewController.h"
@interface ServiceTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"服务中心";
//    [self createBackBtn];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 45, ScreenFrame.size.width, 0.5)];
    view.backgroundColor=UIColorFromRGB(0XDCDCDC);
    [self.view addSubview:view];
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
                        
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell的选中样式
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell1 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell2 setSelectionStyle:(UITableViewCellSelectionStyleNone)];

    
    if (indexPath.row==0)
    {
        //我的投诉
        TSViewController *tsVC=[[TSViewController alloc]init];
        
        [self.navigationController pushViewController:tsVC animated:YES];
        
    }
    else if (indexPath.row==1){
        //我的咨询
        MyConsultViewController *mcVC = [[MyConsultViewController alloc]init];
        [self.navigationController pushViewController:mcVC animated:YES];
    }
    
}
@end
