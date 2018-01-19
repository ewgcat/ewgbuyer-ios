//
//  LoginViewController.m
//  My_App
//  zhaohan 2015 11 19 修改
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "FastRegisterViewController.h"
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
#import "MyTableViewController.h"
#import "YungouCenterViewController.h"
#import "AppDelegate.h"
#import "LuckyMoneyTableViewController.h"
#import "UserCenterTableViewCell.h"
#import "ExchangeMemberViewController.h"
#import "BlackbottomView.h"
#import "ExperienceMemberViewController2.h"
#import "PromotionCenterTableViewController.h"



#pragma mark -自定义的uibutton,就是说图片在上面，然后文字在下面
@interface myButton : UIButton
{
    CGRect rect;
}
@end

@implementation myButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.titleLabel.font=[UIFont systemFontOfSize:13];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    rect=frame;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(0, 5, rect.size.width, 26);
    self.titleLabel.frame=CGRectMake(0, CGRectGetMaxY(self.imageView.frame), rect.size.width, 30);
    
    
    
}
@end


@interface LoginViewController ()
{
    __weak UILabel *messageCountLabel;// 弱引用消息的数量的label
    

    
}
//头像下面黑色的view
@property (nonatomic,strong)BlackbottomView *blackbottomView;
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
    
    [MyTableView registerNib:[UINib nibWithNibName:@"UserCenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserCenterTableViewCell"];
    // 判断用户是否已登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [SYObject endLoading];
    }else{
        _logBool = YES;

        [SYObject startLoading];
    }
    navImage.alpha = 0;
    orderTag = 0;
    
    
    
    for (UIView *obj in [self.navigationController.navigationBar.subviews[0] subviews]) {
        if ( [obj isKindOfClass:[UIImageView class]]) {
            obj.backgroundColor=[UIColor colorWithRed:216/255.0f green:78/255.0f blue:67/255.0f alpha:1];
            
        }
    }

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
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){//如果没有登录就不做任何处理
    }else{//如果登录啦，就刷新获取数据
        //发起刷新页面的请求
        [self netWork];
    }
   
}
#pragma mark - tabelView方法
// 只有一个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        return 225;
    }else if (indexPath.row==1) {
        return 100;
    }else if (indexPath.row==2) {
        return 100;
    }else if (indexPath.row==3) {
        NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
        NSString *s=[d valueForKey:@"yy"];
        if ([s isEqualToString:@"1"]) {
            return 248;
        }
        return 248+40+40;
    }
    return 0;
}
#pragma mark -全部订单,钱包点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        NSLog(@"点击cell了");
        if(indexPath.row==0){//跳转到用户信息那个界面
            [self goto_userInformation];
        }else if (indexPath.row==1) {//全部订单点击事件
            orderTag = 0;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }else if (indexPath.row==2){
            
            //钱包
            MyWalletViewController *oooo = [[MyWalletViewController alloc]init];
            oooo.myIntegral=integral;
            [self.navigationController pushViewController:oooo animated:YES];
            
        }
    }

  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row==0) {
        
        UserCenterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCenterTableViewCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        [cell.settingButton addTarget:self action:@selector(muchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageButton addTarget:self action:@selector(messageList) forControlEvents:UIControlEventTouchUpInside];
        
        // 底部的黑色视图
        BlackbottomView *v=self.blackbottomView;
        [cell.blackBottomView addSubview:v];
       
        
      messageCountLabel= cell.messageCountLabel;

        if (_logBool==YES) {//登录的
            v.unlogedView.hidden=YES;
            v.logedView.hidden=NO;
            cell.NotLoggedcircleImage.hidden=YES;
            cell.NotLoggedphotoButton.hidden=YES;
//            消息数量的
            cell.messageCountLabel.hidden=NO;
            
            if (cell.messageCountLabel.text.intValue == 0) {
                cell.messageCountLabel.hidden = YES;
            }
           
            
            
            cell.logPhotoImageview.hidden=NO;
            cell.logCircleImageview.hidden=NO;
            
            
            
            cell.nameLabel.hidden=NO;
            cell.rankLabel.hidden=NO;
            cell.accountLabel.hidden=NO;
            cell.indicatorImageview.hidden=NO;
            cell.timeLabel.hidden=NO;
            
            [cell.logPhotoImageview sd_setImageWithURL:[NSURL URLWithString:photo_url] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            
            if (favoutite_goods_count) {
                v.labelcount1.text = favoutite_goods_count;
                
            }
            if (favoutite_store_count) {
                v.labelcount2.text = favoutite_store_count;
                
            }if (footPoint_count) {
                v.labelcount3.text = footPoint_count;
                
            }
            NSLog(@"namename==%@=====%@",name,cell.nameLabel);
            cell.nameLabel.text = name;
            cell.rankLabel.text = level_name;
            if(timeString.length>0){
                cell.timeLabel.text=[NSString stringWithFormat:@"有效期至%@",timeString]; ;

            }else{
                cell.timeLabel.hidden=YES;

            }

        }else{//没登录的
            cell.timeLabel.hidden=YES;

            cell.nameLabel.hidden=YES;
            cell.rankLabel.hidden=YES;
            cell.accountLabel.hidden=YES;
            cell.indicatorImageview.hidden=YES;
            
            v.unlogedView.hidden=NO;
            v.logedView.hidden=YES;
            cell.logPhotoImageview.hidden=YES;
            cell.logCircleImageview.hidden=YES;
            cell.messageCountLabel.hidden=YES;
            
            cell.NotLoggedcircleImage.hidden=NO;
            cell.NotLoggedphotoButton.hidden=NO;
        }
        return cell;
        
    }else if(indexPath.row==1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell11"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
            UIView *v=[self createFivebuttonviewWithTitles:@[@"全部订单",@"查看所有订单"] andButtonTitles:@[@"待付款",@"待发货",@"待收货",@"待评价",@"退款/售后"] andImageNames:@[@"dingdan-icon-daizhifu",@"dingdan-icon-daifahuo",@"dingdan-icon-daishouhuo",@"dingdan-icon-daipingjia",@"dingdan-icon-tuihuozhong"] andTag:100];
            [cell addSubview:v];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
    
    }else if(indexPath.row==2){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell11"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
            UIView *v=[self createFivebuttonviewWithTitles:@[@"我的钱包",@"余额、积分等"] andButtonTitles:@[@"余额",@"积分",@"优惠券",@"我的试用",@"生活惠"] andImageNames:@[@"sybalance",@"syCoupoun",@"coupoon",@"syCard",@"lifecheap"] andTag:2000];
            [cell addSubview:v];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;


        }
        return cell;
        
    }
    else if(indexPath.row==3){
        NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
        NSString *s=[d valueForKey:@"yy"];
        
        //1表示隐藏VIP
        NSLog(@"++++++===%@",s);
        
        UITableViewCell *cell=nil;
        if (cell==nil) {
      
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell22"];
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.contentView.backgroundColor=[UIColor groupTableViewBackgroundColor];
            int y=0;
            if ([s isEqualToString:@"0"]){//0是显示
                
                UIView *jjdj=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"推广中心"AndRightTitle:@"商品销售与收益" AndClickAction:@selector(action100)];
                [cell.contentView addSubview:jjdj];
                y=y+44;
                UIView *v5=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"VIP会员"AndRightTitle:@"推广与收益" AndClickAction:@selector(action5)];
                [cell.contentView addSubview:v5];
                y=y+44;
               
            }
           
            if ([vip_experience isEqualToString:@"NEVER_EXPERIENCE"] && ([level_name isEqualToString:@"普通会员"] || [level_name isEqualToString:@"体验会员"] )) {
                UIView *v6=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"体验会员" AndRightTitle:@"体验会员" AndClickAction:@selector(action6)];
                [cell.contentView addSubview:v6];
                y=y+44;
            }
            if([s isEqualToString:@"0"] ){
                UIView *v7=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"兑换会员" AndRightTitle:@"使用会员卡兑换" AndClickAction:@selector(action7)];
                [cell.contentView addSubview:v7];
                y=y+44;
            }
            
           
            
            
            UIView *v=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"地址管理" AndRightTitle:@"管理收获地址" AndClickAction:@selector(action1)];
            [cell.contentView addSubview:v];
            y=y+44;
            
            UIView *v2=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"账号安全" AndRightTitle:@"可修改密码" AndClickAction:@selector(action2)];
            [cell.contentView addSubview:v2];
            y=y+44;
            
            UIView *v3=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"服务中心" AndRightTitle:@"投诉、咨询等" AndClickAction:@selector(action3)];
            [cell.contentView addSubview:v3];
            y=y+44;
            
            UIView *v4=[self createMyCell:CGRectMake(0, y, self.view.bounds.size.width, 44) AndLetfTitle:@"我的红包" AndRightTitle:@"管理我的红包" AndClickAction:@selector(action4)];
            [cell.contentView addSubview:v4];
            y=y+44;
            //1像素的横线
            UIView *Line=[[UIView alloc]initWithFrame:CGRectMake(0, y,  self.view.bounds.size.width, 0.5)];
            Line.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
            [cell.contentView addSubview:Line];

        }
        return cell;

    }
    return [[UITableViewCell alloc]init];
    
    
    
}
#pragma mark -地址管理
-(void)action1{
    
    if ([self islogin]) {
        AddAdminViewController *addAdminVC = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:addAdminVC animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}

#pragma mark -账户安全
-(void)action2{
    
    if ([self islogin]) {
        AccountSafetyController * safeVC=[[AccountSafetyController alloc] init];
        [self.navigationController pushViewController:safeVC animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}

#pragma mark -服务中心
-(void)action3{
    
    if ([self islogin]) {
        UIStoryboard *sbd = [UIStoryboard storyboardWithName:@"ServiceStoryboard" bundle:nil];
        UITableViewController *tvc = [sbd instantiateViewControllerWithIdentifier:@"serviceCenter"];
        [self.navigationController pushViewController:tvc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}
#pragma mark -我的红包
-(void)action4{
    
    if ([self islogin]) {
        LuckyMoneyTableViewController *vc=[[LuckyMoneyTableViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}
#pragma mark -推广中心
-(void)action100{
    
    if ([self islogin]) {
        PromotionCenterTableViewController *vc=[[PromotionCenterTableViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}

#pragma mark -vip会员
-(void)action5{
    
    if ([self islogin]) {
        NSLog(@"激活vip");
        MyTableViewController *vc=[[MyTableViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}

#pragma mark -体验会员
-(void)action6{
    
    if ([self islogin]) {
        NSLog(@"体验会员");
        ExperienceMemberViewController2 *vc=[[ExperienceMemberViewController2 alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}
#pragma mark -兑换会员
-(void)action7{
    
    if ([self islogin]) {
        NSLog(@"兑换会员");
        ExchangeMemberViewController *vc=[[ExchangeMemberViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLoginUI];
    }
    
}

#pragma mark - 第一个cell中的底部黑色的view
-(BlackbottomView *)blackbottomView{
    if (_blackbottomView==nil) {
        _blackbottomView =[[BlackbottomView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 47)];
        _blackbottomView.button1.tag=103;
        _blackbottomView.button2.tag=102;
        
        _blackbottomView.button3.tag=101;
        
        [_blackbottomView.button1 addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_blackbottomView.button2 addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_blackbottomView.button3 addTarget:self action:@selector(attentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _blackbottomView;
}

#pragma mark - 创建5个按钮的view
-(UIView *)createFivebuttonviewWithTitles:(NSArray *)titles andButtonTitles:(NSArray *)buttonTitles  andImageNames:(NSArray *)names andTag:(int )tag{
    //底部承载视图
    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30+62)];
    bottomview.backgroundColor=[UIColor whiteColor];
//  左边的title
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    leftLabel.textAlignment=NSTextAlignmentCenter;
    leftLabel.font=[UIFont systemFontOfSize:15];

    leftLabel.text=titles[0];
    [bottomview addSubview:leftLabel];
//    第2个title
    
    //右边的图片
    
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-15, 8.5,8 , 13)];
    rightImageView.image=[UIImage imageNamed:@"dis_indicator"];
    [bottomview addSubview:rightImageView];
    //右边的title
    UILabel *rightLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame)-5-150, 0, 150, 30)];
    rightLabel.text=titles[1];
    rightLabel.font=[UIFont systemFontOfSize:11];
    rightLabel.textColor=[UIColor lightGrayColor];
    rightLabel.textAlignment=NSTextAlignmentRight;
    [bottomview addSubview:rightLabel];
    
    
    //1像素的横线
    UIView *startLine=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rightLabel.frame),  self.view.bounds.size.width, 0.5)];
    startLine.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    [bottomview addSubview:startLine];
    
    
    
//    5个按钮
    float y=CGRectGetMaxY(startLine.frame);
    
    for (int i=0; i<buttonTitles.count; i++) {
        
        float width=ScreenFrame.size.width/buttonTitles.count;
        float height=62;
        
        myButton *button=[[myButton alloc]initWithFrame:CGRectMake(width*i, y, width, height)];
        button.tag=tag+i+1;
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
//        button.backgroundColor=[UIColor redColor];
        
        
        [button setImage:[UIImage imageNamed:names[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(mybuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomview addSubview:button];
 

    }

    return  bottomview;
}
-(void)gotoLoginUI{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
#pragma mark -判断是否登录
-(BOOL)islogin{
    // 判断用户是否登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -创建我的cell,这样容易拓展
-(UIView *)createMyCell:(CGRect )frame AndLetfTitle:(NSString *)leftTitle AndRightTitle:(NSString *)rightTitle AndClickAction:(SEL )action{
    UIView *cellView=[[UIView alloc]initWithFrame:frame];
    cellView.backgroundColor=[UIColor whiteColor];
    //1像素的横线
    UIView *startLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.bounds.size.width, 0.5)];
    startLine.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    [cellView addSubview:startLine];
    
    //左边的title
    UILabel *leftLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
    leftLabel.text=leftTitle;
    leftLabel.font=[UIFont systemFontOfSize:15];
    //    leftLabel.textColor=[UIColor lightGrayColor];
    leftLabel.textAlignment=NSTextAlignmentLeft;
    [cellView addSubview:leftLabel];
    
    //右边的图片
    
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-15, 16,8 , 13)];
    rightImageView.image=[UIImage imageNamed:@"dis_indicator"];
    [cellView addSubview:rightImageView];
    //右边的title
    UILabel *rightLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame)-5-150, 0, 150, 44)];
    rightLabel.text=rightTitle;
    rightLabel.font=[UIFont systemFontOfSize:13];
    rightLabel.textColor=[UIColor lightGrayColor];
    rightLabel.textAlignment=NSTextAlignmentRight;
    [cellView addSubview:rightLabel];
    
    //加上手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [cellView addGestureRecognizer:tap];
    
    
    return cellView;
    
}

#pragma mark - 全部订单，我的钱包的按钮点击事件
-(void) mybuttonClick:(UIButton *) btn{
    // 判断用户是否登录
    NSLog(@"tagtag===%zd",btn.tag);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else if(btn.tag<2000){//全部订单
        
        if (btn.tag == 101) {//待付款
            orderTag = 1;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }else if (btn.tag == 102) {//待发货
            orderTag = 2;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }else if (btn.tag == 104) {//待评价--新页面
            SYEvaluateViewController *eva = [[SYEvaluateViewController alloc]init];
            [self.navigationController pushViewController:eva animated:YES];
        }else if (btn.tag == 105) {//退款/售后--新页面
            
            ReturnOutViewController *outVC = [[ReturnOutViewController alloc]init];
            [self.navigationController pushViewController:outVC animated:YES];
        }else  if (btn.tag == 103) {//待收货
            orderTag = 3;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
        
    }else {//我的钱包
    
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
            my.hidesBottomBarWhenPushed=YES;

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
#pragma mark - 用户设置(左上角小齿轮)
-(void)muchBtnClicked{
    NSLog(@"+++++++++++++++++++++");
    MuchViewController *much = [[MuchViewController alloc]init];
    [self.navigationController pushViewController:much animated:YES];
}
#pragma mark -消息列表
-(void)messageList{
    
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        //我的消息
        
        MyMessageViewController *my = [[MyMessageViewController alloc]init];
        my.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:my animated:YES];

    }
}
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnRegister{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
#pragma mark -全部订单上面的3个点击事件
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
#pragma mark -跳转到用户信息的页面
-(void)goto_userInformation{
    
    if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO) {
        NewLoginViewController *log = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }else{
        UserInformationViewController *uuu = [[UserInformationViewController alloc]init];
        [self.navigationController pushViewController:uuu animated:YES];
    }
}
#pragma mark - 点击登录的事件
-(void)goto_loginClicked{
    NSLog(@"点击了登录按钮");
    
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
#pragma mark -networkf
-(void)netWork{
    //发起刷新界面的请求
    [SYObject startLoading];
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
  NSString *urlStr=[NSString stringWithFormat:@"%@%@",FIRST_URL,USER_CENTER_URL];

    NSDictionary *par=@{ @"user_id":[fileContent2 objectAtIndex:3]
                    ,@"token":[fileContent2 objectAtIndex:1]};
    
    NSLog(@"par =%@",par);
   [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {

 
     [self urlRequestSucceeded:responseObject];
 
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"error:%@",[error localizedDescription]);
      [SYObject endLoading];
      [SYObject failedPrompt:@"网络请求失败"];
 
 }];
 

}
#pragma mark - 网络
-(void)urlRequestSucceeded:(id)responseData{
 
        NSDictionary *dicBig=responseData;
        NSLog(@"--+++dicBig:%@",dicBig);
        if (dicBig) {

            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
                
                _logBool=YES;
//                name = [fileContent2 objectAtIndex:2];
                coupon = [dicBig objectForKey:@"coupon"];
                balance = [dicBig objectForKey:@"balance"];
                integral =[dicBig objectForKey:@"integral"];
                level_name = [dicBig objectForKey:@"level_name"];
                photo_url = [dicBig objectForKey:@"photo_url"];
#pragma mark - 这里保存一下自己头像的URL,也保存一下，邀请码，跟二维码多信息，因为我的推广里面需要用到这两个信息
               
                NSString *level_name2=[dicBig objectForKey:@"level_name"];
                NSString *invitation_code=[dicBig objectForKey:@"invitation_code"];
                
                NSString *qrcode_img_path=[dicBig objectForKey:@"qrcode_img_path"];
                
                NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
                [d setObject:photo_url forKey:@"photo_url"];
                [d setObject:invitation_code forKey:@"invitation_code"];
                [d setObject:qrcode_img_path forKey:@"qrcode_img_path"];
                [d setObject:level_name2 forKey:@"level_name"];
                
                
                if(dicBig[@"vip_experience_slogan"]){
                    [d setObject:dicBig[@"vip_experience_slogan"] forKey:@"vip_experience_slogan"];

                }
                if (dicBig[@"user_name"]) {
                    name=dicBig[@"user_name"];
                    [d setObject:name forKey:@"name"];

                }
                if (dicBig[@"true_name"]) {
                   NSString * true_name=dicBig[@"true_name"];
                    [d setObject:true_name forKey:@"true_name"];
                    
                }
                
               
                if (dicBig[@"mobile"]) {
                    // 这里先保存一下手机号码
                    [d setObject:dicBig[@"mobile"] forKey:@"phone"];

                }else{
                    [d setObject:nil forKey:@"phone"];

                }
                if (dicBig[@"team_count"]) {
                    NSLog(@"---%@",dicBig[@"team_count"]);
                    
                    NSString *a=[NSString stringWithFormat:@"%@",dicBig[@"team_count"]];
                    [d setObject:a forKey:@"team_count"];
                }else{
                
                    [d setObject:@"0" forKey:@"team_count"];

                }
                if (dicBig[@"child_reward"]) {
                    NSString *a=[NSString stringWithFormat:@"¥%@",dicBig[@"child_reward"]];

                    [d setObject:a forKey:@"child_reward"];
                }else{
                    
                    [d setObject:@"¥0" forKey:@"child_reward"];
                    
                }
                if (dicBig[@"commission"]) {
                    NSString *a=[NSString stringWithFormat:@"¥%@",dicBig[@"commission"]];
                    [d setObject:a forKey:@"commission"];
                }else{
                    
                    [d setObject:@"¥0" forKey:@"commission"];
                    
                }
                
                
#pragma mark -保存一下推广的信息
                //推广等级
                if (dicBig[@"grade_name"]) {
                    NSString *a=[NSString stringWithFormat:@"%@",dicBig[@"grade_name"]];
                    [d setObject:a forKey:@"grade_name"];
                }
                
                if (dicBig[@"promotion_income"]) {
                    NSString *a=[NSString stringWithFormat:@"¥%.2f",[dicBig[@"promotion_income"] floatValue]];
                    [d setObject:a forKey:@"promotion_income"];
                }else{
                    
                    [d setObject:@"¥0" forKey:@"promotion_income"];
                    
                }
                
                
                if (dicBig[@"amount_income"]) {
                    NSString *a=[NSString stringWithFormat:@"¥%.2f",[dicBig[@"amount_income"] floatValue]];
                    [d setObject:a forKey:@"amount_income"];
                }else{
                    
                    [d setObject:@"¥0" forKey:@"amount_income"];
                    
                }
                
                if (dicBig[@"extract_cash"]) {
                    NSString *a=[NSString stringWithFormat:@"¥%.2f",[dicBig[@"extract_cash"] floatValue]];
                    [d setObject:a forKey:@"extract_cash"];
                }else{
                    
                    [d setObject:@"¥0" forKey:@"extract_cash"];
                    
                }
                [d synchronize];
                
                favoutite_goods_count = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"favoutite_goods_count"]];
                favoutite_store_count = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"favoutite_store_count"]];
                
                
                NSNumber *fpc = dicBig[@"footPoint_count"];
                NSInteger fpc1 = fpc.integerValue;
                footPoint_count = [NSString stringWithFormat:@"%lu",(long)fpc1];
                
                if (dicBig[@"vip_experience"]) {
                    vip_experience=dicBig[@"vip_experience"];
                }
                if (dicBig[@"vip_expired_time"]) {
                    timeString=dicBig[@"vip_expired_time"];
                }

            }else if([[dicBig objectForKey:@"ret"] isEqualToString:@"-400"]){
                [SYObject failedPrompt:@"账号冻结"];
                
                
                
                AppDelegate *app =  (AppDelegate*)[UIApplication sharedApplication].delegate;
                UIWindow *window = app.window;
                
                [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    window.alpha = 0;
                    
                    window.center=CGPointMake(ScreenFrame.size.width/2,  ScreenFrame.size.height/2);
                    window.size=CGSizeMake(0, 0);
                    
                } completion:^(BOOL finished) {
                    exit(0);
                    
                }];

                //exit(0);
                
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
                        _logBool=NO;
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
  
    [SYObject endLoading];
    
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
            
            NSMutableArray *unreadMsg=[NSMutableArray array];
            for (NSDictionary *d in msgList) {
                NSString *s=[NSString stringWithFormat:@"%@",d[@"status"]];
                if ([s isEqualToString:@"0"]) {
                    [unreadMsg addObject:s];
                }
            }
            NSInteger msgCount = unreadMsg.count;
            
            NSLog(@"unreadMsg=%@  unreadMsg==%zd  msgCount==%zd",unreadMsg,unreadMsg.count,msgCount);
            if (msgCount == 0) {
                messageCountLabel.hidden = YES;
                messageCountLabel.text=@"0";//清0
            }else {
                messageCountLabel.hidden = NO;
                messageCountLabel.text=[NSString stringWithFormat:@"%zd",msgCount];
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
    _logBool=NO;
    [MyTableView reloadData];
    [SYObject failedPrompt:@"您已成功退出！"];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 102) {
//        if (buttonIndex == 1) {
//            //退出登录操作
//            [self logOut];
//        }
//    }
//    if (alertView.tag == 101) {
//        if (buttonIndex == 1){
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSFileManager *fileMgr = [NSFileManager defaultManager];
//            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"information.txt"];
//            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
//            if (bRet2) {
//                NSError *err;
//                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
//            }
//            balance = @"";
//            coupon = @"";
//            integral = @"";
//            ThirdViewController *th = [ThirdViewController sharedUserDefault];
//            th.cart_ids=@"";
//            th.cart_meideng = @"";
//            th.jiesuan.text = @"";
//            th.zongji.text = @"0.00";
//            _logBool=NO;
//
//            [MyTableView reloadData];
//            [SYObject failedPrompt:@"您已成功退出！"];
//        }else{
//            ThirdViewController *th = [ThirdViewController sharedUserDefault];
//            th.cart_ids=@"";
//            th.cart_meideng = @"";
//            th.jiesuan.text = @"";
//            th.zongji.text = @"0.00";
//            NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
//            [self.navigationController pushViewController:new animated:YES];
//        }
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
