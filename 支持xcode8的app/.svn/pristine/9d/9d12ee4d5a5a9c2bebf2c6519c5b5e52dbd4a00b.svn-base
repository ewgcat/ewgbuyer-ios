//
//  rechargeViewController.m
//  My_App
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "rechargeViewController.h"
#import "addressListViewController.h"
#import "rechargeRecordViewController.h"

@interface rechargeViewController ()

@end

static rechargeViewController *singleInstance=nil;

@implementation rechargeViewController

+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}
+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机充值";
    [self createBackBtn];
    
    [self selfLayer];
    
    numberTextField.delegate = self;
    numberTextField.keyboardType =  UIKeyboardTypeNumberPad;
    
    [contactsBtn addTarget:self action:@selector(contactsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    rechargeBtn.backgroundColor = [UIColor lightGrayColor];
    
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject failedPrompt:prompt];
}
- (BOOL)checkTel:(NSString *)str{
    if ([str length] == 0) {
        [self failedPrompt:@"电话号码不能为空"];
        
        rechargeBtn.enabled = NO;
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        [self failedPrompt:@"请输入正确的手机号"];
        rechargeBtn.enabled = NO;
        return NO;
    }
    rechargeBtn.enabled = YES;
    return YES;
}
-(void)dismissKeyBoard{
    [numberTextField resignFirstResponder];
}
-(void)selfLayer{
    [topView.layer setMasksToBounds:YES];
    [topView.layer setCornerRadius:2];
    topView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    topView.layer.borderWidth = 0.5;
    
    [tenBtn.layer setMasksToBounds:YES];
    [tenBtn.layer setCornerRadius:2];
    tenBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tenBtn.layer.borderWidth = 0.5;
    [tenBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    tenBtn.tag = 101;
    
    [twentyBtn.layer setMasksToBounds:YES];
    [twentyBtn.layer setCornerRadius:2];
    twentyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    twentyBtn.layer.borderWidth = 0.5;
    [twentyBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    twentyBtn.tag = 102;
    
    [thirtyBtn.layer setMasksToBounds:YES];
    [thirtyBtn.layer setCornerRadius:2];
    thirtyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    thirtyBtn.layer.borderWidth = 0.5;
    [thirtyBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    thirtyBtn.tag = 103;
    
    [fiftyBtn.layer setMasksToBounds:YES];
    [fiftyBtn.layer setCornerRadius:2];
    fiftyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    fiftyBtn.layer.borderWidth = 0.5;
    [fiftyBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    fiftyBtn.tag = 104;
    
    [hundredBtn.layer setMasksToBounds:YES];
    [hundredBtn.layer setCornerRadius:2];
    hundredBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    hundredBtn.layer.borderWidth = 0.5;
    [hundredBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    hundredBtn.tag = 105;
    
    [two_hundredBtn.layer setMasksToBounds:YES];
    [two_hundredBtn.layer setCornerRadius:2];
    two_hundredBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    two_hundredBtn.layer.borderWidth = 0.5;
    [two_hundredBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    two_hundredBtn.tag = 106;
    
    [three_hundredBtn.layer setMasksToBounds:YES];
    [three_hundredBtn.layer setCornerRadius:2];
    three_hundredBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    three_hundredBtn.layer.borderWidth = 0.5;
    [three_hundredBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    three_hundredBtn.tag = 107;
    
    [five_hundredBtn.layer setMasksToBounds:YES];
    [five_hundredBtn.layer setCornerRadius:2];
    five_hundredBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    five_hundredBtn.layer.borderWidth = 0.5;
    [five_hundredBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    five_hundredBtn.tag = 108;
    
    [selfBtn.layer setMasksToBounds:YES];
    [selfBtn.layer setCornerRadius:2];
    selfBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    selfBtn.layer.borderWidth = 0.5;
    [selfBtn addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    selfBtn.tag = 109;
    
    [tenBtn setBackgroundColor:[UIColor redColor]];
    moneyLabel.text = @"10";
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *button2 = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 0, 56, 44) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"我的充值" setTitleFont:12 setbackgroundColor:[UIColor clearColor]];
    [button2 addTarget:self action:@selector(rechargeRecordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)rechargeRecordBtnClicked{
    rechargeRecordViewController *rechargeRecord = [[rechargeRecordViewController alloc]init];
    [self.navigationController pushViewController:rechargeRecord animated:YES];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)contactsBtnClicked{
    addressListViewController *address = [[addressListViewController  alloc]init];
    [self presentViewController:address animated:YES completion:nil];
}
-(void)rechargeBtnClicked{
    NSLog(@"去充值");
}
-(void)moneyBtnClicked:(UIButton *)btn{
    [numberTextField resignFirstResponder];
    switch (btn.tag-100) {
        case 1:
            [tenBtn setBackgroundColor:[UIColor redColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"10";
            break;
        case 2:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor redColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"20";
            break;
        case 3:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor redColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"30";
            break;
        case 4:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor redColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"50";
            break;
        case 5:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor redColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"100";
            break;
        case 6:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor redColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"200";
            break;
        case 7:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor redColor]];
            [five_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            moneyLabel.text = @"300";
            break;
        case 8:
            [tenBtn setBackgroundColor:[UIColor whiteColor]];
            [twentyBtn setBackgroundColor:[UIColor whiteColor]];
            [thirtyBtn setBackgroundColor:[UIColor whiteColor]];
            [fiftyBtn setBackgroundColor:[UIColor whiteColor]];
            [hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [two_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [three_hundredBtn setBackgroundColor:[UIColor whiteColor]];
            [five_hundredBtn setBackgroundColor:[UIColor redColor]];
            moneyLabel.text = @"500";
            break;
        case 9:
            
            break;
        default:
            break;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [numberTextField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    if (_phoneNumber.length == 0) {
        
    }else{
        if ([_phoneNumber rangeOfString:@"+86 "].location !=NSNotFound) {
            numberTextField.text = [[_phoneNumber componentsSeparatedByString:@" "] objectAtIndex:1];
        }else if ([_phoneNumber rangeOfString:@"+86"].location !=NSNotFound){
            numberTextField.text = [[_phoneNumber componentsSeparatedByString:@"+86"] objectAtIndex:1];
        }
        if([self checkTel:numberTextField.text] == YES){
            rechargeBtn.backgroundColor = [UIColor redColor];
        }else{
            rechargeBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _phoneNumber = @"";
}
#pragma mark - uitextfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [numberTextField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([self checkTel:textField.text] == YES){
        rechargeBtn.backgroundColor = [UIColor redColor];
    }else{
        rechargeBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return YES;
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
