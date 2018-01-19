//
//  ReturnOutViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/4/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "ReturnOutViewController.h"
#import "buyer_returnViewController.h"
#import "returnMoneyViewController.h"

@interface ReturnOutViewController ()

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) buyer_returnViewController *vc1;
@property (nonatomic, strong) returnMoneyViewController *vc2;
@property (nonatomic, weak) UIViewController *currentViewController;

@end

@implementation ReturnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackBtn];
    [self setupNaviBar];
    [self setChildViewController];
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
-(void)setupNaviBar{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"商品退货",@"团购退款",nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    self.navigationItem.titleView = seg;
    _segmentedControl = seg;
    _segmentedControl.frame = CGRectMake(0.0, 0.0,200.0, 32.0);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
                forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentedControl];
}
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl{
    [self transitionFromViewController:_currentViewController == self.vc1?self.vc1: self.vc2 toViewController:_currentViewController == self.vc1?self.vc2:self.vc1 duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
    } completion:^(BOOL finished){
        _currentViewController = _currentViewController == self.vc1?self.vc2:self.vc1;
    }];
}
-(void)setChildViewController{
    self.vc1 = [[buyer_returnViewController alloc]init];
    [self addChildViewController:self.vc1];
    self.vc2 = [[returnMoneyViewController alloc]init];
    [self addChildViewController:self.vc2];
    
    [self.view addSubview:self.vc1.view];
    _currentViewController = self.vc1;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
