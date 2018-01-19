//
//  myEvaluationViewController.m
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "myEvaluationViewController.h"
#import "myEvaluation_tieCell.h"
#import "evaluationTieViewController.h"

@interface myEvaluationViewController ()

@end

@implementation myEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"我的评价";
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark - label计算高度
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect labelFrame = [self labelSizeHeight:@"发了空间发贺卡就都是饭哈坎京东方哈克剪短发哈会计法哈利SD卡就发生款到即发哈萨克的减肥哈利快递费" frame:CGRectMake(15, 35, 0.0, 0.0) font:15];
    return 96+70+labelFrame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"myEvaluation_tieCell";
    myEvaluation_tieCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"myEvaluation_tieCell" owner:self options:nil] lastObject];
    }
    [cell.labelContent setFrame:[self labelSizeHeight:@"发了空间发贺卡就都是饭哈坎京东方哈克剪短发哈会计法哈利SD卡就发生款到即发哈萨克的减肥哈利快递费" frame:CGRectMake(15, 96, 0.0, 0.0) font:15]];
    [cell.tieBtn addTarget:self action:@selector(tieBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tieBtnClicked:(UIButton *)btn{
    evaluationTieViewController *evaluation = [[evaluationTieViewController alloc]init];
    [self.navigationController pushViewController:evaluation animated:YES];
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
