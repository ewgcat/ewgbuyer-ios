//
//  evaluationTieViewController.m
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "evaluationTieViewController.h"
#import "goodsTie_evaluationCell.h"

@interface evaluationTieViewController ()

@end

@implementation evaluationTieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"追加评论";
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
//完场View
-(UIToolbar *)overView{
       
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    
    return inputView;
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    goodsTie_evaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsTie_evaluationCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsTie_evaluationCell" owner:self options:nil] lastObject];
    }
    cell.contentTextView.delegate = self;
    
    [cell.contentTextView setInputAccessoryView:[self overView]];
    
    return cell;
}
-(void)dismissKeyBoard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
#pragma mark - textview delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, -60, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
    
    return YES;
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
