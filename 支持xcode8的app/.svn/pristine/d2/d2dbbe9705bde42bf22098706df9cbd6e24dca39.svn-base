//
//  ExperienceMemberViewController2.m
//  My_App
//
//  Created by 邱炯辉 on 16/10/14.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ExperienceMemberViewController2.h"
@interface InputView : UIView
@property (nonatomic,strong)UITextField *myTF;
@property (nonatomic,strong)UILabel *myLabel;
-(instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder andNeedLine:(BOOL)needLine;
@end

@implementation InputView
-(instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder andNeedLine:(BOOL)needLine{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        float height=40;
        
        self.myLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 100, height)];
        self.myLabel.text=title;
        self.myLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:self.myLabel];
        
        self.myTF=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_myLabel.frame)+5, 0, ScreenFrame.size.width-CGRectGetMaxX(_myLabel.frame)+5-30, height)];
        self.myTF.textAlignment=NSTextAlignmentLeft;
        self.myTF.placeholder=placeholder;
        [self addSubview:_myTF];
        if (needLine) {
            //           加横线
            UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_myTF.frame)-1, ScreenFrame.size.width-15, 1)];
            line2.backgroundColor=RGB_COLOR(230, 232, 229);
            [self addSubview:line2];
        }
     
    }
    return self;
    
}


@end

@interface ExperienceMemberViewController2 ()<UITextFieldDelegate>
{
    NSMutableArray *tfArr;
    UIButton  *_button;//获取验证码
    NSTimer *Timer;//用于60秒倒计时
    int  secondsCountDown;//倒计时
    
    InputView *nameView;//输入名字的输入view
    InputView *phoneView;//输入手机号码的view
    InputView *numView;//输入验证码的view
    
}
@end

