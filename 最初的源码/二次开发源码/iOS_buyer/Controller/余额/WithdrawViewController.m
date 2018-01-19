//
//  WithdrawViewController.m
//  
//
//  Created by apple on 15/10/14.
//
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIButton *bgButton;
    __weak IBOutlet UILabel *AccNumberLabel;
    __weak IBOutlet UITextField *AccNumberTextField;
    __weak IBOutlet UITextField *MoneyTextField;
    __weak IBOutlet UIButton *certainButton;
    NSMutableString *payment;
    UIView *regionView;
    UILabel *label;
}
@end

@implementation WithdrawViewController
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
    payment=[[NSMutableString alloc]init];
    [payment setString:@"alipay"];
    [self createNavigation];
    [self designPage];
}
#pragma mark -界面
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

    //导航栏
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:UIColorFromRGB(0Xdf0000)];
    [self.view addSubview:bgView];

    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50, 22, 100, 40) setText:@"提现" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:titleLabel];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.frame=CGRectMake(15,30,15,23.5);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];
    
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xededed);
    
    AccNumberTextField.placeholder=@"请输入账号信息";
    AccNumberTextField.delegate=self;
    AccNumberTextField.returnKeyType = UIReturnKeyNext;//返回键的类型
    AccNumberTextField.keyboardType = UIKeyboardTypeDefault;//键盘类型

    MoneyTextField.placeholder=@"请输入提现金额";
    MoneyTextField.delegate=self;
    MoneyTextField.returnKeyType = UIReturnKeyDefault;//返回键的类型
    MoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;//键盘类型
   
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [MoneyTextField setInputAccessoryView:inputView];
    

    certainButton.backgroundColor=UIColorFromRGB(0Xf15353);
    certainButton.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
    [certainButton.layer setMasksToBounds:YES];
    [certainButton.layer setCornerRadius:4.0];
    [certainButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [certainButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [certainButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    
    label=[LJControl labelFrame:CGRectMake(0, 0,180, 50) setText:@"支付宝" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c5c81) textAlignment:NSTextAlignmentCenter];
    UIImageView *imageview=[LJControl imageViewFrame:CGRectMake(135, 15, 23, 10) setImage:@"down-arrow.png" setbackgroundColor:[UIColor clearColor]];
    [bgButton addSubview:label];
    [bgButton addSubview:imageview];
    [bgButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    regionView=[LJControl viewFrame:CGRectMake(150,130, 180, 200) backgroundColor:UIColorFromRGB(0Xededed)];
     regionView.hidden=YES;
    regionView.userInteractionEnabled=YES;
    NSArray *array=@[@"支付宝",@"网银在线",@"财付通",@"快钱"];
    for (int i=0; i<array.count; i++) {
        UIButton *btn=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0,50*i, 180, 45) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        btn.tag=1002+i;
        UILabel *lab=[LJControl labelFrame:CGRectMake(0,0, 180, 45) setText:[array objectAtIndex:i] setTitleFont:17 setbackgroundColor:UIColorFromRGB(0XF5F5F5) setTextColor:UIColorFromRGB(0X4c5c81) textAlignment:NSTextAlignmentCenter];
        [btn addSubview:lab];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [regionView addSubview:btn];
    }

    [self.view addSubview:regionView];
}
//  button1普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}

//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
    
    
}

-(void)btnClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
         [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        btn.selected=!btn.selected;
        if (btn.selected) {
            regionView.hidden=NO;
            [self.view bringSubviewToFront:regionView];
        }else{
            regionView.hidden=YES;
        }
    }else if (btn.tag==1002){
        //支付宝
        label.text=@"支付宝";
        AccNumberLabel.text=@" 支付宝账号";
        [payment setString:@"alipay"];
        regionView.hidden=YES;
    }else if (btn.tag==1003){
        //网银在线
        label.text=@"网银";
        AccNumberLabel.text=@" 网银账号";
        [payment setString:@"chinabank"];
        regionView.hidden=YES;
    }else if (btn.tag==1004){
        //财付通
        label.text=@"财付通";
        AccNumberLabel.text=@" 财付通账号";
        [payment setString:@"tenpay"];
        regionView.hidden=YES;
    }else if (btn.tag==1005){
        //快钱
        label.text=@"快钱";
        AccNumberLabel.text=@" 快钱账号";
        [payment setString:@"bill"];
        regionView.hidden=YES;
        
    }else if (btn.tag==1006){
        //确定
        [UIView animateWithDuration:1 animations:^{
            [AccNumberTextField resignFirstResponder];
            [MoneyTextField resignFirstResponder];
            self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
        if ([AccNumberTextField.text isEqualToString:@""]) {
            [SYObject failedPrompt:@"请输入提现账号"];
        }else if ([MoneyTextField.text isEqualToString:@""]) {
            [SYObject failedPrompt:@"请输入金额"];
        }else if (MoneyTextField.text.floatValue>0){
            [self getBuyerCashSaveCashPayment:payment andCashAmount:MoneyTextField.text andCashAccount:AccNumberTextField.text andCashInfo:@"ff"];
        }else
        {
        
         [SYObject failedPrompt:@"请输入正确金额"];
        }
    }
   
}
#pragma mark -数据
-(void)getBuyerCashSaveCashPayment:(NSString *)cash_payment andCashAmount:(NSString *)cash_amount andCashAccount:(NSString *)cash_account andCashInfo:(NSString *)cash_info{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&cash_payment=%@&cash_amount=%@&cash_account=%@&cash_info=%@",FIRST_URL,CASHSAVE_URL,[fileContent objectAtIndex:3],[fileContent objectAtIndex:1],cash_payment,cash_amount,cash_account,cash_info];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    [request startAsynchronous];

}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    if ([[dic objectForKey:@"status"]integerValue]==1) {
        [SYObject failedPrompt:@"申请提交成功，等待后台处理~~~"];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popView) userInfo:nil repeats:NO];
    }else{
        [SYObject failedPrompt:@"提交失败，请检查信息~~~"];
    
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextFieldDelegate
-(void)dismissKeyBoard{
    [UIView animateWithDuration:0.3 animations:^{
        [MoneyTextField resignFirstResponder];
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==AccNumberTextField) {
        [MoneyTextField becomeFirstResponder];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [textField resignFirstResponder];
            self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        [AccNumberTextField resignFirstResponder];
        [MoneyTextField resignFirstResponder];
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==MoneyTextField) {
        if (ScreenFrame.size.height<=480) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(0,-110,ScreenFrame.size.width, ScreenFrame.size.height);
            }];
        }
    }
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
