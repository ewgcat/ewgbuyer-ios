//
//  LoginViewController.m
//  My_App
//  zhaohan 2015 11 19 修改
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "FastRegisterViewController.h"
#import "ASIFormDataRequest.h"
#import "UsercenterCell.h"
#import "MuchViewController.h"
#import "CouponsViewController.h"
#import "AddAdminViewController.h"
#import "SetLogPassViewController.h"
#import "PaySettingViewController.h"
#import "NewLoginViewController.h"
#import "MyMessageViewController.h"
#import "zeroListViewController.h"
#import "ThirdViewController.h"
#import "buyer_returnViewController.h"
#import "myzeroViewController.h"
#import "IntegralExchangeViewController.h"
#import "returnMoneyViewController.h"
#import "UserInformationViewController.h"
#import "OrderListViewController.h"
#import "AccountBalanceViewController.h"
#import "MyCollectViewController.h"
#import "StandingsViewController.h"
#import "MyFootprintViewController.h"
#import "myEvaluationViewController.h"
#import "MyWalletViewController.h"
#import "buyer_returnViewController.h"
#import "AccountSafetyController.h"
#import "ServiceViewController.h"
#import "SYEvaluateViewController.h"
#import "LifeGroupViewController.h"
#import "IntegralOrderDetail2ViewController.h"
#import "wIntegralOrderDetailViewController.h"
#import "myzerodetailViewController.h"
#import "GroupOrdListViewController.h"
#import "ReturnOutViewController.h"

@interface LoginViewController ()

@end

static LoginViewController *singleInstance=nil;

