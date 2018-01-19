//
//  InfoViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/7/7.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "InfoViewController.h"
#import "huiyuanxieyiViewController.h"
#import "AgreeViewController.h"
#import "CurrentRankViewController.h"
#import "MyscanViewController.h"
@interface InfoViewController ()<UITextFieldDelegate>
{
    NSTimer *Timer;//用于60秒倒计时
    int  secondsCountDown;//倒计时
    
    
}
@property(nonatomic,weak)UILabel * inviteLabel;//邀请码
@property(nonatomic,weak)UILabel * nameLabel;//名字
@property(nonatomic,weak)UIImageView * headImageview;//头像
@property(nonatomic,weak)UILabel *label;//推荐人邀请码label

@property(nonatomic,copy)NSString  *inviteCode;//邀请码

//4个或者是5个输入框
@property (strong, nonatomic)  UITextField *nameTF;
@property (strong, nonatomic)  UITextField *sexTF;

@property (strong, nonatomic)  UITextField *wechatTF;
@property (strong, nonatomic)  UITextField *inviteTF;
@property (strong, nonatomic)  UITextField *PhoneTF;

//激活按钮
@property (strong, nonatomic)  UIButton *jihuoBut;
@property (strong, nonatomic)  UIScrollView *scrollview;
//搜索是输入的textfield
@property (weak, nonatomic)  UITextField *searchTF;


@property (strong, nonatomic)  UIView *infoView;//用户信息的view
@property (strong, nonatomic)  UIView *inputView;//输入框的view
@property (weak, nonatomic)  UIButton *searchBut;//输入框的view

@property(nonatomic,copy)NSString *phoneNum;//手机号码


//发送验证码的label
@property (nonatomic,strong)UILabel *sendNumBut;
@property (nonatomic,assign)    BOOL hasUpper;//有没有上级

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善信息";
    _hasUpper=NO;
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
   _phoneNum =[d valueForKey:@"phone"];
    
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backItem;

    
    _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
//    _scrollview.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize=CGSizeMake(ScreenFrame.size.width, ScreenFrame.size.height-64);
    self.automaticallyAdjustsScrollViewInsets=NO;
#pragma mark - 看看有邀请码了
    NSString *ret=[d valueForKey:@"invitecode"];
    NSLog(@"rett==%@",ret);
    
    if (_isScanRegister==NO) {//如果不是扫码注册的，就要加头部的界面
//        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 40)];
//        label1.font=[UIFont systemFontOfSize:15];
//        label1.textAlignment= NSTextAlignmentLeft;
//        label1.text=@"推荐人邀请码";
//        self.label=label1;
//        [_scrollview addSubview:label1];
//        
//        UITextField *tf1=[[UITextField alloc]initWithFrame:CGRectMake(140, 17, ScreenFrame.size.width-140-80, 25)];
//        tf1.layer.borderWidth=0.5;
//        self.searchTF=tf1;
//        tf1.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
//        tf1.layer.cornerRadius=3;
//        tf1.delegate=self;
//        [_scrollview addSubview:tf1];
//        
//        UIButton *searchBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tf1.frame)+5, 17, 50, 25)];
//        self.searchBut=searchBut;
//        [searchBut setTitle:@"搜索" forState:UIControlStateNormal];
//        searchBut.layer.cornerRadius=4;
//        searchBut.layer.masksToBounds=YES;
//        searchBut.titleLabel.font=[UIFont systemFontOfSize:15];
//        [searchBut addTarget:self action:@selector(searchUPPer) forControlEvents:UIControlEventTouchUpInside];
//        searchBut.backgroundColor=[UIColor redColor];
//        [_scrollview addSubview:searchBut];
//
//   
    }
    
#pragma mark - 推荐人用户信息的view
    [_scrollview addSubview:self.infoView];
    if (_isScanRegister==NO) {
        self.infoView.hidden=YES;
        self.infoView.frame=CGRectMake(0, CGRectGetMaxY(_searchBut.frame), ScreenFrame.size.width, 0);
    }

  
   [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillShow:)
                                             name:UIKeyboardWillShowNotification
                                           object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillHide:)
                                             name:UIKeyboardWillHideNotification
                                           object:nil];

#pragma mark -获取上级的信息
    [self getUPPerInfo];
}

