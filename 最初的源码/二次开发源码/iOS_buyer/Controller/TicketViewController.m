//
//  TicketViewController.m
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TicketViewController.h"
#import "ThirdViewController.h"
@interface TicketViewController ()

@end

@implementation TicketViewController
{

    UIView *backView;
    UIView *view1;
    UIView *view2;


}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发票信息";
    }
    return self;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    // Do any additional setup after loading the view from its nib.
    _taitou.text = @"个人";
    btnTag= 200;
    _taitou.delegate = self;
    _quedingBtn.layer.cornerRadius = 4.f;
    [_quedingBtn.layer setMasksToBounds:YES];
    self.detail.layer.cornerRadius = 4.f;
    [self.detail.layer setMasksToBounds:YES];
    [self.detail addTarget:self action:@selector(detailClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_quedingBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_quedingBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    self.lab1.text=@"专用发票资质上传及审核结果查询地址:";
    self.lab2.text=@"个人中心->账号管理->增票资质->添加或修改";
    self.lab3.text=@"注意:只能在电脑端操作";
    [self alertView];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
  backView.hidden=YES;
    view1.hidden=YES;
    view2.hidden=YES;


}
-(void)alertView
{
    view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 100)];
    view1.backgroundColor=[UIColor blackColor];
    view1.alpha=0.6;
     view2=[[UIView alloc]initWithFrame:CGRectMake(0, 300, ScreenFrame.size.width, ScreenFrame.size.height-300)];
    view2.backgroundColor=[UIColor blackColor];
    view2.alpha=0.6;
    view1.hidden=YES;
    view2.hidden=YES;
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenFrame.size.width, 200)];
    backView.backgroundColor=UIColorFromRGB(0xf1f1f1);
    backView.layer.cornerRadius = 4.f;
    [backView.layer setMasksToBounds:YES];
    [self.view addSubview:backView];
    backView.hidden=YES;
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake((backView.size.width-240)/2, 10, 240, 20)];
    lab1.text=[NSString stringWithFormat:@"纳税人识别码  : %@",[th.ticdic objectForKey:@"taxpayerCode"]];
    [backView addSubview:lab1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake((backView.size.width-240)/2, 40,240, 20)];
    lab2.text=[NSString stringWithFormat:@"注   册   地   址 : %@",[th.ticdic objectForKey:@"registerAddress"]];
    [backView addSubview:lab2];

    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake((backView.size.width-240)/2, 70, 240, 20)];
    lab3.text=[NSString stringWithFormat:@"注   册   电   话 : %@",[th.ticdic objectForKey:@"registerPhone"]];
    [backView addSubview:lab3];

    UILabel *lab4=[[UILabel alloc]initWithFrame:CGRectMake((backView.size.width-240)/2, 100, 240, 20)];
    lab4.text=[NSString stringWithFormat:@"开   户   银   行 : %@",[th.ticdic objectForKey:@"registerbankName"]];
    [backView addSubview:lab4];

    UILabel *lab5=[[UILabel alloc]initWithFrame:CGRectMake((backView.size.width-240)/2, 130, 240, 20)];
    lab5.text=[NSString stringWithFormat:@"银   行   账   户 : %@",[th.ticdic objectForKey:@"registerbankAccount"]];
    [backView addSubview:lab5];

    UIButton *btn=[UIButton buttonWithType:(UIButtonTypeCustom)];
//    btn.frame=CGRectMake(0, backView.size.height-44, backView.size.width, 44);
    btn.frame=CGRectMake((backView.size.width-250)*0.5, backView.size.height-44, 250, 40);
    btn.backgroundColor=UIColorFromRGB(0xf15353);
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4.0];
    
    [btn addTarget:self action:@selector(sureBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    [backView addSubview:btn];

}
-(void)sureBtn
{
    backView.hidden=YES;
    view1.hidden=YES;
    view2.hidden=YES;

}
-(void)detailClick
{
    backView.hidden=NO;
    view1.hidden=NO;
    view2.hidden=NO;

//[OHAlertView showAlertWithTitle:@"" message:[NSString stringWithFormat:@"纳税人识别码: %@\n注册地址: %@\n注册电话: %@\n开户银行: %@\n银行账户: %@",[th.ticdic objectForKey:@"taxpayerCode"],[th.ticdic objectForKey:@"registerAddress"],[th.ticdic objectForKey:@"registerPhone"],[th.ticdic objectForKey:@"registerbankName"],[th.ticdic objectForKey:@"registerbankAccount"]] cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//    
//}];

}
- (void)willPresentAlertView:(UIAlertView *)alertView{
    for( UIView * view in alertView.subviews )
    {
        
        if( [view isKindOfClass:[UILabel class]] )
            
        {
            
            UILabel* label = (UILabel*) view;
            
            label.textAlignment = NSTextAlignmentLeft;
            
        }
        
    }
    
    
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    _puBtn = nil;
    _zeng = nil;
    _quedingBtn = nil;
    _taitou = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)btnClicked:(id)sender {
    
    
    UIButton *btn = (UIButton*)sender;
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
   
    
    if (btn.tag == 200 || btn.tag == 100) {
        //普通
        btnTag = 200;
        [_puBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
        [_zeng setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        th.tic_pu = @"普通发票";
        _taitou.text = @"个人";
        _taitou.enabled=YES;
        self.detail.hidden=YES;
        
    }
    if (btn.tag == 201 || btn.tag == 101) {
        if (th.ticBOOL==NO) {
            btn.selected=NO;
            self.detail.hidden=YES;
            [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉, 当前没有可用的专用发票" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                
            }];
        }else{
        //增值
        btnTag = 201;
        [_puBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        [_zeng setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
        th.tic_pu = @"专用发票";
        _taitou.text = [th.ticdic objectForKey:@"companyName"];
        _taitou.enabled=NO;
        self.detail.hidden=NO;
            
        }
    }
    if (btn.tag == 202) {
        //确定
        if (_taitou.text.length ==0) {
            [OHAlertView showAlertWithTitle:@"提示" message:@"发票抬头不能为空" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if(btnTag == 0){
            [OHAlertView showAlertWithTitle:@"提示" message:@"请选择发票类型" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else{
            if (btnTag == 200) {
                th.tic_pu = @"普通发票";
            }
            th.tic_taitou = _taitou.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
