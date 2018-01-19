//
//  ActivateVIPViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/25.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ActivateVIPViewController.h"
#import "RegisterAgreementViewController.h"
#import "AgreeViewController.h"
@interface ActivateVIPViewController () <UITextFieldDelegate,UIActionSheetDelegate>
{
    NSTimer *Timer;//用于60秒倒计时
    int  secondsCountDown;//倒计时
    
    NSInteger currentChoose;

}
@property (nonatomic,weak)UILabel *zhiweiLabel;

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSMutableArray *textFieldArray;
@property (nonatomic,strong)NSMutableDictionary *tfDict;
//用来保存相应的tf里面的值

@property (nonatomic,strong)UILabel *sendNumBut;
@end

@implementation ActivateVIPViewController
-(UILabel *)sendNumBut{
    if (_sendNumBut==nil) {
        _sendNumBut=[[UILabel alloc]init];
        _sendNumBut.font=[UIFont systemFontOfSize:11];
        [_sendNumBut setText:@"发送验证码"];
       
        _sendNumBut.frame=CGRectMake(ScreenFrame.size.width-90, 7,88, 30);
        _sendNumBut.backgroundColor=[UIColor redColor];
        _sendNumBut.layer.cornerRadius=4;
        _sendNumBut.layer.masksToBounds= YES;
        _sendNumBut.textAlignment=NSTextAlignmentCenter;
        _sendNumBut.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendNum:)];
        [_sendNumBut addGestureRecognizer:tap];
    }
    return _sendNumBut;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AgreeViewController *vc=[[AgreeViewController alloc]init];
    vc.view.frame=self.view.bounds;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *phone=[d valueForKey:@"phone"];
//    if (phone.length>5) {//如果有手机就不用验证了
//    
//        self.titleArray = @[@"姓名",@"微信",@"QQ号",@"手机号码"];
//
//    }else{
//      self.titleArray = @[@"姓名",@"微信",@"QQ号",@"手机号码",@"短信验证码"];
//    }
//
//    
//    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
//    self.tfDict=[[NSMutableDictionary alloc]init];
//      [self.tfDict  setValue:[fileContent2 objectAtIndex:2] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)0]];
//    _textFieldArray = [NSMutableArray array];
//
//    self.tableView.tableFooterView =[self createFootview];
}
-(UIView *)createFootview{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 90+37)];


    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (ScreenFrame.size.width-20)*(1-0.7), 24)];
    label.text = @"职业";
//    label.font = font;
    label.textColor = [UIColor colorWithRed:147.f/255.f green:147.f/255.f blue:147.f/255.f alpha:1];
    [footView addSubview:label];
    
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, (ScreenFrame.size.width-20)*0.7, 34.f)];
//    label2.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhiweiTap)];
    [label2 addGestureRecognizer:tap];
    label2.userInteractionEnabled=YES;
    
    label2.layer.borderWidth = 1.0;
    label2.layer.cornerRadius = 4;
    label2.layer.borderColor =[UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    label2.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:label2];
    
    self.zhiweiLabel=label2;
    //我已阅读并同意《VIP服务协议》
    
    
    
    CGFloat suitableFontSize=0;//合适的字体大小
    
    if (ScreenFrame.size.width==320) {
        suitableFontSize =14;
        
    }else{
        suitableFontSize =16;
        
    }
#if 0//方法一
    NSMutableAttributedString *mytext =[[NSMutableAttributedString alloc]initWithString:@"激活即同意《VIP服务协议》"];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, mytext.length-5)];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, 5)];

    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    label.center=CGPointMake(ScreenFrame.size.width/2, 30);
    label.attributedText =mytext;
    label.font=[UIFont systemFontOfSize:suitableFontSize];
    [footView addSubview:label];
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnRegister2:)];
    [label addGestureRecognizer:tap];
#else
    //方法2
    
    NSMutableAttributedString *mytext =[[NSMutableAttributedString alloc]initWithString:@"激活即同意《VIP服务协议》"];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, mytext.length-5)];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, 5)];
    
    UIButton *but0=[UIButton buttonWithType:UIButtonTypeCustom];
    [but0 setAttributedTitle:mytext forState:UIControlStateNormal];
    [but0 addTarget:self action:@selector(btnRegister2:) forControlEvents:UIControlEventTouchUpInside];
    but0.frame=CGRectMake(0, CGRectGetMaxY(label2.frame), 300, 30);
    but0.titleLabel.font=[UIFont systemFontOfSize:suitableFontSize];
    but0.center=CGPointMake(ScreenFrame.size.width/2, 30+30);
    but0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    but0.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    [footView addSubview:but0];
    
