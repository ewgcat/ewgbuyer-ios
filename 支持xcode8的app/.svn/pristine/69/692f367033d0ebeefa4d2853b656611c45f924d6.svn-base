//
//  rechargeCardRecordViewController.m
//  My_App
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "rechargeCardRecordViewController.h"
#import "rechargeCardCell.h"

@interface rechargeCardRecordViewController ()

@end

@implementation rechargeCardRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"充值记录";
    [self createBackBtn];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    dataArray = [[NSMutableArray alloc]initWithArray:[[NSArray alloc] initWithObjects:@"100",@"200",@"300",@"400",@"500", nil]];
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MyTableView setEditing:NO];
}
#pragma mark - tabelView方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSLog(@"要删除啦~~~~~");
        
    }else{
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    rechargeCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeCardCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rechargeCardCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row%3==0) {
        cell.rechargeStatus.textColor = [UIColor redColor];
        cell.rechargeStatus.text = @"充值失败";
    }else if (indexPath.row%3 == 1){
        cell.rechargeStatus.textColor = [UIColor greenColor];
        cell.rechargeStatus.text = @"充值成功";
    }else{
        cell.rechargeStatus.textColor = [UIColor blackColor];
        cell.rechargeStatus.text = @"去充值";
    }
    cell.money.text = [dataArray objectAtIndex:indexPath.row];
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
