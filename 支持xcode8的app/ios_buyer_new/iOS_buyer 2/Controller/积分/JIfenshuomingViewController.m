//
//  JIfenshuomingViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/16.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "JIfenshuomingViewController.h"

@interface JIfenshuomingViewController ()

@end

@implementation JIfenshuomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"积分说明";
    self.view.backgroundColor=[UIColor whiteColor];
    UITextView *t=[[UITextView alloc]initWithFrame:CGRectMake(20, 20, ScreenFrame.size.width-20*2, ScreenFrame.size.height-64-40)];
    t.editable=NO;
//    t.text=@"e网购积分商城规则\n1.积分资格：\n凡在e网购商城注册成为VIP会员的用户皆可参与获得积分，凭相应积分可在积分商城任意兑换等额产品。\n2.如何获取积分：\n与以往不同，推广用户关注不再获得积分，积分只有在商城购物消费才可获得，会员消费额度达商城标准将自动升级对应等级会员，并且不会扣除相应额度积分。\n3.积分核算标准：\n商城消费1元获得1积分，未满1元不获得积分；会员在积分商城兑换产品后，系统将自动更改卡内积分；积分情况在会员中心可见，会员可随时查阅；会员积分不可转让，不可提现。\n4、本规则如有变动，以商城当日公告或最新VIP规则为准，e网购商城保有此项积分活动的最终解释权。\n5.本活动与苹果公司无关";
    t.text=@"1.以商城当日公告或最新VIP规则为准，e网购商城保有此项积分活动的最终解释权。\n2.本活动与苹果公司无关";
    t.font=[UIFont systemFontOfSize:16];
//    t.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:t];
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
