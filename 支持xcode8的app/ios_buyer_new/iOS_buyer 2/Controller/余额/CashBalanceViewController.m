//
//  CashBalanceViewController.m
//  My_App
//
//  Created by barney on 15/12/14.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "CashBalanceViewController.h"
#import "UserInfoModel.h"
#import "PushCashViewController.h"
#import "ThirdViewController.h"
@interface CashBalanceViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end

@implementation CashBalanceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self createBackBtn];
    self.title=@"现金充值";
    
    [self createView];
     [SYObject startLoading];
    [SYShopAccessTool currentUserDetails:^(UserInfoModel *model) {
        [SYObject endLoading];
        self.ableCash.text=[NSString stringWithFormat:@"￥%@", model.balance];
       
        
    } failure:^(NSString *errStr) {
        
        [SYObject failedPrompt:@"请求出错"];
    }];
    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
   
}
-(void)viewWillDisappear:(BOOL)animated
{
 self.tabBarController.tabBar.hidden=NO;
    
}
-(void)createView
{
    self.balanceBtn.backgroundColor=UIColorFromRGB(0xf15353);
    [self.balanceBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.balanceBtn.layer.cornerRadius=4;

    self.ableCash.text=[NSString stringWithFormat:@"￥%@",self.cashLab.text];
    self.ableCash.textColor=[UIColor redColor];
    self.putCash.placeholder=@"请输入充值金额";
    self.putCash.delegate=self;
    self.putCash.borderStyle= UITextBorderStyleNone;
    self.putCash.keyboardType = UIKeyboardTypeDecimalPad;//键盘类型
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [self.putCash setInputAccessoryView:inputView];

    
//    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
//    [topView setBarStyle:UIBarStyleBlack];
//    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//    [topView setItems:buttonsArray];
//    [self.putCash setInputAccessoryView:topView];

}
-(void)dismissKeyBoard{
    [self.putCash resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.putCash resignFirstResponder];
    return YES;
}
- (IBAction)balanceBtn:(id)sender {
    
    if (self.putCash.text.floatValue>0) {
    //跳到支付方式界面
        [SYObject startLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SYObject endLoading];
        });
    PushCashViewController *pushCash=[[PushCashViewController alloc]init];
    NSString *pushCashSaveUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,PushCashSave_URL];
    // 获取本地文件
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"pd_amount":self.putCash.text
                          };
    [[Requester managerWithHeader]POST:pushCashSaveUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        if(code ==100)
        {
            NSLog(@"充值订单保存%@",resultDict);
            pushCash.order_cash=[NSString stringWithFormat:@"%@",resultDict[@"order_amount"]];
             pushCash.order_sn=[NSString stringWithFormat:@"%@",resultDict[@"order_sn"]];
            pushCash.order_id=[NSString stringWithFormat:@"%@",resultDict[@"order_id"]];
            [self.navigationController pushViewController:pushCash animated:YES];
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
    }];
     }else if (self.putCash.text.length==0)
     {
     
     [SYObject failedPrompt:@"充值金额不能为空"];
     
     }
    else
    {
        [SYObject failedPrompt:@"请输入正确金额"];
    
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.putCash resignFirstResponder];
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