#pragma mark -获取上级的信息
-(void)getUPPerInfo{
    NSString *url= [NSString stringWithFormat:@"%@/app/buyer/buyer_parent_one.htm",FIRST_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    __weak typeof(self) ws=self;
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseOb00ject==%@",responseObject);
        
        if ([responseObject[@"ret"] isEqualToString:@"false"]) {
#pragma mark - 输入信息的view
            
            self.inputView=[self createInputView:CGRectMake(0, CGRectGetMaxY(_infoView.frame), ScreenFrame.size.width, 300)];
            
            [_scrollview addSubview: self.inputView];
            
            ws.infoView.hidden=YES;
//            ws.infoView.frame=CGRectMake(0, CGRectGetMaxY(ws.searchBut.frame), ScreenFrame.size.width, 123);
            
            
            NSLog(@"===%@",NSStringFromCGRect(ws.infoView.frame));
            ws.inputView.frame=CGRectMake(0, CGRectGetMaxY(ws.infoView.frame), ScreenFrame.size.width, 300);
        }else{//有上级
            ws.hasUpper=YES;
            if (responseObject[@"invitation_code"]) {
                
            }
            [ws.headImageview sd_setImageWithURL:[NSURL URLWithString:responseObject[@"photo_url"]]];
            if (responseObject[@"user_name"]) {
                ws.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",responseObject[@"user_name"]];

            }else if(responseObject[@"true_name"]){
                ws.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",responseObject[@"true_name"]];

            }
            if (responseObject[@"invitation_code"]) {
                self.inviteLabel.text=[NSString stringWithFormat:@"邀请码:%@",responseObject[@"invitation_code"]];
                NSLog(@"invitation_codeinvitation_code11==%@",self.inviteLabel.text);
                _inviteCode=responseObject[@"invitation_code"];


            }
            
            
            NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
            [d setObject:responseObject[@"photo_url"] forKey:@"photo_url"];
            [d setObject:responseObject[@"true_name"] forKey:@"true_name"];
            [d setObject:ws.searchTF.text forKey:@"inviteCode"];
            
            
            [d synchronize];
#pragma mark - 输入信息的view
            
            self.inputView=[self createInputView:CGRectMake(0, CGRectGetMaxY(_infoView.frame), ScreenFrame.size.width, 300)];
            
            [_scrollview addSubview: self.inputView];
            
            ws.infoView.hidden=NO;
            ws.infoView.frame=CGRectMake(0, CGRectGetMaxY(ws.searchBut.frame), ScreenFrame.size.width, 123);
            
            
            NSLog(@"===%@",NSStringFromCGRect(ws.infoView.frame));
            ws.inputView.frame=CGRectMake(0, CGRectGetMaxY(ws.infoView.frame), ScreenFrame.size.width, 300);
            
            
        }

        
        

       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
    



}
#pragma  mark -通过邀请码搜索上级
-(void)searchUPPer{
    [SYObject startLoading];
    NSString *url= [NSString stringWithFormat:@"%@/app/vip_my_parent_info.htm",FIRST_URL];
    __weak typeof(self) ws=self;
    
    
    NSDictionary *par=@{@"invitation_code":_searchTF.text};
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        [SYObject endLoading];
        if([ret isEqualToString:@"1"]){
            [ws.headImageview sd_setImageWithURL:[NSURL URLWithString:responseObject[@"photo_url"]]];
            ws.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",responseObject[@"true_name"]];
            
            
            NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
            [d setObject:responseObject[@"photo_url"] forKey:@"photo_url"];
            [d setObject:responseObject[@"true_name"] forKey:@"true_name"];
            [d setObject:ws.searchTF.text forKey:@"inviteCode"];

            
            [d synchronize];
            
            
            ws.inviteTF.text=ws.searchTF.text;
            ws.infoView.hidden=NO;
            ws.infoView.frame=CGRectMake(0, CGRectGetMaxY(ws.searchBut.frame), ScreenFrame.size.width, 123);
        
            
            NSLog(@"===%@",NSStringFromCGRect(ws.infoView.frame));
            ws.inputView.frame=CGRectMake(0, CGRectGetMaxY(ws.infoView.frame), ScreenFrame.size.width, 300);
            
        }else  if([ret isEqualToString:@"-1"]){
            [SYObject failedPrompt:@"参数为空"];
        }else  if([ret isEqualToString:@"0"]){
            [SYObject failedPrompt:@"找不到该邀请码的用户"];
        }else  if([ret isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"这个邀请码对应多个用户"];
        }
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];


}
#pragma mark -4个或者是5个输入框的view
-(UIView *)createInputView:(CGRect)frame{
    UIView  *v=[[UIView alloc]initWithFrame:frame];
    
  
    NSArray *titleArr=nil;
    NSArray *placeholder=nil;

//    if (_phoneNum) {//如果有手机号码
//       titleArr=@[@"真实姓名:",@"性别:",@"微信:",@"邀请码:"];
//        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号",@"请输入推荐人邀请码"];
//
//    }else{//如果没有手机号码
//        titleArr=@[@"姓名:",@"性别:",@"微信:",@"邀请码:",@"手机号码:"];
//        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号",@"请输入推荐人邀请码",@"请输入您的手机号码"];
//    }
    
    if (_hasUpper && !_phoneNum ){//如果有上级，没有手机号
        titleArr=@[@"真实姓名:",@"性别:",@"微信:",@"手机号码:"];
        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号",@"请输入您的手机号码"];
        
    }else if (!_hasUpper && !_phoneNum ){//如果没有上级，没有手机号
        titleArr=@[@"姓名:",@"性别:",@"微信:",@"手机号码:",@"邀请码:"];
        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号",@"请输入您的手机号码",@"请输入推荐人邀请码"];
        
    }else if (_hasUpper && _phoneNum ){//如果有上级，有手机号
        titleArr=@[@"姓名:",@"性别:",@"微信:"];
        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号"];
        
    }else if (!_hasUpper && _phoneNum ){//如果没有上级，有手机号
        titleArr=@[@"姓名:",@"性别:",@"微信:",@"邀请码:"];
        placeholder=@[@"请输入您的姓名",@"请选择性别",@"请输入您的微信号",@"请输入推荐人邀请码"];
    }
    
    NSMutableArray *tfArr=[NSMutableArray array];
    //左边距
    int marginx=15;
    float maxY=0;
    //高度
    int height=40;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, 14, ScreenFrame.size.width-15, 1)];
    line.backgroundColor=RGB_COLOR(230, 232, 229);
    [v addSubview:line];
    for (int i=0; i<titleArr.count; i++) {
        
        int y= 15+40*i;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(marginx,y, 75, height)];
        label.text=titleArr[i];
        [v addSubview:label];
        
        UITextField *tf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, y, ScreenFrame.size.width-CGRectGetMaxX(label.frame)+5-30, height)];
        tf.textAlignment=NSTextAlignmentLeft;
        tf.placeholder=placeholder[i];
