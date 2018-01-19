//
//  rechargeRecordViewController.m
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "rechargeRecordViewController.h"
#import "recordCell.h"

@interface rechargeRecordViewController ()

@end

@implementation rechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"我的充值";
    [self createBackBtn];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rechargeBtnClicked:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    recordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"recordCell" owner:self options:nil] lastObject];
    }
    [cell.rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row%3==0) {
        cell.rechargeStatus.textColor = [UIColor redColor];
        cell.rechargeStatus.text = @"充值失败";
        cell.rechargeBtn.hidden = YES;
    }else if (indexPath.row%3 == 1){
        cell.rechargeStatus.textColor = [UIColor greenColor];
        cell.rechargeStatus.text = @"充值成功";
        cell.rechargeBtn.hidden = YES;
    }else{
        cell.rechargeStatus.textColor = [UIColor blackColor];
        cell.rechargeStatus.text = @"去充值";
        cell.rechargeBtn.hidden = NO;
    }
    return cell;
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