@implementation LoginViewController
@synthesize MyTableView,orderTag;
// 单例实现
+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}
+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}
//随着状态不同,切换title
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人中心";
    }
    return self;
}
//  入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(219,34,46);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    balance = @"";
    coupon = @"";
    integral = @"";
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    MyTableView.showsHorizontalScrollIndicator = NO;
    // 判断用户是否已登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [SYObject endLoading];
    }else{
        [SYObject startLoading];
    }
    _logBool = NO;
    navImage.alpha = 0;
    orderTag = 0;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkMessage];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [SYObject endLoading];
    // 判断是否登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [MyTableView reloadData];
    }else{
        [MyTableView reloadData];
        //发起刷新页面的请求
        [self netWork];
    }
    if (_logBool==NO) {
        
    }else{
        MyTableView.hidden = YES;
        _logBool = NO;
    }
    [MyTableView reloadData];
}
#pragma mark - tabelView方法
// 只有一个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        // 如果没登陆
        return 603;
    }else{
        //登录
        return 603;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsercenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UsercenterCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    }
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:photo_url] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    cell.nameLabel.text = name;
    cell.levelLabel.text = level_name;
    cell.ManagerOrder.tag = 100;
    cell.btn_message.tag = 112;
    cell.rechargeCard.tag = 111;
    // zhaohan20151119修改重新添加
    cell.mBalanceBtn.tag=2001;  //余额
    cell.mIntegralBtn.tag=2002;  // 积分
    cell.mCouponBtn.tag=2003;  // 优惠券
    cell.mPrepaidCardBtn.tag=2004;  // 充值卡
    cell.mLifeCheepBtn.tag=2005;  // 生活惠
    cell.mAddressBtn.tag=2006;  // 地址管理
    cell.mAccountSafetyBtn.tag=2007;  // 账户安全
    cell.mServiceBtn.tag=2008;  // 服务中心
    // zhaohan20151119修改重新添加点击事件
    [cell.mBalanceBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mIntegralBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mCouponBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mPrepaidCardBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mLifeCheepBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mAddressBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mAccountSafetyBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mServiceBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [cell.btn_setting addTarget:self action:@selector(muchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.rechargeCard addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.userInformation addTarget:self action:@selector(goto_userInformation) forControlEvents:UIControlEventTouchUpInside];
    [cell.ManagerOrder addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_message addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.attentionGoodsCountLabel.text = favoutite_goods_count;
    cell.attentionStoreCountLabel.text = favoutite_store_count;
    cell.attentionTraceCountLabel.text = footPoint_count;
    
    cell.attentionTrace.tag = 101;
    cell.attentionStore.tag = 102;
    cell.attentionGoodsBtn.tag = 103;
    [cell.attentionTrace addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.attentionStore addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.attentionGoodsBtn addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.will_payOrderBtn.tag = 101;
    cell.will_goodsOrderBtn.tag = 102;
    cell.will_evolateOrderBtn.tag = 103;
    cell.will_returnOrderBtn.tag = 104;
    cell.waitGoodsBtn.tag = 105;
    [cell.will_payOrderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.will_goodsOrderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.will_evolateOrderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.will_returnOrderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.waitGoodsBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
        //00025修改 2016 1 22
        cell.notLoggedcircleImage.hidden=NO;
        cell.notLoggedphotoImage.hidden=NO;
        cell.photoImage.hidden=YES;
        cell.circleImage.hidden=YES;
//        [cell.photoImage setImage:[UIImage imageNamed:@"integral_logbtn"] ];
        cell.nameLabel.hidden = YES;
        //top
        cell.attentionTraceCountLabel.hidden = YES;
        cell.attentionTraceLabel.hidden = YES;
        cell.attentionStoreCountLabel.hidden = YES;
        cell.attentionStoreLabel.hidden = YES;
        cell.attentionGoodsCountLabel.hidden = YES;
        cell.attentionGoodsLabel.hidden = YES;
        cell.managementLabel.hidden=YES;
        cell.levelLabel.hidden = YES;
        cell.disImage.hidden=YES;
    }else{
        //00025修改 2016 1 22
        cell.notLoggedcircleImage.hidden=YES;
        cell.notLoggedphotoImage.hidden=YES;
        cell.photoImage.hidden=NO;
        cell.circleImage.hidden=NO;
        
        cell.nameLabel.hidden = NO;
        cell.levelLabel.hidden = NO;
         cell.managementLabel.hidden=NO;
        cell.disImage.hidden=NO;
        //top
        cell.attentionTraceCountLabel.hidden = NO;
        cell.attentionTraceLabel.hidden = NO;
        [cell.attentionTrace setTitle:@"" forState:UIControlStateNormal];
        cell.attentionStoreCountLabel.hidden = NO;
        cell.attentionStoreLabel.hidden = NO;
        [cell.attentionStore setTitle:@"" forState:UIControlStateNormal];
        cell.attentionGoodsCountLabel.hidden = NO;
        cell.attentionGoodsLabel.hidden = NO;
        [cell.attentionGoodsBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (cell.MessageCount.text.intValue == 0) {
        cell.MessageCount.hidden = YES;
    }
    [cell.MessageCount.layer setMasksToBounds:YES];
    [cell.MessageCount.layer setCornerRadius:10];
    
    return cell;
}
#pragma mark - 点击事件
// 修改后的点击事件
-(void) myBtnClick:(UIButton *) btn{
    // 判断用户是否登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
        [self.navigationController pushViewController:new animated:YES];
    }
    else
    {
        if(btn.tag==2001)// 余额
        {
            AccountBalanceViewController *accBalance=[[AccountBalanceViewController alloc]init];
            [self.navigationController pushViewController:accBalance animated:YES];
        }
        if(btn.tag==2002)// 积分
        {
            StandingsViewController *oooo = [[StandingsViewController alloc]init];
            oooo.myIntegral= integral;
            [self.navigationController pushViewController:oooo animated:YES];
        }
        if(btn.tag==2003)// 优惠券
        {
            CouponsViewController * couponVC=[[CouponsViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
        if(btn.tag==2004)// 0元购详情
        {
            myzeroViewController *zero = (myzeroViewController *)[SYObject VCFromUsercenterStoryboard:@"myzeroViewController"];
            [self.navigationController pushViewController:zero animated:YES];
        }
        if(btn.tag==2005)// 生活惠
        {   GroupOrdListViewController *life = (GroupOrdListViewController *)[SYObject VCFromUsercenterStoryboard:@"GroupOrdListViewController"];
            [self.navigationController pushViewController:life animated:YES];
        }
        if(btn.tag==2006)// 地址
        {
            AddAdminViewController *addAdminVC = [[AddAdminViewController alloc]init];
            [self.navigationController pushViewController:addAdminVC animated:YES];
        }
        if(btn.tag==2007)// 账户安全
        {
            AccountSafetyController * safeVC=[[AccountSafetyController alloc] init];
            [self.navigationController pushViewController:safeVC animated:YES];
        }
        if(btn.tag==2008) // 服务 11.23
        {
            UIStoryboard *sbd = [UIStoryboard storyboardWithName:@"ServiceStoryboard" bundle:nil];
            UITableViewController *tvc = [sbd instantiateViewControllerWithIdentifier:@"serviceCenter"];
            [self.navigationController pushViewController:tvc animated:YES];
        }
    }
}
// 我的评价 我的收藏 我的消息 密码修改 支付设置等按钮
-(void)newbtnClicked:(UIButton *)btn{
    // 判断用户是否登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
        [self.navigationController pushViewController:new animated:YES];
    }else{
        if (btn.tag == 100) {
            orderTag = 0;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
        if (btn.tag == 101) {
            //优惠券
            CouponsViewController *cpsVC = [[CouponsViewController alloc]init];
            [self.navigationController pushViewController:cpsVC animated:YES];
        }
        if (btn.tag == 102) {
            //我的收藏
            MyCollectViewController *my = [[MyCollectViewController alloc]init];
            my.flay=@"2";
            [self.navigationController pushViewController:my animated:YES];
        }
        if (btn.tag == 112) {
            //我的消息
            MyMessageViewController *my = [[MyMessageViewController alloc]init];
            [self.navigationController pushViewController:my animated:YES];
        }
        if (btn.tag == 103) {
            //我的消息
            MyMessageViewController *sign = [[MyMessageViewController alloc]init];
            [self.navigationController pushViewController:sign animated:YES];
        }
        if (btn.tag == 104) {
            AddAdminViewController *addAdminVC = [[AddAdminViewController alloc]init];
            [self.navigationController pushViewController:addAdminVC animated:YES];
        }
        if (btn.tag == 105) {
            // 密码修改
            SetLogPassViewController *setLogPassVC = [[SetLogPassViewController alloc]init];
            [self.navigationController pushViewController:setLogPassVC animated:YES];
        }
        if (btn.tag == 106) {
            // 支付设置
            PaySettingViewController *pay = [[PaySettingViewController alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
        }
        if (btn.tag == 107) {
            //优惠劵
            CouponsViewController *oooo = [[CouponsViewController alloc]init];
            [self.navigationController pushViewController:oooo animated:YES];
        }
        if (btn.tag == 108) {
            //余额
            AccountBalanceViewController *oooo = [[AccountBalanceViewController alloc]init];
            [self.navigationController pushViewController:oooo animated:YES];
        }
        if (btn.tag == 109) {
            //积分
            StandingsViewController *oooo = [[StandingsViewController alloc]init];
            oooo.myIntegral=integral;
            [self.navigationController pushViewController:oooo animated:YES];
        }
        if (btn.tag == 110) {
            myEvaluationViewController *my = [[myEvaluationViewController alloc]init];
            [self.navigationController pushViewController:my animated:YES];
        }
        if (btn.tag == 111) {
            //钱包
            MyWalletViewController *oooo = [[MyWalletViewController alloc]init];
             oooo.myIntegral=integral;
            [self.navigationController pushViewController:oooo animated:YES];
            
        }
    }
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
//用户设置(左上角小齿轮)
-(void)muchBtnClicked{
    MuchViewController *much = [[MuchViewController alloc]init];
    [self.navigationController pushViewController:much animated:YES];
}
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnRegister{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)attentionBtnClicked:(UIButton *)btn{
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        if (btn.tag == 101) {
            MyFootprintViewController *sign = [[MyFootprintViewController alloc]init];
            [self.navigationController pushViewController:sign animated:YES];
        }
        if (btn.tag == 102) {
            MyCollectViewController *my = [[MyCollectViewController alloc]init];
            my.flay=@"2";
            [self.navigationController pushViewController:my animated:YES];
        }
        if (btn.tag == 103) {
            MyCollectViewController *my = [[MyCollectViewController alloc]init];
            my.flay=@"3";
            [self.navigationController pushViewController:my animated:YES];
        }
    }
}
// 全部订单下面的五个按钮
-(void)orderBtnClicked:(UIButton *)btn{
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        if (btn.tag == 101) {//待付款
            orderTag = 1;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
        if (btn.tag == 102) {//待发货
            orderTag = 2;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
        if (btn.tag == 103) {//待评价--新页面
            SYEvaluateViewController *eva = [[SYEvaluateViewController alloc]init];
            [self.navigationController pushViewController:eva animated:YES];
        }
        if (btn.tag == 104) {//退款/售后--新页面
//            [self.navigationController pushViewController:[returnMoneyViewController new] animated:YES];
            
//            buyer_returnViewController *retu = [[buyer_returnViewController alloc]init];
//            [self.navigationController pushViewController:retu animated:YES];
            ReturnOutViewController *outVC = [[ReturnOutViewController alloc]init];
            [self.navigationController pushViewController:outVC animated:YES];
        }
        if (btn.tag == 105) {//待收货
            orderTag = 3;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
    }
}
-(void)goto_userInformation{
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        UserInformationViewController *uuu = [[UserInformationViewController alloc]init];
        [self.navigationController pushViewController:uuu animated:YES];
    }
}
-(void)goto_loginClicked{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)setPassword{
    SetLogPassViewController *set = [[SetLogPassViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark - scrollView
// 设置滚动时隐藏顶部导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == MyTableView) {
        CGFloat offset=scrollView.contentOffset.y;
        if (offset<0) {
            navImage.alpha = 0;
        }else {
            CGFloat alpha=1-((64-offset)/64);
            navImage.alpha=alpha;
        }
    }
}
#pragma mark -network
-(void)netWork{
    //发起刷新界面的请求
    [SYObject startLoading];
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,USER_CENTER_URL]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
}
#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
                name = [fileContent2 objectAtIndex:2];
                coupon = [dicBig objectForKey:@"coupon"];
                balance = [dicBig objectForKey:@"balance"];
                integral =[dicBig objectForKey:@"integral"];
                level_name = [dicBig objectForKey:@"level_name"];
                photo_url = [dicBig objectForKey:@"photo_url"];
                favoutite_goods_count = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"favoutite_goods_count"]];
                favoutite_store_count = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"favoutite_store_count"]];
                NSNumber *fpc = dicBig[@"footPoint_count"];
                NSInteger fpc1 = fpc.integerValue;
                footPoint_count = [NSString stringWithFormat:@"%lu",(long)fpc1];

            }else{
                [OHAlertView showAlertWithTitle:@"提示" message:@"用户登录已过期" cancelButton:nil otherButtons:@[@"重新登录",@"退出当前账号"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if (buttonIndex == 1){
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSFileManager *fileMgr = [NSFileManager defaultManager];
                        NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"information.txt"];
                        BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
                        if (bRet2) {
                            NSError *err;
                            [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
                        }
                        balance = @"";
                        coupon = @"";
                        integral = @"";
                        ThirdViewController *th = [ThirdViewController sharedUserDefault];
                        th.cart_ids=@"";
                        th.cart_meideng = @"";
                        th.jiesuan.text = @"";
                        th.zongji.text = @"0.00";
                        [MyTableView reloadData];
                        [SYObject failedPrompt:@"您已成功退出！"];
                    }else{
                        ThirdViewController *th = [ThirdViewController sharedUserDefault];
                        th.cart_ids=@"";
                        th.cart_meideng = @"";
                        th.jiesuan.text = @"";
                        th.zongji.text = @"0.00";
                        NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                        [self.navigationController pushViewController:new animated:YES];
                    }

                }];
            }
            [MyTableView reloadData];
        }
    }
    [SYObject endLoading];
}
//-(void)failedPrompt:(NSString *)prompt{
//    [SYObject endLoading];
//}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)TimeOutdoTimer{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}

-(void)UserOut{
    [OHAlertView showAlertWithTitle:nil message:@"是否退出登录" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //退出登录操作
            [self logOut];
        }
    }];
}
-(void)checkMessage{
    if(![[NSFileManager defaultManager]fileExistsAtPath:INFORMATION_FILEPATH]){
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken]
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *ret = dict[@"ret"];
        if ([ret isEqualToString:@"true"]) {
            NSArray *msgList = dict[@"msg_list"];
            NSInteger msgCount = msgList.count;
            NSLog(@"共有%lu条系统信息",(long)msgCount);
            //设置到“badge”
            UsercenterCell *cell = nil;
            NSArray *cells = MyTableView.visibleCells;
            if (cells && cells.count != 0 && [cells.firstObject isKindOfClass:[UsercenterCell class]]) {
                cell = (UsercenterCell *)cells.firstObject;
            }
            if (cell) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (msgCount == 0) {
                        cell.MessageCount.hidden = YES;
                    }else {
                        cell.MessageCount.hidden = NO;
                        cell.MessageCount.text = [NSString stringWithFormat:@"%lu",(long)msgCount];
                    }
                });
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
#pragma mark-alertViewDelegate
-(void)logOut{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"information.txt"];
    BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
    if (bRet2) {
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
    }
    balance = @"";
    coupon = @"";
    integral = @"";
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.cart_ids=@"";
    th.cart_meideng = @"";
    th.jiesuan.text = @"";
    th.zongji.text = @"0.00";
    
    [MyTableView reloadData];
    [SYObject failedPrompt:@"您已成功退出！"];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            //退出登录操作
            [self logOut];
        }
    }
    if (alertView.tag == 101) {
        if (buttonIndex == 1){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"information.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
            balance = @"";
            coupon = @"";
            integral = @"";
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.cart_ids=@"";
            th.cart_meideng = @"";
            th.jiesuan.text = @"";
            th.zongji.text = @"0.00";
            [MyTableView reloadData];
            [SYObject failedPrompt:@"您已成功退出！"];
        }else{
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.cart_ids=@"";
            th.cart_meideng = @"";
            th.jiesuan.text = @"";
            th.zongji.text = @"0.00";
            NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
            [self.navigationController pushViewController:new animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