//        tf.layer.cornerRadius=5;
//        tf.layer.masksToBounds=YES;
//        tf.layer.borderWidth=0.5;
//        tf.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5 ].CGColor;
        [v addSubview:tf];
        [tfArr addObject:tf];
        
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tf.frame), ScreenFrame.size.width-15, 1)];
        line.backgroundColor=RGB_COLOR(230, 232, 229);
        [v addSubview:line];
        
        if (i==titleArr.count-1 && !_hasUpper) {
            UIButton *scan=[[UIButton alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-40-10,maxY+ 5, 40, 30)];
            [scan setTitle:@"扫码" forState:UIControlStateNormal];
            scan.backgroundColor=[UIColor redColor];

            [scan addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:scan];
        }
        maxY=y+height;


    }
    
//    if (!_phoneNum) {
//    //发送短信验证按钮
//        
//        
//        [v addSubview:self.sendNumBut];
//        _sendNumBut.frame=CGRectMake(ScreenFrame.size.width-88-marginx, maxY+5,88, 30);
//        
//    //短信验证码输入框
//
//        UITextField *valideCodeTf=[[UITextField alloc]initWithFrame:CGRectMake(marginx, maxY+5,ScreenFrame.size.width-marginx*2-88-5, 30)];
//        valideCodeTf.textAlignment=NSTextAlignmentCenter;
//        valideCodeTf.layer.cornerRadius=5;
//        valideCodeTf.layer.masksToBounds=YES;
//        valideCodeTf.layer.borderWidth=0.5;
//        valideCodeTf.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5 ].CGColor;
//        [v addSubview:valideCodeTf];
//        
//        maxY=CGRectGetMaxY(valideCodeTf.frame);
//        
//    }
    
        UIButton *jihuoBut=[[UIButton alloc]initWithFrame:CGRectMake(marginx, maxY+20, ScreenFrame.size.width - marginx * 2, 35)];
        [jihuoBut setTitle:@"立即激活" forState:UIControlStateNormal];
        [jihuoBut addTarget:self action:@selector(jihuovip:) forControlEvents:UIControlEventTouchUpInside];
        jihuoBut.layer.cornerRadius=6;
        jihuoBut.layer.masksToBounds=YES;
        jihuoBut.backgroundColor=[UIColor redColor];
        [v addSubview:jihuoBut];
        


      CGFloat suitableFontSize=0;//合适的字体大小
    
    if (ScreenFrame.size.width==320) {
        suitableFontSize =14;
        
    }else{
        suitableFontSize =16;
        
    }
    
    NSMutableAttributedString *mytext =[[NSMutableAttributedString alloc]initWithString:@"激活即同意《e会员协议》"];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, mytext.length-5)];
    [mytext addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, 5)];
    
    UIButton *but0=[UIButton buttonWithType:UIButtonTypeCustom];
    [but0 setAttributedTitle:mytext forState:UIControlStateNormal];
    [but0 addTarget:self action:@selector(btnRegister2:) forControlEvents:UIControlEventTouchUpInside];
    but0.frame=CGRectMake(0, 0, 300, 30);
    but0.titleLabel.font=[UIFont systemFontOfSize:suitableFontSize];
    but0.center=CGPointMake(ScreenFrame.size.width/2, CGRectGetMaxY(jihuoBut.frame)+20);
    but0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    but0.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    [v addSubview:but0];
    
    self.nameTF=tfArr[0];
    self.sexTF=tfArr[1];
    self.wechatTF=tfArr[2];
    
    if (_hasUpper && !_phoneNum) {//如果有上级，没有手机号
        self.PhoneTF=tfArr[3];
    }else if (_hasUpper && _phoneNum){//如果有上级，有手机号
    
    }else if (!_hasUpper && _phoneNum){//如果没有上级，有手机号
        
        self.inviteTF=tfArr[3];

    }else if (!_hasUpper && !_phoneNum){//如果没有上级，没有手机号
        self.PhoneTF=tfArr[3];

        self.inviteTF=tfArr[4];
        
    }
    

    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    
    NSString *inviteCode= [d valueForKey:@"inviteCode"];

