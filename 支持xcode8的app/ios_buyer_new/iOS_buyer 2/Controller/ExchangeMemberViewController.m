//
//  ExchangeMemberViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/10/6.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ExchangeMemberViewController.h"
#import "CaptchaView.h"
#import "ExchangeNeedKnowViewController.h"
#import "CurrentRankViewController.h"
@interface ExchangeMemberViewController ()<UITextFieldDelegate>
{
    NSMutableArray *tfArr;
    CaptchaView *_captchaView;//验证码的视图

}
@end

@implementation ExchangeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
    
    tfArr=[NSMutableArray array];
    self.title=@"兑换会员";
    float height=40;
    NSArray *titleArr=@[@"卡 号：",@"密 码：",@"验 证 码："];
    NSArray *placeholder=@[@"请输入卡号",@"请输入密码",@"请输入验证码"];
    int startY= 50;

    
    //底部承载视图
    UIView *baseview=[[UIView alloc]init];
    baseview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseview];
    int maxY=0;
    for (int i=0; i<titleArr.count; i++) {
        int y=height*i;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,y, 90, height)];
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
        }else{
        
            //显示验证码界面
            _captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(ScreenFrame.size.width -80 -10, CGRectGetMinY(tf.frame)+5, 80, 30)];
            [baseview addSubview:_captchaView];
        }
        
        maxY=CGRectGetMaxY(tf.frame);

     }
    baseview.frame=CGRectMake(0, startY, ScreenFrame.size.width, maxY);
    UITextField *psTF=tfArr[1];
    psTF.secureTextEntry=YES;
    

    //立即兑换
    UIButton *exchangeButton=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(baseview.frame)+30, ScreenFrame.size.width-30*2, 40)];
    exchangeButton.backgroundColor=[UIColor redColor];
    exchangeButton.layer.cornerRadius=5;
    exchangeButton.layer.masksToBounds=YES;
    [exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeButton];
    
//    //兑换须知
//    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(exchangeButton.frame)+20,80, 20)];
//    button1.titleLabel.font=[UIFont systemFontOfSize:14];
//    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//
//    [button1 setTitle:@"兑换须知" forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(exchangeNeedKnow:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
    
    //付费升级
    UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(exchangeButton.frame)+15, ScreenFrame.size.width-30*2, 40)];
    button2.titleLabel.font=[UIFont systemFontOfSize:14];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 setTitle:@"付费升级" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(payExchange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}
//#pragma mark -兑换须知
//-(void)exchangeNeedKnow:(UIButton *)sender{
//    
//    ExchangeNeedKnowViewController *vc=[[ExchangeNeedKnowViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark -付费升级
-(void)payExchange:(UIButton *)sender{
    CurrentRankViewController *vc=[[CurrentRankViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -立即兑换
-(void)exchange:(UIButton *)sender{

    
    UITextField *inputTF=tfArr.lastObject;
    //判断输入的是否为验证图片显示的验证码
    if (![inputTF.text isEqualToString:_captchaView.changeString]) {
        //正确弹出警告款提示正确
        [SYObject failedPrompt:@"验证码错误"];
        return;
    }
    UITextField *numTf= tfArr[0];
    UITextField *passwordTf= tfArr[1];

    if (numTf.text.length==0) {
        [SYObject failedPrompt:@"请输入卡号"];
        return;
    }
    if (passwordTf.text.length==0) {
        [SYObject failedPrompt:@"请输入密码"];
        return;

    }
    [SYObject startLoading];
    
    NSLog(@"====%@   ===%@",numTf.text,passwordTf.text);
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/vip_card_exchange.htm"];
    
    NSMutableDictionary *par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"cardno":numTf.text,@"password":passwordTf.text,@"app":@"ios"}.mutableCopy;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSLog(@"responseObject==%@",responseObject);
        
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([ret isEqualToString:@"600"])  {
            [SYObject failedPrompt:@"用户当前等级不符合升级要求"];
            NSLog(@"600");
        }else if ([ret isEqualToString:@"500"])  {
            [SYObject failedPrompt:@"不支持卡类型"];
            NSLog(@"500");
        }else if ([ret isEqualToString:@"400"])  {
            [SYObject failedPrompt:@"卡密信息错误或无效"];
            NSLog(@"400");
        }else if ([ret isEqualToString:@"300"])  {
            [SYObject failedPrompt:@"用户未登录"];
            NSLog(@"300");
        }else if ([ret isEqualToString:@"200"])  {
            [SYObject failedPrompt:@"不支持卡类型"];
            NSLog(@"200");
        }else if ([ret isEqualToString:@"100"])  {
            [SYObject failedPrompt:@"用户升级成功"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
