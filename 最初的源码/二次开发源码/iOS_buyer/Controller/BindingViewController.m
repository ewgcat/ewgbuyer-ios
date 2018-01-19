//
//  BindingViewController.m
//  My_App
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title= @"邮箱绑定";
    [self createBackBtn];
    
    [bundingBtn.layer setMasksToBounds:YES];
    [bundingBtn.layer setCornerRadius:4];
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
- (IBAction)bundingBtnClicked:(id)sender {
    if (_mailTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        [SYObject failedPrompt:@"绑定邮箱或密码不能为空"];
    }else{
        
    }
}
@end
