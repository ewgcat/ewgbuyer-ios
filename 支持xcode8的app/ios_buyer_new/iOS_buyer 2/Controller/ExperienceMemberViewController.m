//
//  ExperienceMemberViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/10/12.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ExperienceMemberViewController.h"

@interface ExperienceMemberViewController ()<UITextFieldDelegate>
{
    NSMutableArray *tfArr;
    UIButton  *_button;//获取验证码
    NSTimer *Timer;//用于60秒倒计时
    int  secondsCountDown;//倒计时
}
@end

@implementation ExperienceMemberViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
    
    tfArr=[NSMutableArray array];
    self.title=@"体验会员";
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenFrame.size.width , 60)];
    label.text=@"体验会员可享受10天付费会员商城购物优惠！";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    float height=40;
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
   NSString *true_name= [d valueForKey:@"true_name"];
    
    NSString *phone= [d valueForKey:@"phone"];

    NSArray *titleArr=nil;
    NSArray *placeholder=nil;
    if (true_name.length==0 && phone==nil) {
        titleArr=@[@" 真实姓名：",@" 手机号码：",@"验 证 码："];
        placeholder=@[@"请输入您的姓名",@"请输入您的手机号码",@"请输入验证码"];
    }else  if (true_name.length>0 && phone==nil){
        titleArr=@[@" 手机号码：",@"验 证 码："];
        placeholder=@[@"请输入您的手机号码",@"请输入验证码"];
    }else  if (true_name.length>0 && phone!=nil){
        titleArr=@[];
        placeholder=@[];
    }else  if (true_name.length==0 && phone!=nil){
        titleArr=@[@" 真实姓名："];
        placeholder=@[@"请输入您的姓名"];
    }

    int startY= CGRectGetMaxY(label.frame);
    
    
    //底部承载视图
    UIView *baseview=[[UIView alloc]init];
    baseview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseview];
    int maxY=0;
    for (int i=0; i<titleArr.count; i++) {
        int y=height*i;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,y, 100, height)];
        label.text=titleArr[i];
        label.textAlignment=NSTextAlignmentRight;
        [baseview addSubview:label];
        
        UITextField *tf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, y, ScreenFrame.size.width-CGRectGetMaxX(label.frame)+5-30, height)];
        tf.textAlignment=NSTextAlignmentLeft;
        tf.placeholder=placeholder[i];
        tf.delegate=self;
        [baseview addSubview:tf];
        [tfArr addObject:tf];
        
        if (i!=titleArr.count-1) {
            //           加横线
            UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tf.frame), ScreenFrame.size.width-15, 1)];
            line2.backgroundColor=RGB_COLOR(230, 232, 229);
            [baseview addSubview:line2];
        }else {
            //显示验证码界面
            
            if([titleArr containsObject:@" 手机号码："]){
                _button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenFrame.size.width -90 -10, CGRectGetMinY(tf.frame)+5, 90, 30)];
                _button.backgroundColor=[UIColor redColor];
                _button.titleLabel.font=[UIFont systemFontOfSize:15];
                [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
                [_button addTarget:self action:@selector(sendNum) forControlEvents:UIControlEventTouchUpInside];
                _button.titleLabel.font=[UIFont systemFontOfSize:14];
                _button.layer.cornerRadius=5;
                _button.layer.masksToBounds=YES;
                [baseview addSubview:_button];
            }
          
        }
        
        maxY=CGRectGetMaxY(tf.frame);
        
    }
    
    
    baseview.frame=CGRectMake(0, startY, ScreenFrame.size.width, maxY);
    
    
    //申请体验
    UIButton *exchangeButton=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(baseview.frame)+30, ScreenFrame.size.width-30*2, 40)];
    exchangeButton.backgroundColor=[UIColor redColor];
    exchangeButton.layer.cornerRadius=5;
    exchangeButton.layer.masksToBounds=YES;
    [exchangeButton setTitle:@"申请体验" forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeButton];
    
 

    
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
#pragma mark -发送验证码
-(void)sendNum{
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *true_name= [d valueForKey:@"true_name"];
    
    NSString *phone= [d valueForKey:@"phone"];
    
    UITextField *mobileTF =nil;
    if (true_name.length==0 && phone==nil) {
    
        mobileTF= tfArr[1];

    }else  if (true_name.length>0 && phone==nil){
        mobileTF=tfArr[0];
    }
    if (mobileTF.text.length == 0) {
        [SYObject failedPrompt:@"请输入手机号码"];
        return;
    }
    if (![self isMobileField:mobileTF.text]) {
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }
    NSString *urlStr= [NSString stringWithFormat:@"%@/app/buyer/vip_mobile_sms.htm",FIRST_URL];

        NSDictionary *par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"mobile":mobileTF.text};
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
        _button.titleLabel.text=[NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];
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
    
    NSArray *titleArr=nil;
    NSArray *placeholder=nil;
    
    UITextField *nameTf;
    UITextField *phoneTf;
    UITextField *numTF;
    if (true_name.length==0 && phone==nil) {
        titleArr=@[@" 真实姓名：",@" 手机号码：",@"验 证 码："];
        placeholder=@[@"请输入您的姓名",@"请输入您的手机号码",@"请输入验证码"];
        nameTf=tfArr[0];
        phoneTf=tfArr[1];
        numTF=tfArr[2];

        if (nameTf.text.length==0) {
            [SYObject failedPrompt:@"请输入姓名"];
            return;
        }
        if ( phoneTf.text.length==0) {
            [SYObject failedPrompt:@"请输入您的手机号码"];
            return;
            
        }
        if ( numTF.text.length==0) {
            [SYObject failedPrompt:@"请输入验证码"];
            return;
            
        }
        
    }else  if (true_name.length>0 && phone==nil){
       
        phoneTf=tfArr[0];
        numTF=tfArr[1];
      
        if ( phoneTf.text.length==0) {
            [SYObject failedPrompt:@"请输入您的手机号码"];
            return;
            
        }
        if ( numTF.text.length==0) {
            [SYObject failedPrompt:@"请输入验证码"];
            return;
            
        }
        
    }else  if (true_name.length>0 && phone!=nil){
        titleArr=@[];
        placeholder=@[];
    }else  if (true_name.length==0 && phone!=nil){
        nameTf=tfArr[0];
        if (nameTf.text.length==0) {
            [SYObject failedPrompt:@"请输入姓名"];
            return;
        }
      
        
      
    }
   

    
    [SYObject startLoading];
    
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/vip_experience.htm"];
    

    
    NSMutableDictionary *par=nil;

    if (true_name.length==0 && phone==nil) {
    
        par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"trueName":nameTf.text,@"mobile":phoneTf.text,@"mcode":numTF.text}.mutableCopy;
    }else  if (true_name.length>0 && phone==nil){
        
        par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"mobile":phoneTf.text,@"mcode":numTF.text}.mutableCopy;
    }else  if (true_name.length>0 && phone!=nil){
        
        par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken]}.mutableCopy;
    }else  if (true_name.length==0 && phone!=nil){
        titleArr=@[@" 真实姓名："];
        placeholder=@[@"请输入您的姓名"];
        
        par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"trueName":nameTf.text}.mutableCopy;
    }
    

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

