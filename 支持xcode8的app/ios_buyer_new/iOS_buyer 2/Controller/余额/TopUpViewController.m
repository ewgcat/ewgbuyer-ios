//
//  TopUpViewController.m
//  
//
//  Created by apple on 15/10/15.
//
//

#import "TopUpViewController.h"

@interface TopUpViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UITextField *AccNumberTextField;
    __weak IBOutlet UIButton *certainButton;
}
@end

@implementation TopUpViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self designPage];
    
}
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //导航栏
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:UIColorFromRGB(0Xdf0000)];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50, 22, 100, 40) setText:@"充值" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:titleLabel];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.frame=CGRectMake(15,30,15,23.5);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];
    
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xededed);
    
    AccNumberTextField.placeholder=@"请输入充值卡号";
    AccNumberTextField.delegate=self;
    AccNumberTextField.returnKeyType = UIReturnKeyDefault;//返回键的类型
    AccNumberTextField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    AccNumberTextField.textColor=UIColorFromRGB(0Xc8c8c8);
    //[AccNumberTextField becomeFirstResponder];
    
    certainButton.backgroundColor=UIColorFromRGB(0Xf15353);
    certainButton.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
    [certainButton.layer setMasksToBounds:YES];
    [certainButton.layer setCornerRadius:4.0];
    [certainButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [certainButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [certainButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];

}
//  button1普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}

//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        [AccNumberTextField resignFirstResponder];
        
        if(AccNumberTextField.text.length>0){
            [self getRechargeCardSaveCardSn:AccNumberTextField.text];
        }else{
            [SYObject failedPrompt:@"请输入充值卡号"];
        }
    }
    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
    
    
}

#pragma mark -数据
//验证
-(void)getRechargeCardValidateCardSn:(NSString *)card_sn{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&card_sn=%@",FIRST_URL,RECHARGECARDVALIDATE_URL,[fileContent objectAtIndex:3],[fileContent objectAtIndex:1],card_sn];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1000;
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    [request startAsynchronous];
}
//充值
-(void)getRechargeCardSaveCardSn:(NSString *)card_sn{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&card_sn=%@",FIRST_URL,RECHARGECARDSAVE_URL,[fileContent objectAtIndex:3],[fileContent objectAtIndex:1],card_sn];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1001;
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    if (request.tag==1000) {
        //充值卡验证
        if ([[dic objectForKey:@"status"]integerValue]==1) {
//            certainButton.backgroundColor=UIColorFromRGB(0Xdf0000);
//            [certainButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [SYObject failedPrompt:@"此充值卡不可用"];
        }

    }else if (request.tag==1001){
        //充值卡充值
        if ([[dic objectForKey:@"status"]integerValue]==1) {
            AccNumberTextField.text=@"";
            [SYObject failedPrompt:@"充值成功，请注意查收"];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popView) userInfo:nil repeats:NO];
        }else{
            [SYObject failedPrompt:@"充值失败，请稍后重试"];
        }

    
    
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject failedPrompt: @"网络在开小差，请检查后再试吧！"];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark UITextFieldDelegate
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([AccNumberTextField.text isEqualToString:@""]) {
//        labelTi.hidden = NO;
//        [self.view bringSubviewToFront:labelTi];
//        labelTi.text = @"请输入充值卡号";
//        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//    }else{
//        [self getRechargeCardValidateCardSn:AccNumberTextField.text];
//    }
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [UIView animateWithDuration:0.3 animations:^{
        [AccNumberTextField resignFirstResponder];
   // }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [AccNumberTextField resignFirstResponder];
    if ([AccNumberTextField.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请输入充值卡号"];
    }else{
        [self getRechargeCardValidateCardSn:AccNumberTextField.text];
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