#pragma mark - 如果扫描注册的，就会携带邀请码
    if (_isScanRegister==YES) {

        self.inviteTF.text=inviteCode;//自动填充验证码
    }
    
//    if (!_phoneNum) {
//        self.PhoneTF=tfArr[4];
//
//    }

    self.sexTF.text=@"";
//    if (self.inviteCode!=nil) {
//        self.inviteTF.text=_inviteCode;
//
//    }
    
    
    self.nameTF.delegate=self;
    self.inviteTF.delegate=self;
    self.wechatTF.delegate=self;
    self.sexTF.delegate=self;
    self.PhoneTF.delegate=self;
    return v;


}
#pragma mark - 扫码
-(void)scanClick{
    MyscanViewController *vc=[[MyscanViewController alloc]init];
    [vc setGetcodeBlock:^(NSString *code) {
        self.inviteTF.text=code;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btnRegister2:(UIButton *)sender
{
     AgreeViewController *registerAgreementVC = [[AgreeViewController alloc]init];
    [self presentViewController:registerAgreementVC animated:YES completion:nil];
    
}
#pragma mark -推荐人用户信息
-(UIView *)infoView{
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];

   NSString *inviteCode= [d valueForKey:@"inviteCode"];
    NSString *photo_url= [d valueForKey:@"photo_url"];
    NSString *true_name= [d valueForKey:@"true_name"];
#pragma mark - 如果扫描注册的，就会携带邀请码
    if (_isScanRegister==YES) {
//        self.inviteCode=inviteCode;
//        if (self.inviteCode!=nil) {
            self.inviteTF.text=inviteCode;//自动填充验证码
            
//        }

    }else{
//        self.inviteCode=@"";
    }
    if (_infoView==nil) {
        _infoView=[[UIView alloc]init];
        
        UILabel *la1 =[[UILabel alloc]initWithFrame:CGRectMake(30, 18 ,ScreenFrame.size.width-30*2, 40)];
        la1.font=[UIFont systemFontOfSize:14];
        la1.textColor=[UIColor blackColor];
        la1.layer.borderWidth=0.5;
        la1.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
        la1.text=@"  推荐人用户信息";
        [_infoView addSubview:la1];
        
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(la1.frame)-0.5, ScreenFrame.size.width-30*2, 60)];
        bottomView.backgroundColor=[UIColor whiteColor];
        bottomView.layer.borderWidth=0.5;
        bottomView.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
        
        
     
        
      UIImageView * imageview=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageview.backgroundColor=[UIColor yellowColor];
        imageview.layer.cornerRadius=25;
        imageview.layer.masksToBounds=YES;
        [bottomView addSubview:imageview];
        self.headImageview=imageview;
        
        
       UILabel * la2 =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10 , 5 ,100, 20)];
        la2.font=[UIFont systemFontOfSize:17];
        la2.textColor=[UIColor blackColor];
        self.nameLabel=la2;
        [bottomView addSubview:la2];
        
       UILabel * la3 =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10 , CGRectGetMaxY(la2.frame) +5,200, 20)];
        la3.font=[UIFont systemFontOfSize:17];
        la3.textColor=[UIColor blackColor];
        [bottomView addSubview:la3];
        self.inviteLabel=la3;
        [_infoView addSubview:bottomView];
        
        _infoView.frame=CGRectMake(0, CGRectGetMaxY(self.label.frame), ScreenFrame.size.width, CGRectGetMaxY(bottomView.frame)+5);
        NSLog(@"frame==%@",NSStringFromCGRect(_infoView.frame));

    }
    