@implementation ExperienceMemberViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
    
    tfArr=[NSMutableArray array];
    self.title=@"体验会员";
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *vip_experience_slogan=[d valueForKey:@"vip_experience_slogan"];
    

    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenFrame.size.width , 60)];
    
       if (vip_experience_slogan) {
        label.text=vip_experience_slogan;

    }
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString *true_name= [d valueForKey:@"true_name"];

    NSString *phone= [d valueForKey:@"phone"];

    
    float y=CGRectGetMaxY(label.frame);
    float height=40;
    float width=ScreenFrame.size.width;
    
    nameView =[[InputView alloc]initWithFrame:CGRectMake(0, y, width, height) AndTitle:@" 真实姓名：" AndPlaceholder:@"请输入您的姓名" andNeedLine:YES];
    nameView.myTF.delegate=self;
    y+=height;
    [self.view addSubview:nameView];
    if(true_name.length>0){
        nameView.myTF.text=true_name;
        nameView.myTF.userInteractionEnabled=NO;
    }
  
    phoneView =[[InputView alloc]initWithFrame:CGRectMake(0, y, width, height) AndTitle:@" 手机号码：" AndPlaceholder:@"请输入您的手机号码" andNeedLine:YES];
    phoneView.myTF.delegate=self;

    [self.view addSubview:phoneView];
    y+=height;
    if(phone.length>0){
        phoneView.myTF.text=phone;
        phoneView.myTF.userInteractionEnabled=NO;
    }else{//没有手机号码
        
        numView =[[InputView alloc]initWithFrame:CGRectMake(0, y, width, height) AndTitle:@"验 证 码：" AndPlaceholder:@"请输入验证码" andNeedLine:YES];
        [self.view addSubview:numView];
        numView.myTF.delegate=self;

        _button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenFrame.size.width -90 -10,5, 90, 30)];
        _button.backgroundColor=[UIColor redColor];
        [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(sendNum) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font=[UIFont systemFontOfSize:13];
        _button.layer.cornerRadius=5;
        _button.layer.masksToBounds=YES;
        [numView addSubview:_button];
    
        y+=height;
    }
    
  
    
    //申请体验
    UIButton *exchangeButton=[[UIButton alloc]initWithFrame:CGRectMake(30, y+30, ScreenFrame.size.width-30*2, 40)];
    exchangeButton.backgroundColor=[UIColor redColor];
    exchangeButton.layer.cornerRadius=5;
    exchangeButton.layer.masksToBounds=YES;
    [exchangeButton setTitle:@"申请体验" forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeButton];
    
    

}
#pragma mark -发送验证码
-(void)sendNum{
    


    if (phoneView.myTF.text.length == 0) {
        [SYObject failedPrompt:@"请输入手机号码"];
        return;
    }
    if (![self isMobileField:phoneView.myTF.text]) {
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }
    NSString *urlStr= [NSString stringWithFormat:@"%@/app/buyer/vip_mobile_sms.htm",FIRST_URL];
    
    NSString *mobile=phoneView.myTF.text?phoneView.myTF.text:@"";
    NSDictionary *par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"mobile":mobile};
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        [SYObject endLoading];
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([ret isEqualToString:@"100"]) {
            [SYObject failedPrompt:@"发送成功"];
            secondsCountDown = 60;//60秒倒计时
            //开始倒计时
            Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfunc) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        }else if ([ret isEqualToString:@"200"]){
            [SYObject failedPrompt:@"发送失败"];
            
        }else if ([ret isEqualToString:@"600"]){
            [SYObject failedPrompt:@"该手机号码已存在"];
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
    _button.titleLabel.text=[NSString stringWithFormat:@"%d秒后发送",secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [_button.titleLabel setText:@"发送验证码"];
        [Timer invalidate];
    }
}
#pragma mark -申请体验
-(void)exchange:(UIButton *)sender{
    
    
    [Timer invalidate];//停掉timer
    
    Timer =nil;
    secondsCountDown = 60;//60秒倒计时
    _button.titleLabel.text=[NSString stringWithFormat:@"发送验证码"];
    
    
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *true_name= [d valueForKey:@"true_name"];
    
    NSString *phone= [d valueForKey:@"phone"];
    

    if (nameView.myTF.text.length==0) {
        [SYObject failedPrompt:@"请输入姓名"];
        return;
    }
    if ( phoneView.myTF.text.length==0) {
        [SYObject failedPrompt:@"请输入您的手机号码"];
        return;
        
    }
    
    if (phone.length==0) {//那就是没有手机，需要输入验证码
        if ( numView.myTF.text.length==0) {
            [SYObject failedPrompt:@"请输入验证码"];
            return;
            
        }
    }
   
    
    [SYObject startLoading];
    
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/vip_experience.htm"];
    
    NSString *name=nameView.myTF.text?nameView.myTF.text:@"";
    NSString *phoneNum=phoneView.myTF.text?phoneView.myTF.text:@"";
    NSString *mcode= numView.myTF.text? numView.myTF.text:@"";
    

    NSMutableDictionary *par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"trueName":name,@"mobile":phoneNum,@"mcode":mcode}.mutableCopy;
    
    

    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSLog(@"responseObject==%@",responseObject);
        
        
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([ret isEqualToString:@"600"])  {
            [SYObject failedPrompt:@"不符合申请体验会员要求"];
            NSLog(@"600");
        }else if ([ret isEqualToString:@"500"])  {
            [SYObject failedPrompt:@"手机号码已被使用"];
            NSLog(@"500");
        }else if ([ret isEqualToString:@"400"])  {
            [SYObject failedPrompt:@"验证码错误"];
            NSLog(@"400");
        }else if ([ret isEqualToString:@"300"])  {
            [SYObject failedPrompt:@"参数错误"];
            NSLog(@"300");
        }else if ([ret isEqualToString:@"200"])  {
            [SYObject failedPrompt:@"未登录"];
            NSLog(@"200");
        }else if ([ret isEqualToString:@"100"])  {
            [SYObject failedPrompt:@"申请体验会员成功"];
            NSLog(@"100");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求失败"];
    }];
    //
}


#pragma mark 输入框协议中方法,点击return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)isMobileField:(NSString *)phoneNumber
{
    
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


