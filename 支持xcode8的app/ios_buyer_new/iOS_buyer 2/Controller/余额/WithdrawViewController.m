//
//  WithdrawViewController.m
//  
//
//  Created by apple on 15/10/14.
//
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{

    NSMutableString *payment;
    UIView *regionView;
    UILabel *label;
    NSInteger selectedRow;
}
@property(nonatomic,strong)UIButton *sureButton;//确定的按钮
@property(nonatomic,weak)UITextField *MoneyTextField;
@property(nonatomic,weak)UITextField *cardTextField;//银行卡的


@property(nonatomic,strong)UIView *pickerBgView;
@property(nonatomic,strong)NSArray *dataArr;

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
    selectedRow=0;
    [payment setString:@"alipay"];
    [self createNavigation];
    [self designPage];
    [self getData];
}
-(void)getData{
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/bankcard.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        
        ws.dataArr=responseObject[@"bankList"];
        if (ws.dataArr.count==0) {
            [SYObject failedPrompt:@"请绑定银行卡"];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popView) userInfo:nil repeats:NO];

        } else {
            [ws createPickerView];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];

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
-(void)createPickerView{
    
    
    
    if (self.pickerBgView==nil) {
        _pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height, ScreenFrame.size.width, 0)];
        //    pickerBgView.hidden = YES;
        _pickerBgView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_pickerBgView];
    
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(5, 5, 50, 20);
        cancelBtn.tag=100;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerBgView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.frame = CGRectMake( ScreenFrame.size.width-55, 5, 50, 20);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.tag=101;
        
        //灰色的线
        UIView *grayLine=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sureBtn.frame), ScreenFrame.size.width, 1)];
        grayLine.backgroundColor=UIColorFromRGB(0Xededed);
        [_pickerBgView addSubview:grayLine];
        
        [_pickerBgView addSubview:sureBtn];
        
        
        UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, ScreenFrame.size.width, 216)];
        pickerView.showsSelectionIndicator=YES;
        [_pickerBgView addSubview:pickerView];
        pickerView.delegate=self;
        pickerView.dataSource=self;
        //        pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.view addSubview:_pickerBgView];
    }else{
        
    }
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xededed);
    
    int  itemHeight=50;
    int margin=10;
    UIView *bottomView=[[UIView alloc]init];
    bottomView.userInteractionEnabled=YES;
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(margin,0, ScreenFrame.size.width, itemHeight)];
    label1.text=@"请选择提现的银行卡号";
    [bottomView addSubview:label1];
    label1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickerview)];
    [label1 addGestureRecognizer:tap];
    
#pragma mark - 弹出pickerview
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-20-20, (itemHeight-20)/2, 20, 20)];
//    but.backgroundColor=[UIColor redColor];
    [but setImage:[UIImage imageNamed:@"downtri"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(showPickerview) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:but];
    
    //灰色的线
    UIView *grayLine=[[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(label1.frame), ScreenFrame.size.width, 1)];
    grayLine.backgroundColor=UIColorFromRGB(0Xededed);
    [bottomView addSubview:grayLine];
    
//    银行卡号
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(grayLine.frame), ScreenFrame.size.width, itemHeight)];
    label2.text=@"银行卡号:";
    [bottomView addSubview:label2];
    
    
    
    UITextField *cardTextField=[[UITextField alloc]initWithFrame:CGRectMake(90,CGRectGetMaxY(grayLine.frame), ScreenFrame.size.width- margin-80, 50)];
    
    cardTextField.placeholder=@"请输入账号信息";
    cardTextField.userInteractionEnabled=NO;
    self.cardTextField=cardTextField;
    [bottomView addSubview:cardTextField];
    //灰色的线2
    UIView *grayLine2=[[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(label2.frame), ScreenFrame.size.width, 1)];
    grayLine2.backgroundColor=UIColorFromRGB(0Xededed);
    [bottomView addSubview:grayLine2];
    
    //    金额(元)
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(label2.frame), ScreenFrame.size.width, itemHeight)];
    label3.text=@"金额(元):";
    [bottomView addSubview:label3];
    
    
    
    //    金额输入框
    //
    UITextField *MoneyTextField=[[UITextField alloc]initWithFrame:CGRectMake(90,CGRectGetMaxY(label2.frame), ScreenFrame.size.width- margin-80, 50)];
    
    //    AccNumberTextField.placeholder=@"请输入账号信息";
    //    AccNumberTextField.delegate=self;
    //    AccNumberTextField.returnKeyType = UIReturnKeyNext;//返回键的类型
    //    AccNumberTextField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    //
        MoneyTextField.placeholder=@"请输入提现金额";
        MoneyTextField.delegate=self;
        MoneyTextField.returnKeyType = UIReturnKeyDefault;//返回键的类型
        MoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;//键盘类型
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:nil leftAction:nil rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    MoneyTextField.inputAccessoryView= inputView;
    self.MoneyTextField=MoneyTextField;
    [bottomView addSubview:MoneyTextField];
    bottomView.frame=CGRectMake(0, 64+20, ScreenFrame.size.width, CGRectGetMaxY(label3.frame));
    
    
    
    UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(margin,CGRectGetMaxY(bottomView.frame), ScreenFrame.size.width, itemHeight)];
    tipLabel.textColor=[UIColor lightGrayColor];
    tipLabel.font=[UIFont systemFontOfSize:15];
    tipLabel.text=@"因转出银行不同时间不同";
    [self.view addSubview:tipLabel];