//    _nameLabel.text=[NSString stringWithFormat:@"姓名:%@",true_name];
//    _inviteLabel.text=[NSString stringWithFormat:@"邀请码:%@",inviteCode];
//    NSLog(@"_inviteLabel_inviteLabel22=%@",_inviteLabel.text);
    [_headImageview sd_setImageWithURL:[NSURL URLWithString:photo_url]];



    return _infoView;
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollview.frame = CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64- keyboardRect.size.height);
        
    }];
    
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollview.frame = CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64);
        
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.sexTF) {

        [self tap];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)tap{
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction  *action=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text=@"男";
    }];
    UIAlertAction  *action2=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text=@"女";

        
    }];
    UIAlertAction  *action3=[UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text=@"保密";

    }];
    UIAlertAction  *action4=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [a addAction:action];
    [a addAction:action2];
    [a addAction:action3];
    [a addAction:action4];
    [self presentViewController:a animated:YES completion:nil];

}
- (void)jihuovip:(id)sender {
//    Class cls=NSClassFromString(_pushClass);
//    UIViewController *vc= [[cls alloc]init];
//    
//    vc.title=_pushtitle;
//    
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    NSMutableArray *arr= self.navigationController.viewControllers.mutableCopy;
//    [arr removeObjectAtIndex:arr.count-2];
//    
//    self.navigationController.viewControllers=arr;

#if 1
    //安全判定
    if (![self isAvailableTextField:_nameTF]) {
        [SYObject failedPrompt:@"请输入姓名"];
        return;
    }
  
   

    if (self.sexTF.text==nil || [self.sexTF.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请选择性别"];
        return;
        
    }
    
    if (![self isAvailableTextField:_wechatTF]) {
        [SYObject failedPrompt:@"请输入微信"];
        return;
    }
    if (![self isAvailableTextField:_inviteTF] && !_hasUpper) {
        [SYObject failedPrompt:@"请输入邀请码"];
        return;
    }
    if(!_phoneNum){//如果没有手机号码的话
        if (![self isAvailableTextField:_PhoneTF]) {
            [SYObject failedPrompt:@"请输入手机号码"];
            return;
        }
    }
  
    
    
    [SYObject startLoading];
    
    
    
    [Timer invalidate];//停掉timer
    
    Timer =nil;
    secondsCountDown = 60;//60秒倒计时
    _sendNumBut.text=[NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];

 #pragma mark 上传数据
    NSString *sexcode;
    if([self.sexTF.text isEqualToString:@"男"]){
       sexcode=@"1";
    }else if([self.sexTF.text isEqualToString:@"女"]){
        sexcode=@"0";
    }if([self.sexTF.text isEqualToString:@"保密"]){
        sexcode=@"-1";
    }
    
    
    
    NSString *url= [NSString stringWithFormat:@"%@/app/buyer/vip_save_set1.htm",FIRST_URL];
    
    
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=nil;
//    if (!_phoneNum) {//如果没有手机号码的话
//         par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteTF.text,@"mobile":_PhoneTF.text};
//    }else{
//         par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteTF.text};
//    }
    if (_hasUpper && !_phoneNum) {//如果有上级，没有手机号
        par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteCode,@"mobile":_PhoneTF.text};
    }else if (!_hasUpper && !_phoneNum){//如果没有上级,没有手机号
        
        if (_inviteTF.text.length>0) {
            _inviteCode=_inviteTF.text;
        }
        par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteCode,@"mobile":_PhoneTF.text};
    }else if (!_hasUpper && _phoneNum){//如果没有上级,有手机号
        
        if (_inviteTF.text.length>0) {
            _inviteCode=_inviteTF.text;
        }
        par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteCode,@"mobile":@""};
    }else if (_hasUpper && _phoneNum){//如果有上级,有手机号
        
        if (_inviteTF.text.length>0) {
            _inviteCode=_inviteTF.text;
        }
        par =@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"trueName":_nameTF.text,@"wechat":_wechatTF.text,@"sex":sexcode,@"invitationCode":_inviteCode,@"mobile":@""};
    }
    
    
    
    NSString *mobileUrl= [NSString stringWithFormat:@"%@/app/buyer/verify_mobile.htm",FIRST_URL];
    if(!_phoneNum){//如果没有手机号码的话
        if (_PhoneTF.text.length>0) {
           NSString *phone= _PhoneTF.text;
            [[Requester managerWithHeader]POST:mobileUrl parameters:@{@"mobile":phone} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject==%@",responseObject);
                NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
                if ([ret isEqualToString:@"true"]) {
                    [self vipSettingwithURL:url andPar:par];

                    
                }else if ([ret isEqualToString:@"false"]){
                    [SYObject failedPrompt:@"手机号已注册"];
                    [SYObject endLoading];

                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",[error localizedDescription]);
                [SYObject endLoading];
                
            }];

        }
    }else{
        [self vipSettingwithURL:url andPar:par];
    }
    
    
    
