//
//  StoreFirstViewController.m
//  My_App
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "StoreFirstViewController.h"

@interface StoreFirstViewController ()
{
    __weak IBOutlet UIView *longv;
    UIView *noHaveView;

}
@end

@implementation StoreFirstViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self designPage];
}
#pragma mark -界面
-(void)createNavigation{
    
    UIView *titleView=[LJControl viewFrame:CGRectMake(0,0, 200, 30) backgroundColor:[UIColor whiteColor]];
    UIImageView *titleImage=[LJControl imageViewFrame:CGRectMake(5, 5,20, 20) setImage:@"ic_search_normal.png" setbackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleImage];
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(40, 5,150, 20) setText:@"搜索商品" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor grayColor] textAlignment:NSTextAlignmentLeft ];
    [titleView addSubview:titleLabel];
    [titleView.layer setCornerRadius:8.0];
    [titleView.layer setMasksToBounds:YES];
    self.navigationItem.titleView=titleView;
//    [self.navigationController.navigationBar addSubview:titleView];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0,23, 23);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    buttonChat.tag=1001;
    [buttonChat addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[ UIBarButtonItem alloc]initWithCustomView:buttonChat];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    UIBarButtonItem *bar4 = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"kefu_lj.png"] forState:UIControlStateNormal];
    button.tag=1002;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems =@[bar2,bar4,bar3];



}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xf0f0f0);
    //暂无数据
    noHaveView=[LJControl viewFrame:CGRectMake(0, 64, ScreenFrame.size.width,ScreenFrame.size.height-64) backgroundColor:[UIColor whiteColor]];
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,50, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [noHaveView addSubview:noDataImage];
    UILabel *nolabel=[LJControl labelFrame:CGRectMake(0, 350, ScreenFrame.size.width, 21) setText:@"该店暂无商品" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter];
    [noHaveView addSubview:nolabel];
    [self.view addSubview:noHaveView];
    noHaveView.hidden=YES;
    
    //加载圆圈
    UIView *la=[LJControl viewFrame:CGRectMake(ScreenFrame.size.width/2-50,150, 100, 100) backgroundColor:[UIColor       blackColor]];
    la.alpha=0.8;
    [la.layer setCornerRadius:8.0];
    [la.layer setMasksToBounds:YES];
    
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [testActivityIndicator setFrame:CGRectMake(0, 0,44, 44)];
    testActivityIndicator.center = CGPointMake(50.0f,40.0f);//只能设置中心，不能设置大小
    //[testActivityIndicator setFrame = CGRectMack(100, 100, 100, 100)];//不建议这样设置，因为UIActivityIndicatorView是不能改变大小只能改变位置，这样设置得到的结果是控件的中心在（100，100）上，而不是和其他控件的frame一样左上角在（100， 100）长为100，宽为100.
    [la addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    //[testActivityIndicator stopAnimating]; // 结束旋转
    //[testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    UILabel *label=[LJControl labelFrame:CGRectMake(0, 80, 100,20) setText:@"正在加载....." setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [la addSubview:label];
    [longv addSubview:la];
    longv.hidden=YES;

}
-(void)buttonClicked:(UIButton *)btn{





}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
