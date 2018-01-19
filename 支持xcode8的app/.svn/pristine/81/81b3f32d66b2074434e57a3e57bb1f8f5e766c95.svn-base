//
//  spendingBalanceViewController.m
//  My_App
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "spendingBalanceViewController.h"
#import "spendingBalanceCell.h"

@interface spendingBalanceViewController ()

@end

@implementation spendingBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"余额支出明细";
    [self createBackBtn];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_MyTableView setEditing:NO];
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *labelTT = [[UILabel alloc]init];
    labelTT.text = @"退货服务号为re1320150428143925的商品退款成功，预存款790.0元已存入您的账户";
    labelTT.numberOfLines = 0;
    CGRect labelFrame = CGRectMake(15, 55, 0, 0.0);
    labelFrame.size = [labelTT sizeThatFits:CGSizeMake(ScreenFrame.size.width-30,  0)];
    return 55+labelFrame.size.height+15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"spendingBalanceCell";
    spendingBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"spendingBalanceCell" owner:self options:nil] lastObject];
    }
    cell.desLabel.text = @"退货服务号为re1320150428143925的商品退款成功，预存款790.0元已存入您的账户";
    CGRect labelFrame = CGRectMake(15, 55, 0.0, 0.0);
    labelFrame.size = [cell.desLabel sizeThatFits:CGSizeMake(ScreenFrame.size.width-30,  0)];
    [cell.desLabel setFrame:labelFrame];
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