#endif
    
}
#pragma mark -验证手机号后的激活VIP操作
-(void)vipSettingwithURL:(NSString *)url andPar:(NSDictionary *)par{
    
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        if([ret isEqualToString:@"1"]){
            Class cls=NSClassFromString(_pushClass);
            UIViewController *vc= [[cls alloc]init];
            
            vc.title=_pushtitle;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            NSMutableArray *arr= self.navigationController.viewControllers.mutableCopy;
            [arr removeObjectAtIndex:arr.count-2];
            
            self.navigationController.viewControllers=arr;
            
            
        }else if([ret isEqualToString:@"-4"]){
            [SYObject failedPrompt:@"系统异常"];
        }
        else if([ret isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"邀请码为空"];
        }else if([ret isEqualToString:@"-3"]){
            [SYObject failedPrompt:@"邀请码错误"];
        }
        
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
    

}

-(UILabel *)sendNumBut{
    if (_sendNumBut==nil) {
        _sendNumBut=[[UILabel alloc]init];
        _sendNumBut.font=[UIFont systemFontOfSize:11];
        [_sendNumBut setText:@"发送验证码"];
        
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

#pragma mark 发送验证码
-(void)sendNum:(UIButton *)sender{
    
    NSString *urlStr= [NSString stringWithFormat:@"%@/app/buyer/vip_mobile_sms.htm",FIRST_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];

    
    if( ![self isMobileField:_PhoneTF.text]){
        
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"mobile":_PhoneTF.text,@"type":@"find_mobile_verify_code",@"t":@"60",@"SessionCode":@""};
    __weak typeof(self) ws= self;
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
        
        [SYObject  endLoading];
        
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

#pragma mark - 安全判断
- (BOOL)isMobileField:(NSString *)phoneNumber
{

    if (_PhoneTF.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        _PhoneTF.text = 0;
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
