//
//  AccountBalanceViewController.m
//  
//
//  Created by apple on 15/10/14.
//
//

#import "AccountBalanceViewController.h"
#import "LIstViewController.h"
#import "WithdrawViewController.h"
#import "TopUpViewController.h"
#import "LoginViewController.h"
#import "CashBalanceViewController.h"
#import "BinbCardTableViewController.h"
@interface AccountBalanceViewController ()<UIGestureRecognizerDelegate>
{
    UILabel *ccLabel;
    UILabel *dongjieLabel;

}
@end

@implementation AccountBalanceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self getIndex];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self createNavigation];
    [self designPage];
}
#pragma mark -界面
-(void)createNavigation{
    

    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"账户余额" setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    self.navigationItem.titleView=titleLabel;
    
//    UIButton *backButton = [LJControl backBtn];
//    backButton.tag=1000;
//    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem =bar;
    NSLog(@"navigationController=%@",self.navigationController);
//    UIButton *rightButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 0, 21, 15) setNormalImage:[UIImage imageNamed:@"列表.png"] setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 15)];
    [rightButton setTitle:@"余额明细" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment=NSTextAlignmentRight;
    rightButton.tag=1001;
    [rightButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem =bar2;
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}

-(void)designPage{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

//#if 0
//    //导航栏
//    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:UIColorFromRGB(0Xdf0000)];
//    [self.view addSubview:bgView];
//    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50, 22, 100, 40) setText:@"账户余额" setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
//    [bgView addSubview:titleLabel];
//     UIButton *rightButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-40,33, 21, 15) setNormalImage:[UIImage imageNamed:@"列表.png"] setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
//    rightButton.tag=1001;
//    [rightButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:rightButton];
//    UIButton *backButton = [LJControl backBtn];
//    backButton.frame=CGRectMake(15,30,15,23.5);
//    backButton.tag=1000;
//    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:backButton];
//#endif
    [self createNavigation];
    UIView *bView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 250) backgroundColor:UIColorFromRGB(0Xf16a26)];
    [self.view addSubview:bView];
    
    UIImageView *banlanceBg=[LJControl imageViewFrame:CGRectMake(bView.bounds.size.width/2-67,bView.bounds.size.height-185,134, 185) setImage:@"banlance_bg.png" setbackgroundColor:[UIColor clearColor]];
    [bView addSubview:banlanceBg];
    
    UILabel *AccLabel=[LJControl labelFrame:CGRectMake(0, 80, bView.bounds.size.width, 50) setText:@"账户余额（元）" setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xffffff) textAlignment:NSTextAlignmentCenter];
    [bView addSubview:AccLabel];
#pragma mark - 余额显示的数目
    
    ccLabel=[LJControl labelFrame:CGRectMake(0, 130, bView.bounds.size.width, 50) setText:@"0.00"setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xffffff) textAlignment:NSTextAlignmentCenter];
    [bView addSubview:ccLabel];
