//
//  feedBackViewController.m
//  My_App
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "feedBackViewController.h"
#import "feedbackCell.h"

@interface feedBackViewController ()

@end

@implementation feedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";
    [self createBackBtn];
    [_submiBtnClicked.layer setMasksToBounds:YES];
    [_submiBtnClicked.layer setCornerRadius:4];
    [_contactTextField.layer setMasksToBounds:YES];
    [_contactTextField.layer setCornerRadius:4];
    _contactTextField.delegate = self;
    _feedbackContent.delegate = self;
    [middleView.layer setMasksToBounds:YES];
    [middleView.layer setCornerRadius:4];
    [_contactTextField setInputAccessoryView:[self overToolbar]];
    [_feedbackContent setInputAccessoryView:[self overToolbar]];
    typeView.hidden = YES;
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    
    [_submiBtnClicked addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [typeImageView addGestureRecognizer:singleTapGestureRecognizer3];
}
-(void)disappear{
    typeView.hidden = YES;
}
#pragma mark - 完成
-(void)dismissKeyBoard{
    [_contactTextField resignFirstResponder];
    [_feedbackContent resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
}
-(UIToolbar *)overToolbar{
  
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];

    
    return inputView;
}
#pragma mark - 返回按钮
-(void)submitClicked{
    if ([_feedbackContent.text isEqualToString:@"欢迎提出您的宝贵意见！"]) {
        [SYObject failedPrompt:@"请输入宝贵意见"];
    }else if(_feedbackContent.text.length == 0 || _contactTextField.text.length == 0){
        [SYObject failedPrompt:@"意见或联系方式不能为空"];
    }else{
        
    }
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark - 点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectBtnClicked:(UIButton *)btn{
    
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, -100, self.view.frame.size.width, self.view.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
    return YES;
}
#pragma mark - textview
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"欢迎提出您的宝贵意见！"]) {
        textView.text = @"";
    }
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
    return YES;
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    feedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"feedbackCell" owner:self options:nil] lastObject];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    typeView.hidden = YES;
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

- (IBAction)feedbackTypeBtnClicked:(id)sender {
    typeView.hidden = NO;
}
@end