//    
//    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
//    [MoneyTextField setInputAccessoryView:inputView];
//    

//    certainButton.backgroundColor=UIColorFromRGB(0Xf15353);
//    certainButton.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
//    [certainButton.layer setMasksToBounds:YES];
//    [certainButton.layer setCornerRadius:4.0];
//    [certainButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [certainButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
//    [certainButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    _sureButton =[[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(tipLabel.frame)+5, ScreenFrame.size.width-100, 40)];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _sureButton.backgroundColor=[UIColor redColor];
//    _sureButton.enabled=NO;
//    _sureButton.alpha=0.4;

    _sureButton.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
    [_sureButton.layer setMasksToBounds:YES];
    [_sureButton.layer setCornerRadius:4.0];
    _sureButton.tag=10000;
    [_sureButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_sureButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
//    label=[LJControl labelFrame:CGRectMake(0, 0,180, 50) setText:@"支付宝" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c5c81) textAlignment:NSTextAlignmentCenter];
//    UIImageView *imageview=[LJControl imageViewFrame:CGRectMake(135, 15, 23, 10) setImage:@"down-arrow.png" setbackgroundColor:[UIColor clearColor]];
//    [bgButton addSubview:label];
//    [bgButton addSubview:imageview];
//    [bgButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    regionView=[LJControl viewFrame:CGRectMake(150,130, 180, 200) backgroundColor:UIColorFromRGB(0Xededed)];
//     regionView.hidden=YES;
//    regionView.userInteractionEnabled=YES;
//    NSArray *array=@[@"支付宝",@"网银在线",@"财付通",@"快钱",@"11"];
//    for (int i=0; i<array.count; i++) {
//        UIButton *btn=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0,50*i, 180, 45) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
//        btn.tag=1002+i;
//        UILabel *lab=[LJControl labelFrame:CGRectMake(0,0, 180, 45) setText:[array objectAtIndex:i] setTitleFont:17 setbackgroundColor:UIColorFromRGB(0XF5F5F5) setTextColor:UIColorFromRGB(0X4c5c81) textAlignment:NSTextAlignmentCenter];
//        [btn addSubview:lab];
//        
//        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [regionView addSubview:btn];
//    }
//
//    [self.view addSubview:regionView];
    
}
-(void)dismissKeyBoard{

    [self.MoneyTextField resignFirstResponder];

}
-(void)btnAction:(UIButton *)sender{
    
    if (sender.tag==101) {//确定
        if (_dataArr[selectedRow][@"card_number"]) {
            self.cardTextField.text=_dataArr[selectedRow][@"card_number"];

        }
//        _sureButton.enabled=YES;
//        _sureButton.alpha=1;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBgView.frame=CGRectMake(0, ScreenFrame.size.height, ScreenFrame.size.width,0);
    }];
}
-(void)showPickerview{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBgView.frame=CGRectMake(0, ScreenFrame.size.height-216-25, ScreenFrame.size.width, 216+25);
    }];
    
}
#pragma mark Picker Data Source Methods
//设置pickerView的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//设置每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return _dataArr.count;
}

//设置每行每列的内容
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    NSString *str=_dataArr[row][@"card_number"];
    return str;
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{
    
    NSString *str=_dataArr[row][@"card_number"];

    self.cardTextField.text=str;
    selectedRow=row;
//    _sureButton.enabled=YES;
//    _sureButton.alpha=1;

   
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
    if (btn.tag==1000) {//返回
        [self.navigationController popViewControllerAnimated:YES];

    }else if (btn.tag==10000){
        //确定
    
         if ([_MoneyTextField.text isEqualToString:@""]) {
            [SYObject failedPrompt:@"请输入金额"];
        }else if (_MoneyTextField.text.floatValue>0){
//            _sureButton.enabled=NO;
//            _sureButton.alpha=0.4;
           NSDictionary *dic= _dataArr[selectedRow];
            NSString *cardID=dic[@"id"];
            [self getBuyerCashSaveCashPayment:cardID andCashAmount:_MoneyTextField.text andCashAccount:nil andCashInfo:@"ff"];
        }else
        {
        
         [SYObject failedPrompt:@"请输入正确金额"];
        }
    }
//
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
        if (dic[@"msg"]) {
            [SYObject failedPrompt:dic[@"msg"]];
        }else{
            [SYObject failedPrompt:@"申请提交成功，等待后台处理~~~"];

        }
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popView) userInfo:nil repeats:NO];
    } else if ([[dic objectForKey:@"status"]integerValue]==-1) {
    
        [SYObject failedPrompt:dic[@"msg"]];

    }else if ([[dic objectForKey:@"status"]integerValue]==0) {
        [SYObject failedPrompt:dic[@"msg"]];
    
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextFieldDelegate
//-(void)dismissKeyBoard{
//    [UIView animateWithDuration:0.3 animations:^{
//        [MoneyTextField resignFirstResponder];
//        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
//    }];
//    
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str =[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0)//只让输入是数字的字符
    {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [UIView animateWithDuration:0.3 animations:^{
//        [AccNumberTextField resignFirstResponder];
//        [MoneyTextField resignFirstResponder];
//        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
//    }];
//    
//}
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (textField==MoneyTextField) {
//        if (ScreenFrame.size.height<=480) {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.frame=CGRectMake(0,-110,ScreenFrame.size.width, ScreenFrame.size.height);
//            }];
//        }
//    }
//}
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