#pragma mark - 明烙华添加冻结的余额
    dongjieLabel=[LJControl labelFrame:CGRectMake(0, 165+5, bView.bounds.size.width, 50) setText:@"冻结的余额:¥0.00"setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xffffff) textAlignment:NSTextAlignmentCenter];
    [bView addSubview:dongjieLabel];
    
    UILabel *apLabel=[LJControl labelFrame:CGRectMake(10, bView.bounds.size.height, ScreenFrame.size.width-20, 55) setText:@"提示：买家会员可以用来支付订单、提现，商家可以用来支付商城收费服务。" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X7c7e81) textAlignment:NSTextAlignmentLeft];
    apLabel.numberOfLines=3;
    [self.view addSubview:apLabel];
    int  margin=30;
    
    UIButton *withdrawButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(margin,ScreenFrame.size.height-180,90,40) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:nil];
    withdrawButton.tag=1002;
    [withdrawButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [withdrawButton addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [withdrawButton addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *withdrawlabel=[LJControl labelFrame:CGRectMake(0, 0, 90, 40) setText:@"提现" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xf47025) textAlignment:NSTextAlignmentCenter];
    withdrawlabel.tag=902;
//    withdrawlabel.backgroundColor=[UIColor redColor];
    [withdrawButton addSubview:withdrawlabel];
    [self.view addSubview:withdrawButton];
    
#pragma mark -银行卡
    UIButton *bindCardBut=[[UIButton alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-margin-100,ScreenFrame.size.height-180,100,40)];
    [bindCardBut setTitle:@"我的银行卡" forState:UIControlStateNormal];
    [bindCardBut setTitleColor:UIColorFromRGB(0Xf47025) forState:UIControlStateNormal];
    [bindCardBut addTarget:self action:@selector(bindCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [bindCardBut addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [bindCardBut addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindCardBut];

    
    
    
    UIButton * cardButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(30,ScreenFrame.size.height-60-64,90,40) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:nil];
    cardButton.tag=1003;
    [cardButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cardButton addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [cardButton addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * cardlabel=[LJControl labelFrame:CGRectMake(0, 0, 90, 40) setText:@"充值卡充值" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xf47025) textAlignment:NSTextAlignmentCenter];
    cardlabel.tag=903;
//    cardlabel.backgroundColor=[UIColor lightGrayColor];
    [cardButton addSubview:cardlabel];
    [self.view addSubview:cardButton];
    
    UIButton * moneyButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-100-margin,ScreenFrame.size.height-60-64,100,40) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:nil];
    moneyButton.tag=1004;
    [moneyButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [moneyButton addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [moneyButton addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * moneylabel=[LJControl labelFrame:CGRectMake(0, 0, 90, 40) setText:@"现金充值" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xf47025) textAlignment:NSTextAlignmentCenter];
    moneylabel.tag=904;
//    moneylabel.backgroundColor=[UIColor yellowColor];
    [moneyButton addSubview:moneylabel];
    [self.view addSubview:moneyButton];
}


-(void)bindCardAction:(UIButton *)sender{
    
    BinbCardTableViewController *v=[[BinbCardTableViewController alloc]init];
    [self.navigationController pushViewController:v animated:YES];
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{   UILabel *lab=(UILabel *)[self.view viewWithTag:sender.tag-100];
    lab.textColor=UIColorFromRGB(0xf47025);
   
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    UILabel *lab=(UILabel *)[self.view viewWithTag:sender.tag-100];
    lab.textColor=UIColorFromRGB(0x000000);
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        //列表
        LIstViewController *oooo = [[LIstViewController alloc]init];
        [self.navigationController pushViewController:oooo animated:YES];
    }else if (btn.tag==1002){
        //提现
        WithdrawViewController *oooo = [[WithdrawViewController alloc]init];
        [self.navigationController pushViewController:oooo animated:YES];
    }else if (btn.tag==1003){
        //充值卡充值
        TopUpViewController *oooo = [[TopUpViewController alloc]init];
        [self.navigationController pushViewController:oooo animated:YES];
    }else if (btn.tag==1004){
        //现金充值预存款
        CashBalanceViewController *cash = [[CashBalanceViewController alloc]init];
        cash.cashLab.text=ccLabel.text;
        [self.navigationController pushViewController:cash animated:YES];
    }


}
#pragma mark -数据
-(void)getIndex{
    [SYObject startLoading];

   NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,USER_CENTER_URL];
    NSMutableDictionary *par=@{}.mutableCopy;
    [par setObject:[SYObject currentUserID] forKey:@"user_id"];
    [par setObject:[SYObject currentToken] forKey:@"token"];
    __weak typeof(self) ws=self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ws  requestFinished:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
        NSLog(@"请求错误");
        [SYObject endLoading];
    }];
}
#pragma mark- 数据请求
-(void)requestFinished:(NSDictionary *)dict{
    NSDictionary *dic=dict;
    NSLog(@"%@",dic);
    [SYObject endLoading];

    ccLabel.text=[dic objectForKey:@"balance"];
    
    if ([dic objectForKey:@"freezeBlance"] ==nil) {
        dongjieLabel.text=[NSString stringWithFormat:@"冻结的余额:¥0.00"];

    }else{
    
        dongjieLabel.text=[NSString stringWithFormat:@"冻结的余额:¥%@",[dic objectForKey:@"freezeBlance"]];

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