#endif
 
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"立即激活" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(active:) forControlEvents:UIControlEventTouchUpInside];
    but.frame=CGRectMake(20, CGRectGetMaxY(but0.frame),ScreenFrame.size.width -20 *2, 40);
    but.backgroundColor=[UIColor redColor];
    [footView addSubview:but];
    return footView;

}
-(void)zhiweiTap{
    
    UIActionSheet *v=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"学生",@"工人",@"老板",@"宝妈",@"微商",@"其他", nil];
    v.delegate=self;
    [v showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex==%zd",buttonIndex);
    self.zhiweiLabel.text=@[@"学生",@"工人",@"老板",@"宝妈",@"微商",@"其他"][buttonIndex];
    currentChoose=buttonIndex;
}
- (void)btnRegister2:(UIButton *)sender
{
    RegisterAgreementViewController *registerAgreementVC = [[RegisterAgreementViewController alloc]init];
    [self presentViewController:registerAgreementVC animated:YES completion:nil];
    
}
-(void)choose:(UIButton *)sender{
    NSLog(@"==");
    
}

#pragma mark 立即激活
-(void)active:(UIButton *)sender{
    NSLog(@"立即激活");
    [Timer invalidate];//停掉timer

    Timer =nil;
    secondsCountDown = 60;//60秒倒计时
    _sendNumBut.text=[NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];

    
    UITextField *nameTF = self.textFieldArray[0];
    UITextField *wechatTF = self.textFieldArray[1];
    UITextField *qqTF = self.textFieldArray[2];

    UITextField *mobileTF = self.textFieldArray[3];
    
    //安全判定
    if (![self isAvailableTextField:nameTF]) {
        [SYObject failedPrompt:@"请输入姓名"];
        return;
    }
    if (![self isAvailableTextField:wechatTF]) {
        [SYObject failedPrompt:@"请输入微信号"];
        return;
    }
    if (![self isAvailableTextField:qqTF]) {
        [SYObject failedPrompt:@"请输入QQ"];
        return;
    }
    if (![self isMobileField:mobileTF.text]||[mobileTF.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }
    if (self.zhiweiLabel.text==nil || [self.zhiweiLabel.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请输入职业"];
        return;
        
    }
    NSString * trueName=[self.textFieldArray[0] text];

    NSString * wechat=[self.textFieldArray[1] text];
    NSString * QQ=[self.textFieldArray[2] text];
    NSString * mobile_verify_code;
    if (self.textFieldArray.count>=5) {
        mobile_verify_code=[self.textFieldArray[4] text];

    }else{
       mobile_verify_code=@"";
    }
    NSString * mobile=[self.textFieldArray[3] text];

#pragma mark 上传数据
    
        NSString *url= [NSString stringWithFormat:@"%@/app/buyer/vip_save_set1.htm",FIRST_URL];
        
        NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSString *codel=[NSString stringWithFormat:@"%zd",currentChoose];
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":trueName,@"wechat":wechat,@"QQ":QQ,@"mobile_verify_code":mobile_verify_code,@"mobile":mobile,@"pro_fession":codel};
    
        [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSLog(@"responseObject==%@",responseObject);
            
            NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
            if([ret isEqualToString:@"1"]){
                [SYObject failedPrompt:@"激活成功"];
            } else if([ret isEqualToString:@"-4"]){
                [SYObject failedPrompt:@"系统异常"];
            }else if([ret isEqualToString:@"-2"]){
             [SYObject failedPrompt:@"邀请码为空"];
            }else if([ret isEqualToString:@"-4"]){
             [SYObject failedPrompt:@"邀请码错误"];
            }
            [SYObject endLoading];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            [SYObject endLoading];
            
        }];
    
}

#pragma mark - 安全判断
- (BOOL)isMobileField:(NSString *)phoneNumber
{
    UITextField *mobileTF = self.textFieldArray[1];
    if (mobileTF.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        mobileTF.text = 0;
        return NO;
    }
    
    return YES;
}

-(BOOL)isAvailableTextField:(UITextField *)textField{
    if (textField.text==nil||[textField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view 数据源和代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[SYObject new] cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseId = @"reuseId";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    
    SYObject *line = [[SYObject alloc]init];//这个是用画label跟textfiled的
    UIView *view = [line addAddressLineViewWithTitle:_titleArray[indexPath.row]];
    [cell addSubview:view];

    [_textFieldArray addObject:line.textField];
    line.textField.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    line.textField.delegate = self;
    if(indexPath.row==2){
//        qq号
        line.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [line.textField setInputAccessoryView:inputView];
        
        
    }
    if (indexPath.row==3) {
        //手机号码

        line.arrow.hidden = YES;
        line.textField.keyboardType = UIKeyboardTypeNumberPad;
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard3)];
        [line.textField setInputAccessoryView:inputView];
    }
    if (indexPath.row==4 ) {
        
        CGRect rect= line.textField.frame;
        rect.size.width=rect.size.width-90;
        line.textField.frame=rect;
        //短信验证码
        line.textField.keyboardType = UIKeyboardTypeNumberPad;
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard1)];
        [line.textField setInputAccessoryView:inputView];
        
        //发送短信验证码
        [cell addSubview:self.sendNumBut];
        
    }
    line.textField.backgroundColor = [UIColor whiteColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    NSInteger index = indexPath.row;
    NSString *text = [self.tfDict valueForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    line.textField.text = text;
    return cell;
}
#pragma mark 发送验证码
-(void)sendNum:(UIButton *)sender{

            NSString *urlStr= [NSString stringWithFormat:@"%@/app/buyer/vip_mobile_sms.htm",FIRST_URL];
    
            NSArray *fileContent2 = [MyUtil returnLocalUserFile];
            UITextField *phoneTF=self.textFieldArray[3];
            
            NSLog(@"phoneTF==%@",phoneTF.text);
            if( ![self isMobileField:phoneTF.text]){
            
                [SYObject failedPrompt:@"请输入正确的手机号码"];
                return;
            }

            NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"mobile":phoneTF.text,@"type":@"find_mobile_verify_code",@"t":@"60",@"SessionCode":@""};
//            __weak typeof(self) ws= self;
            [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject=%@",responseObject);
                
                [SYObject endLoading];
              
                if ([responseObject[@"code"] isEqualToString:@"100"]) {
                    [SYObject failedPrompt:@"发送成功"];
                      secondsCountDown = 60;//60秒倒计时
                    //开始倒计时
                    Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfunc) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
                }else if ([responseObject[@"code"] isEqualToString:@"200"]){
                    [SYObject failedPrompt:@"发送失败"];
                
                }
                
                
    
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:%@",[error localizedDescription]);
                [SYObject endLoading];
                
            }];
    
    NSLog(@"发送验证码");
    //设置倒计时总时长
  
    
}
-(void)timerfunc{
        //倒计时-1
        secondsCountDown--;
        //修改倒计时标签现实内容
       _sendNumBut.text=[NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];
        //当倒计时到0时，做需要的操作，比如验证码过期不能提交
        if(secondsCountDown==0){
            [_sendNumBut setText:@"发送验证码"];
            [Timer invalidate];
        }
}
-(void)dismissKeyBoard{
    UITextField *zipTF = self.textFieldArray[2];
    [zipTF resignFirstResponder];
}
-(void)dismissKeyBoard1{
    UITextField *zipTF = self.textFieldArray[4];
    [zipTF resignFirstResponder];
}
-(void)dismissKeyBoard3{
    UITextField *zipTF = self.textFieldArray[3];
    [zipTF resignFirstResponder];
}
#pragma mark - textField代理方法
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSInteger index = textField.tag;
    // tf保存数据
    [self.tfDict setValue:textField.text forKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger index2 = [self.textFieldArray indexOfObject:textField]+1;
    
    if (index2<self.textFieldArray.count) {
        UITextField *newTF = self.textFieldArray[index2];
        [textField resignFirstResponder];
        [textField endEditing:YES];
        [newTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
