//
//  CartViewController.m
//  My_App
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CartViewController.h"
#import "ASIFormDataRequest.h"
#import "writeViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "NilCell.h"
#import "DemoSectionItemSubclass.h"
#import "NewLoginViewController.h"
#import "Reachability.h"
#import "ThirdViewController.h"
#import "FirstViewController.h"
#import "CartCell.h"
#import "Cart1Cell.h"
#import "Cart2Cell.h"
#import "Cart3Cell.h"
@interface CartViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    ASIFormDataRequest *request_10;
    ASIFormDataRequest *request_11;
    ASIFormDataRequest *request_12;
    ASIFormDataRequest *request_13;
    ASIFormDataRequest *request_14;
    ASIFormDataRequest *request_15;
    ASIFormDataRequest *request_16;
    ASIFormDataRequest *request_17;
    ASIFormDataRequest *request_18;
    ASIFormDataRequest *request_19;
    ASIFormDataRequest *request_20;
    ASIFormDataRequest *request_21;
    ASIFormDataRequest *request_22;
    UIView *networkView;
    UIView *bottomView;
    UIView *semiTransparentView;
    UIView *specifView;
    UITableView *specTableView;
    UIButton * cardButton;
    NSMutableArray *specArray;
    NSMutableString *specIdsString;
    NSMutableArray *specIdsArray;
    NSMutableString *cartId;
    NSString *goodsId;
    BOOL selectMansong;
    
}
@end
static CartViewController *singleInstance=nil;

@implementation CartViewController
@synthesize MyTableView,btnQ,btnQ2;
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
-(void)netExist{
    networkView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-44)];
    networkView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageNoth = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 50, 140, 140)];
    imageNoth.image = [UIImage imageNamed:@"wifi@2x.png"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, ScreenFrame.size.width, 22)];
    label.text = @"加载失败请检查当前的网络环境~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    
    if (ScreenFrame.size.height<=480) {
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 50, 140, 140);
        label.frame = CGRectMake(0, 200, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 130, 140, 140);
        label.frame = CGRectMake(0, 280, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 180, 140, 140);
        label.frame = CGRectMake(0, 330, ScreenFrame.size.width, 22);
    }else{
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 200, 140, 140);
        label.frame = CGRectMake(0, 350, ScreenFrame.size.width, 22);
    }
    [networkView addSubview:imageNoth];
    [networkView addSubview:label];
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        MyTableView.hidden = YES;
        networkView.hidden=NO;
        buttonDelete.hidden=YES;
        [self.view addSubview:networkView];
    }else{
        MyTableView.hidden = NO;
        buttonDelete.hidden=NO;
        [networkView removeFromSuperview];
        [self.view bringSubviewToFront:buttonDelete];
        [self.view bringSubviewToFront:MyTableView];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self netExist];
    self.tabBarController.tabBar.hidden = YES;
      //购物车数量提示
    [SYShopAccessTool getItemBadgeValue];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        logView.hidden = NO;
        MyTableView.frame = CGRectMake(0, 44, ScreenFrame.size.width, ScreenFrame.size.height-44-64-56);
        labelWu.frame = CGRectMake(0,49, ScreenFrame.size.width, ScreenFrame.size.height);
        
    }else{
        logView.hidden = YES;
        MyTableView.frame = CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-56);
        labelWu.frame = CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self carShoppingRefresh];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    btnQ.selected=YES;
    [self allSelected:btnQ];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [networkView removeFromSuperview];
    [self setThirdViewController];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
      //购物车数量提示
    [SYShopAccessTool getItemBadgeValue];
   //1.28 00025
//    btnQ.selected=YES;
//    [self allSelected:btnQ];
}
-(void)setThirdViewController{
    ThirdViewController *th=[ThirdViewController sharedUserDefault];
    th.jie_cart_ids=_jie_cart_ids;
    th.jie_order_goods_price= _jie_order_goods_price;
    th.jie_reduce=_jie_reduce;
    th.jie_store_ids= _jie_store_ids;
    th.tic_pu=_tic_pu;
    th.tic_taitou=_tic_taitou;
    th.paymark=_paymark;
    th.pay=_pay;
    th.fee=_fee;
    th.wuliu=_wuliu;
    th.Qzongji = _Qzongji;
    th.zongji.text=_zongji.text;
    th.cart_meideng=_cart_meideng;
    th.cart_ids=_cart_ids;
    th.jiesuan= _jiesuan;
    th.goods_id=_goods_id;
 
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"购物车";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"购物车";
    NAV_COLOR(RGB_COLOR(219,34,46));
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(219,34,46);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-56) style:UITableViewStyleGrouped];
    MyTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    [MyTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.view addSubview:MyTableView];
    
    logView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 49)];
    logView.backgroundColor = UIColorFromRGB(0XFAFFF0);
    [self.view addSubview:logView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 7.5, 70, 34);
    UILabel *labe=[LJControl labelFrame:CGRectMake(0, 0, 70, 34) setText:@"登 录" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [labe.layer setMasksToBounds:YES];
    [labe.layer setCornerRadius:6];
    [labe.layer setBorderWidth:1];
    [labe.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [btn addSubview:labe];
    [btn addTarget:self action:@selector(btnLogin) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [logView addSubview:btn];
    UILabel *labelP = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, ScreenFrame.size.width-105, 49)];
    labelP.numberOfLines = 2;
    labelP.font = [UIFont systemFontOfSize:15];
    labelP.text = @"您可以在登录后同步电脑与手机购物车中的商品";
    labelP.textColor=[UIColor lightGrayColor];
    [logView addSubview:labelP];
    
    
    
    labelWu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-44)];
    labelWu.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    [self.view addSubview:labelWu];
    UIImageView *imageNoth = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 50, 140, 140)];
    imageNoth.image = [UIImage imageNamed:@"nothing"];
    [labelWu addSubview:imageNoth];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, ScreenFrame.size.width, 22)];
    label.text = @"购物车还是空的,去首页看看吧~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    [labelWu addSubview:label];
    
    UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-150)/2, 230, 150, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    UILabel *titLabel=[LJControl labelFrame:CGRectMake(0, 0, 150, 40) setText:@"去首页" setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter];
    [titLabel.layer setMasksToBounds:YES];
    [titLabel.layer  setCornerRadius:6.0];
    [button addSubview:titLabel];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [labelWu addSubview:button];
    
    
    
    if (ScreenFrame.size.height<=480) {
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 50, 140, 140);
        label.frame = CGRectMake(0, 200, ScreenFrame.size.width, 22);
        button.frame = CGRectMake((ScreenFrame.size.width-150)/2, 230, 150,  40);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 130, 140, 140);
        label.frame = CGRectMake(0, 280, ScreenFrame.size.width, 22);
        button.frame = CGRectMake((ScreenFrame.size.width-150)/2, 310, 150, 40);
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 180, 140, 140);
        label.frame = CGRectMake(0, 330, ScreenFrame.size.width, 22);
        button.frame = CGRectMake((ScreenFrame.size.width-150)/2, 360,150, 40);
    }else{
        imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 200, 140, 140);
        label.frame = CGRectMake(0, 350, ScreenFrame.size.width, 22);
        button.frame = CGRectMake((ScreenFrame.size.width-150)/2, 380, 150, 40);
    }
    [SYObject startLoading];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mansongView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height)];
    mansongView.hidden = YES;
    [self.view addSubview:mansongView];
    
    
    [self buttonLog];
    [self createBackBtn];
    sureBool = NO;
    giftTag = -1;
    mansongTag = -100;
    

    _tic_pu = @"普通发票";
    _tic_taitou = @"个人";
    _paymark = online_mark;
    _pay = @"请选择支付方式";
    _fee =  @"请选择配送方式";
    _wuliu = @"0.00";
    
    _Qzongji = 0;
    _myBool2 = YES;
    _myBool = NO;
    
    dataArray = [[NSMutableArray alloc]init];
    arr_discount_list = [[NSMutableArray alloc]init];
    activityArray = [[NSMutableArray alloc]init];
    mansongGiftStringArray = [[NSMutableArray alloc]init];
    combinDataArray = [[NSMutableArray alloc]init];
    
    [searchbtn addTarget:self action:@selector(refreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    bottomView = [[UIView alloc]init];
    bottomView.backgroundColor =[UIColor blackColor];
    bottomView.alpha=0.8;
    bottomView.frame = CGRectMake(0, ScreenFrame.size.height-56-64, ScreenFrame.size.width, 56);
    [self.view addSubview:bottomView];
    UIImageView *imageLineTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 0.5)];
    imageLineTop.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:imageLineTop];
    
    btnQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
    //btnQ.frame = CGRectMake(0, 2, 40, 40);
    btnQ.frame = CGRectMake(0, ScreenFrame.size.height-56-64+8, 40, 40);
    btnQ.tag = 101;
    [btnQ addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    //[bottomView addSubview:btnQ];
    [self.view addSubview:btnQ];
    
    UILabel *lae3 = [[UILabel alloc]initWithFrame:CGRectMake(31,12, 40, 32)];
    lae3.text = @"全选";
    lae3.textColor = [UIColor grayColor];
    lae3.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:lae3];
    
    UILabel *lae = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-55-180-10,12, 90, 32)];
    lae.tag=102;
    lae.text = @"商品总计:￥";
    lae.textColor = [UIColor whiteColor];
    lae.font = [UIFont boldSystemFontOfSize:15];
    [bottomView addSubview:lae];
    
    _zongji = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-55-110, 12, 140,32)];
    _zongji.text = @"0";
    _zongji.textColor = [UIColor whiteColor];
    _zongji.font = [UIFont boldSystemFontOfSize:15];
    [bottomView addSubview:_zongji];
    
    btnQ2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnQ2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btnQ2.frame = CGRectMake(bottomView.frame.size.width-60,0, 60,56);
    btnQ2.backgroundColor = [UIColor grayColor];
    [btnQ2 addTarget:self action:@selector(settle_accounts) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnQ2];
    
//    UIImageView *imageLineTop1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,44-0.5, bottomView.frame.size.width, 0.5)];
//    imageLineTop1.backgroundColor = [UIColor lightGrayColor];
//    [bottomView addSubview:imageLineTop1];
    
    _jiesuan = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, 34, 30)];
    _jiesuan.text = @"0";
    _jiesuan.textColor = [UIColor whiteColor];
    _jiesuan.textAlignment = NSTextAlignmentCenter;
    _jiesuan.font = [UIFont boldSystemFontOfSize:16];
    
    UILabel *str = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
    str.text = [NSString stringWithFormat:@"结算(%@)",_jiesuan.text];
    [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
    [btnQ2 addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btnQ2 addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    CGRect titleSize = [str.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    btnQ2.frame = CGRectMake(ScreenFrame.size.width-titleSize.size.width-30, btnQ2.frame.origin.y, titleSize.size.width+30, btnQ2.frame.size.height);
    
    
    [self SpecificationInformation];
}

//去首页
-(void)buttonClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    FirstViewController *fvc=[FirstViewController sharedUserDefault];
    fvc.tabBarController.selectedIndex = 0;
    
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [self carShoppingRefresh];
    [MyTableView headerEndRefreshing];
}
#pragma mark -规格信息
-(void)SpecificationInformation{
    semiTransparentView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, ScreenFrame.size.height) backgroundColor:[UIColor blackColor]];
    semiTransparentView.alpha=0.6;
    [self.navigationController.view addSubview:semiTransparentView];
    
    specifView=[LJControl viewFrame:CGRectMake(0,  ScreenFrame.size.height-400, ScreenFrame.size.width,400) backgroundColor:[UIColor whiteColor]];
    
    
    [self.navigationController.view addSubview:specifView];
    
    UIImageView *photoImageView=[LJControl imageViewFrame:CGRectMake(10,90-(ScreenFrame.size.width/2-30), ScreenFrame.size.width/2-30,ScreenFrame.size.width/2-30) setImage:@"" setbackgroundColor:[UIColor whiteColor]];
    photoImageView.tag=1000;
    photoImageView.layer.borderWidth = 1;
    photoImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [specifView addSubview:photoImageView];
    
    UILabel *pricelabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10,5, ScreenFrame.size.width/2, 25) setText:@"  ￥:--.--" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentLeft];
    pricelabel.tag=1001;
    [specifView addSubview:pricelabel];
    
    UILabel *stocklabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10, 30, ScreenFrame.size.width/2, 25) setText:@"库存:----" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor]textAlignment:NSTextAlignmentLeft];
    stocklabel.tag=1002;
    [specifView addSubview:stocklabel];
    
    UILabel *choicelabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10, 55, ScreenFrame.size.width/2, 40) setText:@"已选:" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor]textAlignment:NSTextAlignmentLeft];
    choicelabel.numberOfLines=2;
    choicelabel.tag=1003;
    [specifView addSubview:choicelabel];
    
    specTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,100,ScreenFrame.size.width,240) style:UITableViewStyleGrouped];
    specTableView.backgroundColor=[UIColor clearColor];
    specTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    specTableView.delegate = self;
    specTableView.dataSource=  self;
    specTableView.showsVerticalScrollIndicator=NO;
    specTableView.showsHorizontalScrollIndicator = NO;
    [specifView addSubview:specTableView];
    
    cardButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0,specifView.bounds.size.height-50,ScreenFrame.size.width,40) setNormalImage:nil setSelectedImage:nil setTitle:@"确定" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0Xdf0000)];
    
    cardButton.frame=CGRectMake(0, 290, ScreenFrame.size.width,40);
    cardButton.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
    [cardButton addTarget:self action:@selector(cardClicked:) forControlEvents:UIControlEventTouchUpInside];
    [specifView addSubview:cardButton];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [semiTransparentView addGestureRecognizer:tap];
    
    
    semiTransparentView.hidden=YES;
    specifView.hidden=YES;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    //隐藏属性
//    self.tabBarController.tabBar.hidden = NO;
    semiTransparentView.hidden=YES;
    specifView.hidden=YES;
    
}
-(void)cardClicked:(UIButton *)btn{
    //点击确定
    if (specIdsArray.count>0) {
        [specIdsString setString:(NSString *)[specIdsArray componentsJoinedByString:@","]];
    }
    [self getCartSpecSave:specIdsString andCartId:cartId];
}
#pragma mark - 购物车修改商品规格

-(void)getCartSpecSave:(NSString *)specIds andCartId:(NSString *)cartid{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARTSPECSAVE_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [request setPostValue:@"" forKey:@"user_id"];
        [request setPostValue:@"" forKey:@"token"];
        [request setPostValue:cartid forKey:@"id"];
        [request setPostValue:specIds forKey:@"gsp"];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [request setPostValue:@"" forKey:@"cart_mobile_ids"];
        }else{
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
        }
    }else{
        [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
        [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
        [request setPostValue:cartid forKey:@"id"];
        [request setPostValue:specIds forKey:@"gsp"];
        [request setPostValue:@"" forKey:@"cart_mobile_ids"];
    }
    ///读取本地id
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSString *areaId=[standard objectForKey:@"area_id"];
    [request setPostValue:areaId forKey:@"area_id"];
    
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1002;
    [request setDelegate:self];
    [request startAsynchronous];
}
#pragma mark -刷新购物车
-(void)carShoppingRefresh{
    //刷新购物车
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    [SYObject startLoading];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
        request_16=[ASIFormDataRequest requestWithURL:url3];
        [request_16 setPostValue:@"" forKey:@"user_id"];
        [request_16 setPostValue:@"" forKey:@"token"];
        
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [request_16 setPostValue:@"" forKey:@"cart_mobile_ids"];
        }else{
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_16 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
        }
        
        NSArray *arrObjc3;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
        }
        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
        [request_16 setRequestHeaders:dicMy3];
        request_16.tag = 101;
        request_16.delegate =self;
        [request_16 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_16 setDidFinishSelector:@selector(my12_urlRequestSucceeded:)];
        [request_16 startAsynchronous];
    }else{
        //已经登录
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
        request_17=[ASIFormDataRequest requestWithURL:url3];
        [request_17 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_17 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [request_17 setPostValue:@"" forKey:@"cart_mobile_ids"];
        }else{
            //存在cart_mobile_id文件
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_17 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
        }
        [request_17 setPostValue:_cart_ids forKey:@"selected_ids"];
        
        NSArray *arrObjc3;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
        }
        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
        [request_17 setRequestHeaders:dicMy3];
        request_17.tag = 101;
        request_17.delegate =self;
        [request_17 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_17 setDidFinishSelector:@selector(my13_urlRequestSucceeded:)];
        [request_17 startAsynchronous];
    }
}
-(void)my12_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig10:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        if (arr_discount_list.count!=0) {
            [arr_discount_list removeAllObjects];
        }
        
        [arr_discount_list addObject:@"cart_list"];
        if (dicBig) {
            //拿到有活动的key
            NSArray *arrlist = [dicBig objectForKey:@"discount_list"];
            [arr_discount_list addObjectsFromArray:arrlist];
            
            for(int i=0;i<arr_discount_list.count;i++){
                [dataArray addObject:[dicBig objectForKey:[arr_discount_list objectAtIndex:i]]];
            }
            NSLog(@"dataArraydataArray:%@",dataArray);
            //拿到有活动的key
            if(dataArray.count == 0){
                bottomView.hidden=YES;
                btnQ.hidden=YES;
                labelWu.hidden = NO;
                MyTableView.hidden=YES;
                buttonDelete.hidden=YES;
            }else if(dataArray.count == 1){
                NSArray *arrCCC = [dataArray objectAtIndex:0];
                if (arrCCC.count == 0) {
                    labelWu.hidden = NO;
                     MyTableView.hidden=YES;
                    buttonDelete.hidden=YES;
                    bottomView.hidden=YES;
                    btnQ.hidden=YES;
                }else{
                    labelWu.hidden = YES;
                    MyTableView.hidden=NO;
                    buttonDelete.hidden=NO;
                    bottomView.hidden=NO;
                    btnQ.hidden=NO;
                }
            }else{
                labelWu.hidden = YES;
                MyTableView.hidden=NO;
                buttonDelete.hidden=NO;
                bottomView.hidden=NO;
                btnQ.hidden=NO;
            }
            for(int i=0;i<arr_discount_list.count;i++){
                if([[arr_discount_list objectAtIndex:i] rangeOfString:@"combine_"].location !=NSNotFound){
                    ;
                    [self combineClicked:i];
                    break;
                }
            }
            
            if (mansongGiftStringArray.count!=0) {
                [mansongGiftStringArray removeAllObjects];
            }
            for(int i=0;i<activityArray.count+1;i++){
                [mansongGiftStringArray addObject:@""];
            }
        }
        //删除cart文件
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        }else{
            //删除文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
        }
        [SYObject endLoading];
    }
    else{
        
    }
    [MyTableView reloadData];
   [SYObject endLoading];
}
-(void)my13_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig11:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        if (arr_discount_list.count!=0) {
            [arr_discount_list removeAllObjects];
        }
        [arr_discount_list addObject:@"cart_list"];
        if (dicBig) {
            //拿到有活动的key
            NSArray *arrlist = [dicBig objectForKey:@"discount_list"];
            [arr_discount_list addObjectsFromArray:arrlist];;
            for(int i=0;i<arr_discount_list.count;i++){
                [dataArray addObject:[dicBig objectForKey:[arr_discount_list objectAtIndex:i]]];
            }
            if(dataArray.count == 0){
                labelWu.hidden = NO;
                 MyTableView.hidden=YES;
                buttonDelete.hidden=YES;
                bottomView.hidden=YES;
                btnQ.hidden=YES;
            }else if(dataArray.count == 1){
                NSArray *arrCCC = [dataArray objectAtIndex:0];
                if (arrCCC.count == 0) {
                    labelWu.hidden = NO;
                     MyTableView.hidden=YES;
                    buttonDelete.hidden=YES;
                    bottomView.hidden=YES;
                    btnQ.hidden=YES;
                }else{
                    labelWu.hidden = YES;
                     MyTableView.hidden=NO;
                    buttonDelete.hidden=NO;
                    bottomView.hidden=NO;
                    btnQ.hidden=NO;
                }
            }else{
                labelWu.hidden = YES;
                MyTableView.hidden=NO;
                buttonDelete.hidden=NO;
                bottomView.hidden=NO;
                btnQ.hidden=NO;
            }
            
            if (combinDataArray.count!=0) {
                [combinDataArray removeAllObjects];
            }
            for(int i=0;i<arr_discount_list.count;i++){
                if([[arr_discount_list objectAtIndex:i] rangeOfString:@"combine_"].location !=NSNotFound){
                    ;
                    [self combineClicked:i];
                }
            }
        }
        //删除cart文件
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        }else{
            //删除文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
        }
        
    }
    else{
    }
    
    [MyTableView reloadData];
    [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
   [SYObject endLoading];
    labelWu.hidden = YES;
    buttonDelete.hidden=NO;
   [SYObject failedPrompt:@"网络请求失败"];
    MyTableView.hidden = YES;
    networkView.hidden=NO;
    [self.view bringSubviewToFront:networkView];
}
#define mark -跳转登录界面
-(void)btnLogin{
    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
#pragma mark -编辑按钮
-(void)createBackBtn{
    buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonDelete.frame =CGRectMake(0, 0, 44, 44);
    [buttonDelete setTitle:@"编辑" forState:UIControlStateNormal];
    [buttonDelete addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonDelete.titleLabel.font  = [UIFont systemFontOfSize:17];
    buttonDelete.selected=NO;
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:buttonDelete];
    self.navigationItem.rightBarButtonItem =bar;
    
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar1;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editClick:(UIButton *)btn{
    if (!semiTransparentView.hidden||!specifView.hidden) {
        semiTransparentView.hidden=YES;
        specifView.hidden=YES;
        self.tabBarController.tabBar.hidden = NO;
    }else{
        btn.selected=!btn.selected;
        if (btn.selected) {
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            // bottomView.backgroundColor =UIColorFromRGB(0XF5F5F5);
            UILabel *lea=(UILabel *)[bottomView viewWithTag:102];
            lea.hidden=YES;
            _zongji.hidden=YES;
            [btnQ2 setTitle:@"删除"forState:UIControlStateNormal];
            [btnQ2 removeTarget:self action:@selector(settle_accounts) forControlEvents:UIControlEventTouchUpInside];
            [btnQ2 addTarget:self action:@selector(Delete) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
            //bottomView.backgroundColor =BACKGROUNDCOLOR;
            UILabel *lea=(UILabel *)[bottomView viewWithTag:102];
            lea.hidden=NO;
            _zongji.hidden=NO;
            [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
            [btnQ2 removeTarget:self action:@selector(Delete) forControlEvents:UIControlEventTouchUpInside];
            [btnQ2 addTarget:self action:@selector(settle_accounts) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //1.28 00025
    [self tableviewRefrsh];
    [MyTableView reloadData];
}
#pragma mark -返回
-(void)BackClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)refreshClicked:(id)sender{
    [SYObject startLoading];
    MyTableView.hidden = NO;
    labelWu.hidden = NO;
    buttonDelete.hidden=YES;
    [self carShoppingRefresh];
}


#pragma mark -全选
-(void)allSelected:(UIButton *)btn{
    btn.selected=!btn.selected;
    if (btn.selected) {
        //全选
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            _cart_meideng=[self getAllCartIds];
        }else{
            _cart_ids=[self getAllCartIds];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
    }else{
        //取消
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            _cart_meideng=@"";
        }else{
            _cart_ids=@"";
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
        
    }
    [self tableviewRefrsh];
    [MyTableView reloadData];
}
-(NSMutableString *)getAllCartIds{
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        NSArray *arr;
        if (i == 0) {
            arr = (NSArray *)dic;
        }else{
            arr = [dic objectForKey:@"goods_list"];
        }
        for (NSDictionary *dict in arr) {
            [mArray addObject:[dict objectForKey:@"cart_id"]];
        }
        
    }
    NSMutableString *mString=[[NSMutableString alloc]initWithString:[mArray componentsJoinedByString:@","]];
    return mString;
}
#pragma mark -事件
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 1000003) {
        if ([textFF.text intValue]==1) {
            CountMyX.text = [NSString stringWithFormat:@"×%@",textFF.text];
        }else{
            textFF.text = [NSString stringWithFormat:@"%d",[textFF.text intValue]-1];
            CountMyX.text = [NSString stringWithFormat:@"×%@",textFF.text];
        }
    }
    if (btn.tag == 1000004) {
        textFF.text = [NSString stringWithFormat:@"%d",[textFF.text intValue]+1];
        CountMyX.text = [NSString stringWithFormat:@"×%@",textFF.text];
    }
    if (btn.tag == 1000001) {
        [textFF resignFirstResponder];
        [viwe removeFromSuperview];
        MyTableView.userInteractionEnabled = YES;
    }
    if (btn.tag == 1000002) {
        if (textFF.text.length == 0) {
            
            [SYObject failedPrompt:@"数量不能为空"];
           
        }else if ([textFF.text intValue]==0){
            [SYObject failedPrompt:@"数量不能为0"];
        }else{
            [SYObject startLoading];
            [viwe removeFromSuperview];
            //发起该数量的请求
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCARCOUNT_URL]];
            request_21=[ASIFormDataRequest requestWithURL:url3];
            [request_21 setPostValue:textFF.text forKey:@"count"];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                [request_21 setPostValue:@"" forKey:@"user_id"];
                [request_21 setPostValue:@"" forKey:@"token"];
                [request_21 setPostValue:cartidcan forKey:@"cart_id"];
                [request_21 setPostValue:@"" forKey:@"cart_mobile_ids"];
            }else{
                [request_21 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request_21 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request_21 setPostValue:cartidcan forKey:@"cart_id"];
                [request_21 setPostValue:@"" forKey:@"cart_mobile_ids"];
            }
            NSArray *arrObjc3;
            if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
            }else{
                arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
            }
            NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
            [request_21 setRequestHeaders:dicMy3];
            request_21.tag = 201;
            request_21.delegate =self;
            [request_21 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_21 setDidFinishSelector:@selector(my17_urlRequestSucceeded:)];
            [request_21 startAsynchronous];
        }
    }
    
    if (btn.tag == 101) {
        if (_myBool2 == YES) {//点击全选了
            // btnQ2.enabled = YES;
            btnQ2.backgroundColor = UIColorFromRGB(0xf15353);
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                //应该将id字符串填满
                NSString *str;
                if(dataArray.count!=0){
                    for(int i=0;i<dataArray.count;i++){
                        NSDictionary *ddd = [dataArray objectAtIndex:i];
                        NSArray *arr;
                        NSLog(@"arr:%@",arr);
                        if (i == 0) {
                            arr = (NSArray *)ddd;
                        }else{
                            arr = [ddd objectForKey:@"goods_list"];
                        }
                        for(int j = 0;j<arr.count;j++){
                            if (str.length == 0) {
                                str = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:j] objectForKey:@"cart_id"]];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[arr objectAtIndex:j] objectForKey:@"cart_id"]];
                            }
                        }
                    }
                }
                
                _cart_meideng = str;
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                
                _myBool2 = NO;
                NSInteger jia = 0;
                if(dataArray.count!=0){
                    for(int i=0;i<dataArray.count;i++){
                        NSArray *arrDic = [dataArray objectAtIndex:i];
                        
                        jia = jia+arrDic.count;
                    }
                }
                _jiesuan.text = [NSString stringWithFormat:@"%ld",(long)jia];
                [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
                [self tableviewRefrsh];
            }else{
                //应该将id字符串填满
                NSString *str;
                if(dataArray.count!=0){
                    for(int i=0;i<dataArray.count;i++){
                        NSDictionary *ddd = [dataArray objectAtIndex:i];
                        NSArray *arr;
                        NSLog(@"arr:%@",arr);
                        if (i == 0) {
                            arr = (NSArray *)ddd;
                        }else{
                            arr = [ddd objectForKey:@"goods_list"];
                        }
                        for(int j = 0;j<arr.count;j++){
                            if (str.length == 0) {
                                str = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:j] objectForKey:@"cart_id"]];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[arr objectAtIndex:j] objectForKey:@"cart_id"]];
                            }
                        }
                    }
                }
                
                _cart_ids = str;
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
                
                _myBool2 = NO;
                NSInteger jia = 0;
                if(dataArray.count!=0){
                    for(int i=0;i<dataArray.count;i++){
                        NSArray *arrDic = [dataArray objectAtIndex:i];
                        
                        jia = jia+arrDic.count;
                    }
                }
                _jiesuan.text = [NSString stringWithFormat:@"%ld",(long)jia];
                [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
                [self tableviewRefrsh];
            }
        }
        else{//取消全选了
            // btnQ2.enabled = NO;
            btnQ2.backgroundColor = [UIColor grayColor];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                //清空id字符串
                _cart_meideng = @"";
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
                _zongji.text = @"0.00";
                _myBool2 = YES;
                _jiesuan.text = [NSString stringWithFormat:@"0"];
                [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
            }else{
                //清空id字符串
                _cart_ids = @"";
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
                _zongji.text = @"0.00";
                _myBool2 = YES;
                _jiesuan.text = [NSString stringWithFormat:@"0"];
                [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
            }
        }
        [MyTableView reloadData];
        [self tableviewRefrsh];
    }
}
#pragma mark -点击结算
-(void)settle_accounts{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [OHAlertView showAlertWithTitle:@"温馨提示" message:@"您还未登录" cancelButton:nil otherButtons:@[@"去登录"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
                NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                [self.navigationController pushViewController:new animated:YES];
            }else{
            }
        }];
    }else{
        if ([_jiesuan.text intValue]>0) {
            //发起goods_id的请求
            NSArray *arrGG = [_cart_ids componentsSeparatedByString:@","];
            if (_goods_id.length!=0) {
                _goods_id = @"";
            }
            
            for(int i=0;i<arrGG.count;i++){
                NSString *SS = [arrGG objectAtIndex:i];
                if (SS.length == 0) {
                    
                }else if ([SS isEqualToString:@"(null)"]){
                    
                }else{
                    for(int j=0;j<dataArray.count;j++){
                        NSDictionary *class = [dataArray objectAtIndex:j];
                        NSArray *arrSS ;
                        if (j == 0) {
                            arrSS = (NSArray *)class;
                        }else{
                            arrSS = [class objectForKey:@"goods_list"];
                        }
                        for(int n = 0;n<arrSS.count;n++){
                            if ([[[arrSS objectAtIndex:n] objectForKey:@"cart_id"] intValue] == [SS intValue]) {
                                if (_goods_id.length == 0) {
                                    _goods_id = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrSS objectAtIndex:n] objectForKey:@"goods_id"]]];
                                }else{
                                    _goods_id = [NSString stringWithFormat:@"%@,%@",_goods_id,[NSString stringWithFormat:@"%@",[[arrSS objectAtIndex:n] objectForKey:@"goods_id"]]];
                                }
                            }
                        }
                    }
                }
            }
            
            [SYObject startLoading];
            NSLog(@"_goods_id:%@",_goods_id);
            //发起结算请求
            if ([self isNoGoodsMaskCarts:_cart_ids]) {
                [SYObject failedPrompt:@"所选商品中存在库存不足的商品"];
            }else{
                [SYObject startLoading];
                //发起结算请求
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CAR_UP_ORDER_URL]];
                request_20=[ASIFormDataRequest requestWithURL:url3];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                [request_20 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request_20 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request_20 setPostValue:_cart_ids forKey:@"cart_ids"];
                
                NSArray *arrObjc3;
                if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                    arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                }else{
                    arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                }
                NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                [request_20 setRequestHeaders:dicMy3];
                request_20.tag = 104;
                request_20.delegate =self;
                [request_20 setDidFailSelector:@selector(urlRequestFailed:)];
                [request_20 setDidFinishSelector:@selector(my16_urlRequestSucceeded:)];
                [request_20 startAsynchronous];
                
            }
        }else{
        }
    }
}
-(void)my16_urlRequestSucceeded:(ASIHTTPRequest *)request{
     ThirdViewController *third = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig14:%@",dicBig);
        if([[dicBig allKeys]containsObject:@"vatInvoice"])
        {
            third.ticBOOL=YES;
            third.ticdic=[dicBig objectForKey:@"vatInvoice"];
            
        }else
        {
            third.ticBOOL=NO;
            
        }

        _jie_cart_ids = [dicBig objectForKey:@"cart_ids"];
        _jie_order_goods_price = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_goods_price"]];
        if ([[dicBig allKeys] containsObject:@"reduce"]){
            _jie_reduce = [[dicBig objectForKey:@"reduce"] intValue];
        }else{
            _jie_reduce = 0;
        }
        _jie_store_ids = [dicBig objectForKey:@"store_ids"];
        //  btnQ2.enabled = YES;
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        [dataArray removeAllObjects];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [OHAlertView showAlertWithTitle:@"温馨提示" message:@"您还未登录" cancelButton:nil otherButtons:@[@"去登录"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                    [self.navigationController pushViewController:new animated:YES];
                }else{
                }
            }];
        }else{
            writeViewController *write = [[writeViewController alloc]init];
            [self.navigationController pushViewController:write animated:YES];
        }
    }else{
        
    }
   [SYObject endLoading];
}

#pragma mark -删除
-(void)Delete{
    //先判断是否有选中的id 有则弹出提示删除 没有则提示没有选中商品无法删除
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        if ([_cart_meideng isEqualToString:@"(null)"]) {
             [SYObject failedPrompt:@"请先选中要删除的商品"];
           
        }else if (_cart_meideng.length==0) {
             [SYObject failedPrompt:@"请先选中要删除的商品"];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要删除该商品吗？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0){
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        //删除的是没登陆的
                        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                        request_18=[ASIFormDataRequest requestWithURL:url3];
                        [request_18 setPostValue:@"" forKey:@"user_id"];
                        [request_18 setPostValue:@"" forKey:@"token"];
                        [request_18 setPostValue:_cart_meideng forKey:@"cart_ids"];
                        
                        NSArray *arrObjc3;
                        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                        }else{
                            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                        }
                        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                        [request_18 setRequestHeaders:dicMy3];
                        request_18.tag = 103;
                        request_18.delegate =self;
                        [request_18 setDidFailSelector:@selector(urlRequestFailed:)];
                        [request_18 setDidFinishSelector:@selector(my14_urlRequestSucceeded:)];
                        [request_18 startAsynchronous];
                    }else{
                        //删除的是已登陆的
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                        request_19=[ASIFormDataRequest requestWithURL:url3];
                        [request_19 setPostValue:@"" forKey:@"cart_mobile_ids"];
                        [request_19 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_19 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                        [request_19 setPostValue:_cart_ids forKey:@"cart_ids"];
                        NSArray *arrObjc3;
                        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                        }else{
                            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                        }
                        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                        [request_19 setRequestHeaders:dicMy3];
                        request_19.tag = 103;
                        request_19.delegate =self;
                        [request_19 setDidFailSelector:@selector(urlRequestFailed:)];
                        [request_19 setDidFinishSelector:@selector(my15_urlRequestSucceeded:)];
                        [request_19 startAsynchronous];
                    }
                }
            }];
        }
        
    }else{
        if ([_cart_ids isEqualToString:@"(null)"]) {
             [SYObject failedPrompt:@"请先选中要删除的商品"];
        }else if (_cart_ids.length==0) {
             [SYObject failedPrompt:@"请先选中要删除的商品"];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要删除该商品吗？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0){
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        //删除的是没登陆的
                        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                        request_18=[ASIFormDataRequest requestWithURL:url3];
                        [request_18 setPostValue:@"" forKey:@"user_id"];
                        [request_18 setPostValue:@"" forKey:@"token"];
                        [request_18 setPostValue:_cart_meideng forKey:@"cart_ids"];
                        
                        NSArray *arrObjc3;
                        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                        }else{
                            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                        }
                        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                        [request_18 setRequestHeaders:dicMy3];
                        request_18.tag = 103;
                        request_18.delegate =self;
                        [request_18 setDidFailSelector:@selector(urlRequestFailed:)];
                        [request_18 setDidFinishSelector:@selector(my14_urlRequestSucceeded:)];
                        [request_18 startAsynchronous];
                    }else{
                        //删除的是已登陆的
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                        request_19=[ASIFormDataRequest requestWithURL:url3];
                        [request_19 setPostValue:@"" forKey:@"cart_mobile_ids"];
                        [request_19 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_19 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                        [request_19 setPostValue:_cart_ids forKey:@"cart_ids"];
                        NSArray *arrObjc3;
                        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                            arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                        }else{
                            arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                        }
                        NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                        NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                        [request_19 setRequestHeaders:dicMy3];
                        request_19.tag = 103;
                        request_19.delegate =self;
                        [request_19 setDidFailSelector:@selector(urlRequestFailed:)];
                        [request_19 setDidFinishSelector:@selector(my15_urlRequestSucceeded:)];
                        [request_19 startAsynchronous];
                    }
                }
            }];
        }
    }
}
#pragma mark -是否显示登录按钮页面
-(void)buttonLog{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        logView.hidden = NO;
        MyTableView.frame = CGRectMake(0, 44, ScreenFrame.size.width, ScreenFrame.size.height-44-64-56);
        labelWu.frame = CGRectMake(0, ScreenFrame.origin.y+49, ScreenFrame.size.width, ScreenFrame.size.height);
    }else{
        logView.hidden = YES;
        labelWu.frame = CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height);
        MyTableView.frame = CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-56);
    }
}


#pragma mark-数量的请求
-(void)my17_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            if ([[dicBig allKeys] containsObject:@"max_inventory"]){
                if ([[dicBig objectForKey:@"max_inventory"] intValue]>=[textFF.text intValue]){
                    NSLog(@"dicBig15:%@",dicBig);
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        
                    }else{
                        NSArray *arr = [_cart_ids componentsSeparatedByString:@","];
                        if (arr.count == 0) {
                            
                        }else{
                            BOOL arrBool = YES;
                            NSMutableArray *arr2 = (NSMutableArray*)arr;
                            for (int i=0; i<arr2.count; i++){
                                if ([cartidcan isEqualToString:[arr2 objectAtIndex:i]]) {
                                    arrBool = NO;
                                }
                            }
                            if (arrBool == YES) {
                                
                            }else{
                                
                            }
                        }
                        
                    }
                    [self carShoppingRefresh];
                }else{
                     [SYObject failedPrompt:@"库存不足"];
                   
                }
            }else{
                [self carShoppingRefresh];
            }
        }
        MyTableView.userInteractionEnabled = YES;
        [MyTableView reloadData];
        [self tableviewRefrsh];
    }else{
        [SYObject endLoading];
    }
    
}
#pragma mark -计算购物车的总价钱
-(void)tableviewRefrsh{
    [self buttonLog];
    [SYObject startLoading];
    MyTableView.userInteractionEnabled = NO;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CART_PRICE_URL]];
    request_5=[ASIFormDataRequest requestWithURL:url];
    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
        [request_5 setPostValue:_cart_meideng forKey:@"cart_ids"];
    }else{
        [request_5 setPostValue:_cart_ids forKey:@"cart_ids"];
    }
    NSArray *arrObjc33;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc33 = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc33 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey33 = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy33 = [[NSMutableDictionary alloc]initWithObjects:arrObjc33 forKeys:arrKey33];
    [request_5 setRequestHeaders:dicMy33];
    request_5.tag = 101;
    request_5.delegate = self;
    
    [request_5 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_5 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_5 startAsynchronous];
    
}
-(void)my1_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig1:%@",dicBig);
        //得到价钱刷新底部的金额 ；在没登陆的状台 变化为登陆的状态需要对cartid进行清空并且对页面进行刷新
        _zongji.text = [NSString stringWithFormat:@"%0.2f",[[dicBig objectForKey:@"select_cart_price"] floatValue]];
        _jiesuan.text=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"select_cart_number"]];
        if (buttonDelete.selected) {
            if ([_jiesuan.text intValue]>0) {
                [btnQ2 setBackgroundColor:UIColorFromRGB(0Xdf0000)];
            }else{
                [btnQ2 setBackgroundColor:[UIColor darkGrayColor]];
            }
        }else{
            [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
            if ([_jiesuan.text intValue]>0) {
//                [btnQ2 setBackgroundColor:MY_COLOR];
                [btnQ2 setBackgroundColor:UIColorFromRGB(0Xdf0000)];
            }else{
                [btnQ2 setBackgroundColor:[UIColor darkGrayColor]];
            }
        }
        [self carShoppingRefresh];
    }
    else{
    }
    MyTableView.userInteractionEnabled = YES;
    [SYObject endLoading];
    
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0){
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                //删除的是没登陆的
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                request_18=[ASIFormDataRequest requestWithURL:url3];
                [request_18 setPostValue:@"" forKey:@"user_id"];
                [request_18 setPostValue:@"" forKey:@"token"];
                [request_18 setPostValue:_cart_meideng forKey:@"cart_ids"];
                
                NSArray *arrObjc3;
                if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                    arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                }else{
                    arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                }
                NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                [request_18 setRequestHeaders:dicMy3];
                request_18.tag = 103;
                request_18.delegate =self;
                [request_18 setDidFailSelector:@selector(urlRequestFailed:)];
                [request_18 setDidFinishSelector:@selector(my14_urlRequestSucceeded:)];
                [request_18 startAsynchronous];
            }else{
                //删除的是已登陆的
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DELETECAR_URL]];
                request_19=[ASIFormDataRequest requestWithURL:url3];
                [request_19 setPostValue:@"" forKey:@"cart_mobile_ids"];
                [request_19 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request_19 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request_19 setPostValue:_cart_ids forKey:@"cart_ids"];
                NSArray *arrObjc3;
                if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                    arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
                }else{
                    arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
                }
                NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
                NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
                [request_19 setRequestHeaders:dicMy3];
                request_19.tag = 103;
                request_19.delegate =self;
                [request_19 setDidFailSelector:@selector(urlRequestFailed:)];
                [request_19 setDidFinishSelector:@selector(my15_urlRequestSucceeded:)];
                [request_19 startAsynchronous];
            }
        }
    }
    if (alertView.tag == 102) {
        if (buttonIndex == 0){
        }
    }
}
#pragma mark —提示删除
-(void)my14_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig12:%@",dicBig);
        _cart_meideng = @"";
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            NSArray *arr = [[dicBig objectForKey:@"dele_cart_mobile_ids"] componentsSeparatedByString:@","];
            NSLog(@"QQQ:%@",arr);
            if (arr.count == 1) {
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *array = [NSArray arrayWithObjects:@"", nil];
                [array writeToFile:readPath2 atomically:NO];
            }else if(arr.count == 0){
                
            }else if(arr.count == 2){
                if ([[arr objectAtIndex:0] length]==0||[[arr objectAtIndex:1] length] == 0) {
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSArray *array = [NSArray arrayWithObjects:@"", nil];
                    [array writeToFile:readPath2 atomically:NO];
                }
            }else{
                NSString *str = [arr objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSArray *arr2 = [[fileContent2 objectAtIndex:0] componentsSeparatedByString:@","];
                NSMutableArray *arrMut = (NSMutableArray *)arr2;
                NSString *newStr;
                if (arr2.count == 1) {
                    [arrMut removeAllObjects];
                }else{
                    for(int i=0;i<arr2.count;i++){
                        if ([str isEqualToString:[arr2 objectAtIndex:i]]) {
                            [arrMut removeObjectAtIndex:i];
                        }
                    }
                }
                
                for(int i=0;i<arrMut.count;i++){
                    if (newStr.length ==0) {
                        newStr = [NSString stringWithFormat:@"%@",[arrMut objectAtIndex:i]];
                    }else{
                        newStr = [NSString stringWithFormat:@"%@,%@",newStr,[arrMut objectAtIndex:i]];
                    }
                }
                NSArray *array = [NSArray arrayWithObjects:newStr, nil];
                [array writeToFile:readPath2 atomically:NO];
            }
        }else{
            //删除掉那个id
            _cart_ids = @"";
            btnQ2.backgroundColor = [UIColor grayColor];
        }
        [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
        _zongji.text = @"0.00";
        _jiesuan.text = @"0";
        [btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",_jiesuan.text] forState:UIControlStateNormal];
        [self carShoppingRefresh];
    }else{
        [SYObject endLoading];
    }
    
}

-(void)my15_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig13:%@",dicBig);
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            _cart_meideng = @"";
            NSArray *arr = [[dicBig objectForKey:@"dele_cart_mobile_ids"] componentsSeparatedByString:@","];
            NSString *str = [arr objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSArray *arr2 = [[fileContent2 objectAtIndex:0] componentsSeparatedByString:@","];
            NSMutableArray *arrMut = (NSMutableArray *)arr2;
            NSString *newStr;
            for(int i=0;i<arr2.count;i++){
                if ([str isEqualToString:[arr2 objectAtIndex:i]]) {
                    [arrMut removeObjectAtIndex:i];
                }
            }
            for(int i=0;i<arrMut.count;i++){
                if (newStr.length ==0) {
                    newStr = [NSString stringWithFormat:@"%@",[arrMut objectAtIndex:i]];
                }else{
                    newStr = [NSString stringWithFormat:@"%@,%@",newStr,[arrMut objectAtIndex:i]];
                }
            }
            NSArray *array = [NSArray arrayWithObjects:newStr, nil];
            [array writeToFile:readPath2 atomically:NO];
        }else{
            //删除掉那个id
            _cart_ids = @"";
            btnQ2.backgroundColor = [UIColor grayColor];
            //   btnQ2.enabled = NO;
        }
        [self carShoppingRefresh];
        [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
        btnQ.selected=NO;
    }else{
        [SYObject endLoading];
    }
    
}
#pragma mark -UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==specTableView) {
        return 0.01;
    }
    if(tableView == MyTableView){
        if (section == 0) {
            return 0.01;
        }else if([[arr_discount_list objectAtIndex:section] rangeOfString:@"combine_"].location !=NSNotFound){
            return 0.01;
        }else{
            if([[arr_discount_list objectAtIndex:section] rangeOfString:@"gift_"].location !=NSNotFound){
                return 40;
            }else{
                return 0.001;
            }
 
        }
        
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView == MyTableView){
        if (dataArray.count!=0) {
            if([[arr_discount_list objectAtIndex:section] rangeOfString:@"combine_"].location !=NSNotFound){
                return nil;
            }
            if (section == 0) {
                return nil;
            }else{
                NSDictionary *dic = [dataArray objectAtIndex:section];
                UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                topView.backgroundColor = [UIColor whiteColor];
                UILabel *labelActivity = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, ScreenFrame.size.width-80, 18)];
                labelActivity.font = [UIFont systemFontOfSize:12];
                labelActivity.text = [NSString stringWithFormat:@"满减:￥%@",[dic objectForKey:@"reduce"] ];
                [topView addSubview:labelActivity];
                UILabel *labelDes = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, ScreenFrame.size.width-80, 18)];
                labelDes.font = [UIFont systemFontOfSize:12];
                labelDes.textColor = [UIColor redColor];
                [topView addSubview:labelDes];
                
                labelDes.text = [NSString stringWithFormat:@"小计:￥%@", [dic objectForKey:@"cart_price"]];
                
                if([[arr_discount_list objectAtIndex:section] rangeOfString:@"gift_"].location !=NSNotFound){
                    labelActivity.hidden = YES;
                    labelDes.frame = CGRectMake(40, 0, ScreenFrame.size.width-80, 40);
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = section+100;
                    btn.frame = CGRectMake(ScreenFrame.size.width-75, 5, 60, 30);
                    btn.backgroundColor = [UIColor orangeColor];
                    [btn setTitle:@"选择赠品" forState:UIControlStateNormal];
                    CALayer *layTextField  = btn.layer;
                    [layTextField setMasksToBounds:YES];
                    [layTextField setCornerRadius:4.0];
                    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                    [btn addTarget:self action:@selector(ManSongClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [topView addSubview:btn];
                    //判断whether_enough=0；则不显示button。
                    NSInteger whether_enough = [[dic objectForKey:@"whether_enough"] integerValue];
                    if (whether_enough == 0) {
                        btn.hidden = YES;
                    }else{
                        if (whether_enough==1) {
                            [btn setTitle:@"选择赠品" forState:UIControlStateNormal];
                        }else if (whether_enough==2){
                            [btn setTitle:@"重选赠品" forState:UIControlStateNormal];
                        }
                        btn.hidden = NO;
                    }
                }else{
                    labelActivity.hidden = NO;
                    labelDes.frame = CGRectMake(40, 2, ScreenFrame.size.width-80, 18);
                }
                
                return topView;
            }
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==specTableView) {
        return 20;
    }else{
        if (section == 0) {
            return 0;
        }else{
            return 40;
        }
        return 0;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView == MyTableView){
        if (dataArray.count!=0) {
            if (section == 0) {
                return nil;
            }else{
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 40)];
                bgView.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
                
                NSDictionary *dic = [dataArray objectAtIndex:section];
                //                UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                //                topView.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
                UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0,10, ScreenFrame.size.width, 30)];
                topView.backgroundColor = [UIColor whiteColor];
                UILabel *labelActivity = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 50, 16)];
                labelActivity.textAlignment = NSTextAlignmentCenter;
                labelActivity.backgroundColor = MY_COLOR;
                labelActivity.font = [UIFont boldSystemFontOfSize:11];
                labelActivity.textColor = [UIColor whiteColor];
                labelActivity.layer.cornerRadius=4;
                labelActivity.layer.masksToBounds=YES;
                [topView addSubview:labelActivity];
                UILabel *labelDes = [[UILabel alloc]initWithFrame:CGRectMake(93,10, ScreenFrame.size.width-93,16)];
                labelDes.numberOfLines = 2;
                labelDes.font = [UIFont boldSystemFontOfSize:10];
                labelDes.textColor = [UIColor darkGrayColor];
                [topView addSubview:labelDes];
                
                labelDes.text = [dic objectForKey:@"info"];
                NSLog(@"labelDes.text:%@",labelDes.text);
                
                if([[arr_discount_list objectAtIndex:section] rangeOfString:@"gift_"].location !=NSNotFound)//_roaldSearchText
                {
                    labelActivity.text = @"满就送";
                    
                } else {
                    NSRange rangeJian = [[arr_discount_list objectAtIndex:section] rangeOfString:@"reduce_"];
                    if (rangeJian.length >0){//包含reduce_
                        labelActivity.text = @"满就减";
                    }else{
                        NSRange rangeZu = [[arr_discount_list objectAtIndex:section] rangeOfString:@"combine_combin"];
                        if (rangeZu.length >0){//包含combinecombin
                            labelActivity.text = @"组合销售";
                        }else{
                            labelActivity.text = @"";
                        }
                    }
                }
                //                return topView;
                [bgView addSubview:topView];
                return bgView;
            }
        }
    }else if (tableView==specTableView){
        UIView *view=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 30) backgroundColor:[UIColor clearColor]];
        UILabel *l=[LJControl labelFrame:CGRectMake(0,0, ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0xececec) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:l];
        NSDictionary *dic=[specArray objectAtIndex:section];
        UILabel *label=[LJControl labelFrame:CGRectMake(10,2,ScreenFrame.size.width-10,28) setText:[dic objectForKey:@"spec_key"] setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
        return view;
    }
    
    return nil;
}
-(void)sectionSelectionView:(CHSectionSelectionView *)sectionSelectionView didSelectSection:(NSInteger)section
{
    [MyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == mansongTableview) {
        return 1;
    }
    if (tableView == combinTableview) {
        return combinDataArray.count;
    }
    if (tableView == MyTableView) {
        return dataArray.count;
    }
    if (tableView==specTableView) {
        return specArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == mansongTableview) {
        return 1;
    }
    if (tableView == combinTableview) {
        if (combinDataArray.count!=0) {
            return combinDataArray.count;
        }
        return 0;
    }
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            NSDictionary *dic = [dataArray objectAtIndex:section];
            NSArray *arr;
            if (section == 0) {
                arr = (NSArray *)dic;
            }else{
                arr = [dic objectForKey:@"goods_list"];
            }
            if([[arr_discount_list objectAtIndex:section] rangeOfString:@"gift_"].location !=NSNotFound){
                if ([[dic objectForKey:@"whether_enough"]integerValue]==2) {
                    return arr.count+1;
                }
            }
            if([[arr_discount_list objectAtIndex:section] rangeOfString:@"combine_"].location !=NSNotFound){
                int flayindex;
                for (int i=0; i<arr_discount_list.count; i++) {
                    NSString *str=[arr_discount_list objectAtIndex:i];
                    if ([str rangeOfString:@"combine_"].location !=NSNotFound) {
                        flayindex=i;
                        break;
                    }
                }
                NSMutableArray *mArray=[combinDataArray objectAtIndex:section-flayindex];
                return arr.count+mArray.count;
                
            }
            return arr.count;
        }
    }
    if (tableView==specTableView) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == mansongTableview) {
        return 200;
    }
    if (tableView == combinTableview) {
        if (combinDataArray.count!=0) {
            if (indexPath.row == 0) {
                return 80;
            }else{
                return 60;
            }
        }
        return 0;
    }
    if (tableView == MyTableView) {
        if (dataArray.count!=0){
            if (dataArray.count != 0) {
                NSDictionary *dic = [dataArray objectAtIndex:indexPath.section];
                NSArray *arr;
                if (indexPath.section == 0) {
                    arr = (NSArray *)dic;
                }else{
                    arr = [dic objectForKey:@"goods_list"];
                }
                if(arr.count!=0){
                    if (indexPath.row<arr.count) {
                        if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"combine_"].location !=NSNotFound){
                            //                            Cart2Cell
                            return 45;
                        }else{
                            //                            Cart1Cell
                            return 112;
                        }
                    }else{
                        if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"gift_"].location !=NSNotFound){
                            //                            Cart3Cell
                            return 80;
                        }else if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"combine_"].location !=NSNotFound){
                             //                            Cart3Cell
                            int flayindex;
                            for (int i=0; i<arr_discount_list.count; i++) {
                                NSString *str=[arr_discount_list objectAtIndex:i];
                                if ([str rangeOfString:@"combine_"].location !=NSNotFound) {
                                    flayindex=i;
                                    break;
                                }
                            }
                            NSMutableArray *mArray=[combinDataArray objectAtIndex:indexPath.section-flayindex];
                            if(indexPath.row==arr.count+mArray.count-1){
                                return 80+10;
                            }
                            return 80;
                        }
                    }
                }
            }
        }
        return 0;
    }
    if (tableView == specTableView) {
        NSDictionary *dict=[specArray objectAtIndex:indexPath.section];
        NSArray *array=[dict objectForKey:@"spec_values"];
        if([[dict objectForKey:@"spec_type"]isEqualToString:@"text"]||[[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是文字
            CGFloat lastW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat lasth = array.count>0?65:20;//用来控制button距离父视图的高
            for (int i=0; i<array.count; i++) {
                NSDictionary *diction=[array objectAtIndex:i];
                NSString *val=[diction objectForKey:@"val"];
                
                CGFloat WIDTH=ScreenFrame.size.width-20;
                CGRect rect=[val boundingRectWithSize:CGSizeMake(WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                CGFloat minLeng=WIDTH/4-5;
                CGFloat length =rect.size.width>minLeng?rect.size.width+20:minLeng;
                NSLog(@"%.2f",length);
                CGFloat x=10 + lastW;
                CGFloat w=length;
                CGFloat h=45;
                if(10 + lastW + length + 15 >=WIDTH){
                    lastW = 0; //换行时将w置为0
                     x=10+lastW;
                    lasth = lasth + h + 10;//距离父视图也变化
                }
                lastW = w + x;
            }
            return lasth;
        }else if ([[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是是图片
        }

    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == combinTableview) {
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        if (combinDataArray.count!=0){
            NSMutableArray *marry=[combinDataArray objectAtIndex:indexPath.section];
            ClassifyModel *cccc = [marry objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 79, 300, 0.5)];
                imageLine.backgroundColor = [UIColor grayColor];
                [cell addSubview:imageLine];
                
                UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 40, 40)];
                imagePhoto.backgroundColor = [UIColor whiteColor];
                [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FIRST_URL,cccc.goods_main_photo]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell addSubview:imagePhoto];
                
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 24, 240, 34)];
                name.font = [UIFont systemFontOfSize:12];
                name.numberOfLines = 2;
                name.text = cccc.goods_name;
                name.textColor = [UIColor darkGrayColor];
                [cell addSubview:name];
                UILabel *priceAndcount = [[UILabel alloc]initWithFrame:CGRectMake(60, 54, 240, 20)];
                priceAndcount.font = [UIFont systemFontOfSize:10];
                priceAndcount.text = [NSString stringWithFormat:@"单价:¥%@ 数量:1",cccc.goods_current_price];
                priceAndcount.textColor = MY_COLOR;
                [cell addSubview:priceAndcount];
                
                UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCancel.tag = 99;
                btnCancel.frame = CGRectMake(285, 0, 30, 30);
                [btnCancel setTitle:@"❌" forState:UIControlStateNormal];
                btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                [btnCancel addTarget:self action:@selector(combineDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCancel];
            }else{
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 59, 300, 0.5)];
                imageLine.backgroundColor = [UIColor grayColor];
                [cell addSubview:imageLine];
                
                UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
                imagePhoto.backgroundColor = [UIColor orangeColor];
                [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FIRST_URL,cccc.goods_main_photo]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell addSubview:imagePhoto];
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 240, 34)];
                name.font = [UIFont systemFontOfSize:12];
                name.text = cccc.goods_name;
                name.textColor = [UIColor darkGrayColor];
                name.numberOfLines = 2;
                [cell addSubview:name];
                UILabel *priceAndcount = [[UILabel alloc]initWithFrame:CGRectMake(60, 36, 240, 20)];
                priceAndcount.font = [UIFont systemFontOfSize:10];
                priceAndcount.text = [NSString stringWithFormat:@"单价:¥%@ 数量:1",cccc.goods_current_price];
                priceAndcount.textColor = MY_COLOR;
                [cell addSubview:priceAndcount];
            }
        }
        return cell;
    }
    if (tableView == mansongTableview) {
        static NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            for (UIView *subView in cell.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        if (dataArray.count!=0){
            NSDictionary *dic = [dataArray objectAtIndex:zhongmansongTag];
            NSArray *gifiArr = [dic objectForKey:@"gift_list"];
            NSLog(@"gifiArrgifiArr:%@",gifiArr);
            UILabel *PSelct = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 240, 20)];
            PSelct.font = [UIFont systemFontOfSize:14];
            PSelct.text = @"请选赠送商品，数量有限，赠完即止";
            PSelct.textColor = [UIColor darkGrayColor];
            [cell addSubview:PSelct];
            
            UIButton *btnC = [UIButton buttonWithType:UIButtonTypeCustom];
            btnC.tag = 100;
            btnC.frame = CGRectMake(ScreenFrame.size.width-28, 6, 23, 23);
            [btnC setImage:[UIImage imageNamed:@"closeNew"] forState:(UIControlStateNormal)];
            [btnC addTarget:self action:@selector(ManSongSubBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnC];
            
            UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSure.tag = 101;
            btnSure.frame = CGRectMake(ScreenFrame.size.width-65, 165, 60, 30);
            [btnSure setTitle:@"确定" forState:UIControlStateNormal];
            btnSure.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            btnSure.backgroundColor = UIColorFromRGB(0xf15353);
            [btnSure addTarget:self action:@selector(ManSongSubBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            CALayer *layTextField  = btnSure.layer;
            [layTextField setMasksToBounds:YES];
            [layTextField setCornerRadius:4.0];
            [cell addSubview:btnSure];
            
            UIScrollView *ScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 32, ScreenFrame.size.width, 130)];
            ScrollView2.bounces = YES;
            ScrollView2.delegate = self;
            ScrollView2.userInteractionEnabled = YES;
            ScrollView2.showsHorizontalScrollIndicator = NO;
            ScrollView2.contentSize=CGSizeMake(100*gifiArr.count,130);
            [cell addSubview:ScrollView2];
            
            for(int i=0;i<gifiArr.count;i++){
                NSDictionary *subDic = [gifiArr objectAtIndex:i];
                UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10+90*i, 24, 60, 60)];
                [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FIRST_URL,[subDic objectForKey:@"goods_main_photo"]]] placeholderImage:[UIImage imageNamed:@"kong"]];
                [ScrollView2 addSubview:imagePhoto];
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(5+90*i, 68+17, 80, 20)];
                name.font = [UIFont systemFontOfSize:8];
                name.text = [subDic objectForKey:@"goods_name"];
                name.numberOfLines = 2;
                name.textColor=UIColorFromRGB(0x666666);
                name.textAlignment = NSTextAlignmentCenter;
                [ScrollView2 addSubview:name];
                UILabel *Price = [[UILabel alloc]initWithFrame:CGRectMake(0+90*i, 68+17+20, 80, 11)];
                Price.font = [UIFont systemFontOfSize:9];
                Price.text = [NSString stringWithFormat:@"原价:￥%@",[subDic objectForKey:@"goods_price"]];
                Price.numberOfLines = 1;
                Price.textColor = [UIColor darkGrayColor];
                Price.textAlignment = NSTextAlignmentCenter;
                [ScrollView2 addSubview:Price];
                UILabel *nowPrice = [[UILabel alloc]initWithFrame:CGRectMake(0+90*i, 68+17+32, 80, 11)];
                nowPrice.font = [UIFont boldSystemFontOfSize:10];
                nowPrice.text = [NSString stringWithFormat:@"现价:￥0"];
                nowPrice.numberOfLines = 1;
                nowPrice.textColor = MY_COLOR;
                nowPrice.textAlignment = NSTextAlignmentCenter;
                [ScrollView2 addSubview:nowPrice];
                UIButton *allBtn=[[UIButton alloc]initWithFrame:CGRectMake(0+90*i, 24, 80, 128)];
                allBtn.backgroundColor=[UIColor clearColor];
                [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
                allBtn.tag=200+i;
                [ScrollView2 addSubview:allBtn];
                
                
                UIButton *btnX = [UIButton buttonWithType:UIButtonTypeCustom];
                btnX.tag = 200+i;
                btnX.frame = CGRectMake(32+90*i, 4, 18, 18);
                if (giftTag == btnX.tag) {
                    [btnX setImage:[UIImage imageNamed:@"check_yes1"] forState:(UIControlStateNormal)];
                }else{
                     [btnX setImage:[UIImage imageNamed:@"check_no1"] forState:(UIControlStateNormal)];
                }
                [btnX addTarget:self action:@selector(ManSongSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [ScrollView2 addSubview:btnX];
            }
        }
        return cell;
    }else if(tableView==MyTableView){
        if (dataArray.count != 0) {
            NSDictionary *dic = [dataArray objectAtIndex:indexPath.section];
            NSArray *arr;
            if (indexPath.section == 0) {
                arr = (NSArray *)dic;
            }else{
                arr = [dic objectForKey:@"goods_list"];
            }
            if(arr.count!=0){
                if (indexPath.row<arr.count) {
                    if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"combine_"].location !=NSNotFound){
                        Cart2Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart2Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                        if(cell == nil){
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart2Cell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        
                        if (buttonDelete.selected) {
                            cell.editView.hidden=NO;
                            cell.normalView.hidden=YES;
                        }else{
                            cell.editView.hidden=YES;
                            cell.normalView.hidden=NO;
                        }
                        cell.specificationssLabel0.text=[NSString stringWithFormat:@"套餐价：¥%.2f",[[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_price"] floatValue]];
                        
                        cell.selectedButton.tag=indexPath.section*1000+indexPath.row;
                        [cell.selectedButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.minusButton.tag=indexPath.section*1000+indexPath.row;
                        [cell.minusButton addTarget:self action:@selector(minusClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.plusButton.tag=indexPath.section*1000+indexPath.row;
                        [cell.plusButton addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.numericalTextField.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_count"]];
                        cell.numericalTextField.keyboardType=UIKeyboardTypeNumberPad;
                        cell.numericalTextField.tag=indexPath.section*1000+indexPath.row;
                        cell.numericalTextField.delegate=self;
                        //刷新选中
                        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString *documentsPath = [docPath objectAtIndex:0];
                        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_meideng componentsSeparatedByString:@","]];
                            NSDictionary *dicting=[arr objectAtIndex:indexPath.row];
                            NSString *string=[NSString stringWithFormat:@"%@",[dicting objectForKey:@"cart_id"]];
                            for (NSString *str in array) {
                                if ([str isEqualToString:string]) {
                                    [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                                    cell.selectedButton.selected=YES;
                                    break;
                                }
                            }
                        }else{
                            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_ids componentsSeparatedByString:@","]];
                            NSDictionary *dicting=[arr objectAtIndex:indexPath.row];
                            NSString *string=[NSString stringWithFormat:@"%@",[dicting objectForKey:@"cart_id"]];
                            for (NSString *str in array) {
                                if ([str isEqualToString:string]) {
                                    [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                                    cell.selectedButton.selected=YES;
                                    break;
                                }
                            }
                        }
                        return cell;
                    }else{
                        Cart1Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart1Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                        if(cell == nil){
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart1Cell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        if (buttonDelete.selected) {
                            cell.editView.hidden=NO;
                            cell.normalView.hidden=YES;
                        }else{
                            cell.editView.hidden=YES;
                            cell.normalView.hidden=NO;
                        }
                        
                        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_main_photo"]] placeholderImage:[UIImage imageNamed:@"kong"]];
                        NSString *namestring=[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
                        if (namestring.length>6) {
                            cell.nameLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
                        }else{
                            cell.nameLabel.text = [NSString stringWithFormat:@"%@\n",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"]];
                        }
                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f\n",[[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_price"] floatValue]];
                        cell.numberLabel.text = [NSString stringWithFormat:@"X%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_count"]];
                        NSString *specificationsStr=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                        if (specificationsStr.length<8) {
                            cell.specificationssLabel0.text =[NSString stringWithFormat:@"%@\n",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                            cell.specificationssLabel1.text = [NSString stringWithFormat:@"%@\n",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                        }else{
                            cell.specificationssLabel0.text =[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                            cell.specificationssLabel1.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                        }
                        cell.numericalTextField.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_count"]];
                        if ([self isNoGoodsMask:[[arr objectAtIndex:indexPath.row] objectForKey:@"cart_id"]]) {
                            cell.markImageView.hidden=NO;
                            cell.markbgImageView.hidden=NO;
                            cell.downImage.hidden=YES;
                            cell.numericalTextField.userInteractionEnabled=NO;
                            
                        }else{
                            cell.markImageView.hidden=YES;
                            cell.markbgImageView.hidden=YES;
                            cell.numericalTextField.keyboardType=UIKeyboardTypeNumberPad;
                            cell.numericalTextField.tag=indexPath.section*1000+indexPath.row;
                            cell.numericalTextField.delegate=self;
                            
                            cell.selectedButton.tag=indexPath.section*1000+indexPath.row;
                            [cell.selectedButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.minusButton.tag=indexPath.section*1000+indexPath.row;
                            [cell.minusButton addTarget:self action:@selector(minusClick:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.plusButton.tag=indexPath.section*1000+indexPath.row;
                            [cell.plusButton addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
                            NSString *str=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_spec"]];
                            if(str.length>0){
                                cell.dropDownButton.tag=indexPath.section*1000+indexPath.row;
                                [cell.dropDownButton addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
                                cell.downImage.hidden=NO;
                            }else{
                                cell.downImage.hidden=YES;
                            }
                            
                        }
                        
                        //刷新选中
                        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString *documentsPath = [docPath objectAtIndex:0];
                        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_meideng componentsSeparatedByString:@","]];
                            NSDictionary *dicting=[arr objectAtIndex:indexPath.row];
                            NSString *string=[NSString stringWithFormat:@"%@",[dicting objectForKey:@"cart_id"]];
                            for (NSString *str in array) {
                                if ([str isEqualToString:string]) {
                                    [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                                    cell.selectedButton.selected=YES;
                                    break;
                                }
                            }
                        }else{
                            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_ids componentsSeparatedByString:@","]];
                            NSDictionary *dicting=[arr objectAtIndex:indexPath.row];
                            NSString *string=[NSString stringWithFormat:@"%@",[dicting objectForKey:@"cart_id"]];
                            for (NSString *str in array) {
                                if ([str isEqualToString:string]) {
                                    [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                                    cell.selectedButton.selected=YES;
                                    break;
                                }
                            }
                        }
                        if ((indexPath.section==0)&&(indexPath.row==arr.count-1)) {
                            cell.lineLabel.hidden=YES;
                        }
                        return cell;
                    }
                }else{
                    if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"gift_"].location !=NSNotFound){
                        Cart3Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart3Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                        if(cell == nil){
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart3Cell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        if ([[dic objectForKey:@"whether_enough"]integerValue]==2) {
                            NSDictionary *dict=[dic objectForKey:@"gift"];
                            [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"goods_main_photo"]] placeholderImage:[UIImage imageNamed:@"kong"]];
                            cell.nameLabel.text = [dict objectForKey:@"goods_name"];
                            cell.selectedButton.hidden=YES;
                            
                        }
                        return cell;
                    }else if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"combine_"].location !=NSNotFound){
                        int flayindex;
                        for (int i=0; i<arr_discount_list.count; i++) {
                            NSString *str=[arr_discount_list objectAtIndex:i];
                            if ([str rangeOfString:@"combine_"].location !=NSNotFound) {
                                flayindex=i;
                                break;
                            }
                        }
                        NSMutableArray *mArray=[combinDataArray objectAtIndex:indexPath.section-flayindex];
                        ClassifyModel *claModel = [mArray objectAtIndex:indexPath.row-arr.count];
                        Cart3Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart3Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                        if(cell == nil){
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart3Cell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:claModel.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong"]];
                        cell.nameLabel.text = claModel.goods_name;
                        cell.selectedButton.hidden=YES;
                        cell.specificationssLabel0.hidden=YES;
                        return cell;
                    }
                }
            }
        }
        return nil;
    }else if(tableView==specTableView){
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
        }else{
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        NSArray *spdIds=[[NSMutableArray alloc]initWithArray:[specIdsString componentsSeparatedByString:@","]];
        NSDictionary *dict=[specArray objectAtIndex:indexPath.section];
        NSArray *array=[dict objectForKey:@"spec_values"];
        if([[dict objectForKey:@"spec_type"]isEqualToString:@"text"]||[[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是文字
            CGFloat lastW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat lasth = 10;//用来控制button距离父视图的高
            for (int i=0; i<array.count; i++) {
                NSDictionary *diction=[array objectAtIndex:i];
                NSString *val=[diction objectForKey:@"val"];
                
                CGFloat WIDTH=ScreenFrame.size.width-20;
                CGRect rect=[val boundingRectWithSize:CGSizeMake(WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                CGFloat minLeng=WIDTH/4-5;
                CGFloat length =rect.size.width>minLeng?rect.size.width+20:minLeng;
                length=length>WIDTH?WIDTH:length;
                NSLog(@"%.2f",length);
                
                CGFloat x=10 + lastW;
                CGFloat y=lasth;
                CGFloat w=length;
                CGFloat h=45;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, y, w, h);
                button.tag=indexPath.section *1000+i;
                button.backgroundColor = [UIColor clearColor];//[UIColor clearColor]
                [button addTarget:self action:@selector(spcClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *label=[LJControl labelFrame:CGRectMake(0, 5, w, 35) setText:val setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0X686868) textAlignment:NSTextAlignmentCenter];
                label.numberOfLines=2;
                label.tag=indexPath.section *1000+i;
                [label.layer  setCornerRadius:6.0];
                [label.layer setMasksToBounds:YES];
                label.layer.borderColor = [UIColorFromRGB(0Xdfdfdf) CGColor];
                label.layer.borderWidth =0.5;
                
                [button addSubview:label];
                
                if(10 + lastW + length + 15 >WIDTH){
                    lastW = 0; //换行时将w置为0
                    x=10+lastW;
                    lasth = lasth + h + 10;//距离父视图也变化
                    button.frame = CGRectMake(x, lasth,w, h);//重设button的frame
                }
                
                lastW = w + x;
                [cell.contentView addSubview:button];
                if(specIdsArray.count>0){
                    if ([[specIdsArray objectAtIndex:indexPath.section]intValue]==[[diction objectForKey:@"id"]intValue]) {
                        button.selected=YES;
                        label.textColor=[UIColor whiteColor];
                        label.backgroundColor=UIColorFromRGB(0Xef0000);
                        label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                    }else if([[specIdsArray objectAtIndex:indexPath.section]isEqualToString:@""]){
                        for (NSString *ids in spdIds) {
                            if ([ids intValue]==[[diction objectForKey:@"id"]intValue]) {
                                button.selected=YES;
                                label.textColor=[UIColor whiteColor];
                                label.backgroundColor=UIColorFromRGB(0Xef0000);
                                label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                            }
                        }
                    }
                }else{
                    for (NSString *ids in spdIds) {
                        if ([ids intValue]==[[diction objectForKey:@"id"]intValue]) {
                            button.selected=YES;
                            label.textColor=[UIColor whiteColor];
                            label.backgroundColor=UIColorFromRGB(0Xef0000);
                            label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                        }
                    }
                }
            }
            return cell;
            
        }else if ([[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是是图片
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (buttonDelete.selected==NO) {
            if (dataArray.count!=0) {
                NSDictionary *dic = [dataArray objectAtIndex:indexPath.section];
                NSArray *arr;
                if (indexPath.section == 0) {
                    arr = (NSArray *)dic;
                }else{
                    arr = [dic objectForKey:@"goods_list"];
                }
                
                if (indexPath.row<arr.count) {
                    NSDictionary *dict=[arr objectAtIndex:indexPath.row];
                    SecondViewController *sec = [SecondViewController sharedUserDefault];
                    sec.detail_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goods_id"]];
                    DetailViewController *detail = [[DetailViewController alloc]init];
                    detail.cartDictionary=dict;
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"gift_"].location !=NSNotFound){
                        if ([[dic objectForKey:@"whether_enough"]integerValue]==2) {
                            NSDictionary *dict=[dic objectForKey:@"gift"];
                            SecondViewController *sec = [SecondViewController sharedUserDefault];
                            sec.detail_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goods_id"]];
                            DetailViewController *detail = [[DetailViewController alloc]init];
                            [self.navigationController pushViewController:detail animated:YES];
                            
                        }
                    }else if([[arr_discount_list objectAtIndex:indexPath.section] rangeOfString:@"combine_"].location !=NSNotFound){
//                        ClassifyModel *claModel = [combinDataArray objectAtIndex:indexPath.row-arr.count];
//                        SecondViewController *sec = [SecondViewController sharedUserDefault];
//                        sec.detail_id = [NSString stringWithFormat:@"%@",claModel.goods_id];
//                        DetailViewController *detail = [[DetailViewController alloc]init];
//                        [self.navigationController pushViewController:detail animated:YES];
                    }
                    
                }
                
            }
            
        }
    }
    if (tableView == combinTableview) {
        if (combinDataArray.count!=0) {
            ClassifyModel *cla = [combinDataArray objectAtIndex:indexPath.row];
            SecondViewController *sec = [SecondViewController sharedUserDefault];
            sec.detail_id = cla.goods_id;
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
#pragma mark -判断是否无货
-(BOOL)isNoGoodsMask:(NSString *)cartID{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSArray *NoGoodsCartIds=[standard objectForKey:@"ErrorGoodsData"];
    for (NSString *str in NoGoodsCartIds) {
        if ([str integerValue]==[cartID integerValue]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)isNoGoodsMaskCarts:(NSString *)cartID{
    NSArray *cartIds=[cartID componentsSeparatedByString:@","];
    for (NSString *str in cartIds) {
        if ([self isNoGoodsMask:str]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -规格选择
-(void)spcClick:(UIButton *)btn{
    NSDictionary *dict=[specArray objectAtIndex:btn.tag/1000];
    NSArray *array=[dict objectForKey:@"spec_values"];
    NSDictionary *dic=[array objectAtIndex:btn.tag%1000];
    //存在选择规格的ID
    specIdsArray=[[NSMutableArray alloc]init];
    for (NSDictionary *d in specArray) {
        NSLog(@"%@",d);
        [specIdsArray addObject:@""];
    }
    NSArray *spdIds=[[NSMutableArray alloc]initWithArray:[specIdsString componentsSeparatedByString:@","]];
    for (int i=0; i<specArray.count; i++) {
        NSDictionary *diction=[specArray objectAtIndex:i];
        NSArray *spArray=[diction objectForKey:@"spec_values"];
        for (int j=0;j<spArray.count;j++) {
            NSDictionary *ddict=[spArray objectAtIndex:j];
            for (NSString *specIdsStr in spdIds) {
                if ([specIdsStr intValue]==[[ddict objectForKey:@"id"]intValue]) {
                    [specIdsArray replaceObjectAtIndex:i withObject:specIdsStr];
                }
            }
        }
    }
    [specIdsArray replaceObjectAtIndex:btn.tag/1000 withObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    [specIdsString setString:[specIdsArray componentsJoinedByString:@","]];
    
    NSArray *varArray=[self getSelectSPecVal:specIdsArray];
    UILabel *choicelabel=(UILabel *)[specifView viewWithTag:1003];
    choicelabel.text=[NSString stringWithFormat:@"已选:%@",[varArray componentsJoinedByString:@","]];
   
    [specTableView reloadData];
    
}
-(void)getCountAndPrice:(NSMutableArray *)array{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    if (array.count!=0) {
        
        [request setPostValue:[array componentsJoinedByString:@","] forKey:@"gsp"];
    }
    
    [request setPostValue:goodsId forKey:@"id"];
    
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag = 114;
    request.delegate =self;
    [request setDidFailSelector:@selector(requestUrlRequestFailed:)];
    [request setDidFinishSelector:@selector(requestUrlRequestSucceeded:)];
    [request startAsynchronous];
    
    
    
}
-(void)requestUrlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"14-dicBig:%@",dicBig);
        UILabel *stocklabel=(UILabel *)[specifView viewWithTag:1002];
        stocklabel.text=[NSString stringWithFormat:@"库存：%@件",[dicBig objectForKey:@"count"]];
        UILabel *pricelabel=(UILabel *)[specifView viewWithTag:1001];
        pricelabel.text=[NSString stringWithFormat:@"￥:%0.2f",[[dicBig objectForKey:@"price"]floatValue]];
        
        
    }
    
}
-(void)requestUrlRequestFailed:(ASIFormDataRequest *)request{
    
    
}
-(NSArray *)getSelectSPecVal:(NSArray *)specIdArray{
    
    NSMutableArray *valIds=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in specArray) {
        NSArray *array=[dict objectForKey:@"spec_values"];
        for (NSDictionary *dic in array ) {
            [valIds addObject:dic];
        }
    }
    NSMutableArray *varAray=[[NSMutableArray alloc]init];
    for (NSString *str in specIdArray) {
        for (NSDictionary *div in valIds) {
            NSString *s=[div objectForKey:@"id"];
            if ([str integerValue]==[s integerValue]) {
                [varAray addObject:[NSString stringWithFormat:@"\"%@\"",[div objectForKey:@"val"]]];
            }
        }
    }
    return varAray;
}
#pragma mark -选中
-(void)selectedClick:(UIButton *)btn{
    NSDictionary *dic = [dataArray objectAtIndex:btn.tag/1000];
    NSArray *arr;
    if (btn.tag/1000 == 0) {
        arr = (NSArray *)dic;
    }else{
        arr = [dic objectForKey:@"goods_list"];
    }
    NSDictionary *dict=[arr objectAtIndex:btn.tag%1000];
    btn.selected=!btn.selected;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        if (btn.selected) {
            if ([_cart_meideng isEqualToString:@"(null)"]|| _cart_meideng==nil||[_cart_meideng isEqualToString:@""]) {
                _cart_meideng = [NSString stringWithFormat: @"%@",[dict objectForKey:@"cart_id"]];
            }else{
                NSRange range=[_cart_meideng rangeOfString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"cart_id"]]];
                if (range.location<_cart_meideng.length){
                    
                }else{
                    _cart_meideng = [NSString stringWithFormat: @"%@,%@",_cart_meideng,[dict objectForKey:@"cart_id"]];
                }
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
            NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[_cart_meideng componentsSeparatedByString:@","]];
            NSMutableArray *array2 = [[NSMutableArray alloc]initWithArray:[[self getAllCartIds] componentsSeparatedByString:@","]];
            if (array1.count==array2.count) {
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                btnQ.selected=YES;
            }
        }else{
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_meideng componentsSeparatedByString:@","]];
            [array removeObject:[NSString stringWithFormat: @"%@",[dict objectForKey:@"cart_id"]]];
            _cart_meideng= [NSString stringWithFormat: @"%@",[array componentsJoinedByString:@","]];
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
            [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
            btnQ.selected=NO;
        }
        NSLog(@"%@",_cart_meideng);
    }else{
        if (btn.selected) {
            if ([_cart_ids isEqualToString:@"(null)"]|| _cart_ids==nil||[_cart_ids isEqualToString:@""]) {
                _cart_ids = [NSString stringWithFormat: @"%@",[dict objectForKey:@"cart_id"]];
            }else{
                NSRange range=[_cart_ids rangeOfString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"cart_id"]]];
                if (range.location<_cart_ids.length){
                    
                }else{
                    _cart_ids = [NSString stringWithFormat: @"%@,%@",_cart_ids,[dict objectForKey:@"cart_id"]];
                }
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
            NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[_cart_ids componentsSeparatedByString:@","]];
            NSMutableArray *array2 = [[NSMutableArray alloc]initWithArray:[[self getAllCartIds] componentsSeparatedByString:@","]];
            if (array1.count==array2.count) {
                [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                btnQ.selected=YES;
            }
        }else{
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_cart_ids componentsSeparatedByString:@","]];
            [array removeObject:[NSString stringWithFormat: @"%@",[dict objectForKey:@"cart_id"]]];
            _cart_ids= [NSString stringWithFormat: @"%@",[array componentsJoinedByString:@","]];
            [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
            [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
            btnQ.selected=NO;
        }
        NSLog(@"%@",_cart_ids);
    }
    [self tableviewRefrsh];
}
#pragma mark -减
-(void)minusClick:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag%1000 inSection:btn.tag/1000];
    Cart1Cell *cell = [MyTableView cellForRowAtIndexPath:indexPath];
    if ([cell.numericalTextField.text intValue]-1>0) {
        [self getQuantityRequest:indexPath andNumerical:[NSString stringWithFormat:@"%d",[cell.numericalTextField.text intValue]-1]];
    }else{
        [SYObject failedPrompt:@"商品数量必须大于零"];
    }
}
#pragma mark -加
-(void)plusClick:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag%1000 inSection:btn.tag/1000];
    Cart1Cell *cell = [MyTableView cellForRowAtIndexPath:indexPath];
    
    [self getQuantityRequest:indexPath andNumerical:[NSString stringWithFormat:@"%d",[cell.numericalTextField.text intValue]+1]];
}
-(void)getQuantityRequest:(NSIndexPath *)indexPath andNumerical:(NSString *)numerical{
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.section];
    NSArray *arr;
    if (indexPath.section == 0) {
        arr = (NSArray *)dic;
    }else{
        arr = [dic objectForKey:@"goods_list"];
    }
    NSDictionary *dict=[arr objectAtIndex:indexPath.row];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCARCOUNT_URL]];
    request_21=[ASIFormDataRequest requestWithURL:url3];
    [request_21 setPostValue:numerical forKey:@"count"];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
        [request_21 setPostValue:@"" forKey:@"user_id"];
        [request_21 setPostValue:@"" forKey:@"token"];
        [request_21 setPostValue:[dict objectForKey:@"cart_id"] forKey:@"cart_id"];
        [request_21 setPostValue:@"" forKey:@"cart_mobile_ids"];
    }else{
        [request_21 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_21 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_21 setPostValue:[dict objectForKey:@"cart_id"]forKey:@"cart_id"];
        [request_21 setPostValue:@"" forKey:@"cart_mobile_ids"];
    }
    NSArray *arrObjc3;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc3 = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc3 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey3 = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:arrObjc3 forKeys:arrKey3];
    [request_21 setRequestHeaders:dicMy3];
    request_21.delegate =self;
    [request_21 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_21 setDidFinishSelector:@selector(QuantityRequestSucceeded:)];
    [request_21 startAsynchronous];
}
-(void)QuantityRequestSucceeded:(ASIHTTPRequest *)request{
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if(dicBig){
        if ([[dicBig objectForKey:@"code"]intValue]==100) {
            [self carShoppingRefresh];
//            [self tableviewRefrsh];
        }else if ([[dicBig objectForKey:@"code"]intValue]==200){
            [SYObject failedPrompt:@"该商品库存不足"];
        }else if ([[dicBig objectForKey:@"code"]intValue]==300){
            [SYObject failedPrompt:@"优惠劵不足"];
        }else if ([[dicBig objectForKey:@"code"]intValue]==400){
            [SYObject failedPrompt:@"超出您限购数量无法修改"];
        }else{
            [SYObject failedPrompt:@"未能修改成功"];
        }
    }
}
#pragma mark -下拉
-(void)dropDownClick:(UIButton *)btn{
    //清空选择的规格ID的数组
    [specIdsArray removeAllObjects];
    
    NSDictionary *dic = [dataArray objectAtIndex:btn.tag/1000];
    NSArray *arr;
    if (btn.tag/1000 == 0) {
        arr = (NSArray *)dic;
    }else{
        arr = [dic objectForKey:@"goods_list"];
    }
    NSDictionary *dict=[arr objectAtIndex:btn.tag%1000];
    UIImageView *iamgeView=(UIImageView *)[specifView viewWithTag:1000];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"goods_main_photo"]] placeholderImage:[UIImage imageNamed:@"kong"]];
    UILabel *pricelabel=(UILabel *)[specifView viewWithTag:1001];
    pricelabel.text=[NSString stringWithFormat:@"￥:%0.2f",[[dict objectForKey:@"goods_price"] floatValue]];
    UILabel *choicelabel=(UILabel *)[specifView viewWithTag:1003];
    
    NSString *str=[NSString stringWithFormat:@"%@",[dict objectForKey:@"goods_spec"]];
    NSArray *array=[str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ："]];
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (int i=0; i<array.count; i++) {
        if (i%2==1) {
            NSString *string=[NSString stringWithFormat:@"\"%@\"",[array objectAtIndex:i]];
            [mArray addObject:string];
        }
    }
    choicelabel.text=[NSString stringWithFormat:@"已选:%@",[mArray componentsJoinedByString:@","]];
    [self getSpecificationInformation:(NSString *)[dict objectForKey:@"goods_id"] andSpecification:(NSString *)[dict objectForKey:@"goods_spec_ids"]];
    if (!specIdsString) {
        specIdsString=[[NSMutableString alloc]init];
        cartId=[[NSMutableString alloc]init];
    }
    if ([dict objectForKey:@"goods_spec_ids"]==nil) {
        
        [SYObject failedPrompt:@"该商品无规格可选"];
       
    }else{
        [specIdsString setString:(NSString *)[dict objectForKey:@"goods_spec_ids"]];
        [cartId setString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"cart_id"]]];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [OHAlertView showAlertWithTitle:@"温馨提示" message:@"您还未登录" cancelButton:nil otherButtons:@[@"去登录"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                    [self.navigationController pushViewController:new animated:YES];
                }else{
                }
            }];
        }else{
             goodsId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"goods_id"]];
            [self getSpecificationInformation:(NSString *)[dict objectForKey:@"goods_id"] ];
        }
    }
    
    
    
}
-(void)getSpecificationInformation:(NSString *)GoodsId andSpecification:(NSString*)SpecIds{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:GoodsId forKey:@"id"];
    [request setPostValue:SpecIds forKey:@"gsp"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1000;
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)getSpecificationInformation:(NSString *)GoodsId{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:GoodsId forKey:@"id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1001;
    [request setDelegate:self];
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    if (request.tag==1000) {
        UILabel *stocklabel=(UILabel *)[specifView viewWithTag:1002];
        stocklabel.text=[NSString stringWithFormat:@"库存:%@件",[dic objectForKey:@"count"]];
    }else  if (request.tag==1001) {
        NSArray *array=[dic objectForKey:@"spec_list"];
        if (!specArray) {
            specArray=[[NSMutableArray alloc]init];
        }else if (specArray.count>0){
            [specArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            [specArray addObject:dict];
        }
        NSInteger count;
        count=0;
        for (int i=0; i<specArray.count; i++) {
            NSDictionary *dict=[specArray objectAtIndex:i];
            NSArray *array=[dict objectForKey:@"spec_values"];
            if (array.count==0) {
                count +=count;
            }else{
                count +=array.count/4+1;
            }
        }
        
        if (100*count+100+60>420) {
            specifView.frame=CGRectMake(0,  ScreenFrame.size.height-400, ScreenFrame.size.width,400);
            specTableView.frame=CGRectMake(0,100,ScreenFrame.size.width,250);
            cardButton.frame=CGRectMake(0,specifView.bounds.size.height-40,ScreenFrame.size.width,40);
            
        }else{
            specifView.frame=CGRectMake(0, ScreenFrame.size.height-(100*count+100+60),  ScreenFrame.size.width,100*count+100+60);
            specTableView.frame=CGRectMake(0, 100,  ScreenFrame.size.width, count *100+10);
            cardButton.frame=CGRectMake(0,specifView.bounds.size.height-40,ScreenFrame.size.width,40);
        }
        [specTableView reloadData];
        semiTransparentView.hidden=NO;
        specifView.hidden=NO;
        self.tabBarController.tabBar.hidden = YES;
    }else  if (request.tag==1002) {
        if ([[dic objectForKey:@"code"]intValue]==100) {
            semiTransparentView.hidden=YES;
            specifView.hidden=YES;
//            self.tabBarController.tabBar.hidden = NO;
            [self carShoppingRefresh];
        }else{
            [SYObject failedPrompt:@"未保存成功"];
           
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    MyTableView.hidden = YES;
    networkView.hidden=NO;
    [self.view bringSubviewToFront:networkView];
    [SYObject failedPrompt:@"网络出现故障"];
    
}
-(void)mansongDeleteClicked:(UIButton *)btn{
    for(int i=0;i<mansongGiftStringArray.count;i++){
        if (btn.tag ==  100+i) {
            //此处应该 删掉mansong字符串数组里面的东西 刷新页面
            [mansongGiftStringArray replaceObjectAtIndex:i withObject:@""];
            mansongTag = -100;
            [self carShoppingRefresh];
            [MyTableView reloadData];
        }
    }
}
#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:textField.tag%1000 inSection:textField.tag/1000];
    NSDictionary *dic = [dataArray objectAtIndex:indexpath.section];
    NSArray *arr;
    if (indexpath.section == 0) {
        arr = (NSArray *)dic;
    }else{
        arr = [dic objectForKey:@"goods_list"];
    }
    if(indexpath.section==0 && indexpath.row==0){
    
    }else if ((indexpath.section==[MyTableView numberOfSections]-1)&&(indexpath.row== [MyTableView numberOfRowsInSection:[MyTableView numberOfSections]-1]-1)) {
        [MyTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=CGRectMake(0,-50, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
        
    }else{
        [MyTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        self.view.frame=CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:textField.tag%1000 inSection:textField.tag/1000];
    if ([textField.text intValue]<=0) {
       textField.text=@"1";
    [SYObject failedPrompt:@"商品数量必须大于零"];

    }else{
    }
    [self getQuantityRequest:indexpath andNumerical:[NSString stringWithFormat:@"%d",[textField.text intValue]]];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        self.view.frame=CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height);
        [textField resignFirstResponder];
    }];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
#pragma mark -选择赠品
-(void)ManSongClicked:(UIButton *)btn{
    //在这里应该是创建一个view 上面有赠品的view 得知道他选择的是哪个section
    giftTag = -1;
    
    zhongmansongTag = btn.tag-100;
    mansongView.hidden = NO;
    
    [self.view bringSubviewToFront:mansongView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, mansongView.frame.size.height)];
    imageView.backgroundColor = [UIColor colorWithRed:30/255.0f green:30/255.0f blue:30/255.0f alpha:0.7];
    imageView.userInteractionEnabled = YES;
    [mansongView addSubview:imageView];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:singleTapGestureRecognizer];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0,20, ScreenFrame.size.width, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [mansongView addSubview:whiteView];
    
    mansongTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 200) style:UITableViewStylePlain];
    mansongTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    mansongTableview.delegate = self;
    mansongTableview.dataSource=  self;
    mansongTableview.showsVerticalScrollIndicator=NO;
    mansongTableview.showsHorizontalScrollIndicator = NO;
    [whiteView addSubview:mansongTableview];}
-(void)ManSongSelectBtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        selectMansong=!selectMansong;
        if (selectMansong) {
            NSDictionary *dic = [dataArray objectAtIndex:zhongmansongTag];
            NSArray *gifiArr = [dic objectForKey:@"gift_list"];
            for(int i=0;i<gifiArr.count;i++){
                if (btn.tag == 200+i) {
                    giftTag = 200+i;
                    [mansongTableview reloadData];
                }
            }
        }else
        {
            giftTag=-1;
            [mansongTableview reloadData];
        }
    }
}
-(void)allBtnClick:(UIButton *)btn
{
    if (dataArray.count!=0) {
        selectMansong=!selectMansong;
        if (selectMansong) {
            NSDictionary *dic = [dataArray objectAtIndex:zhongmansongTag];
            NSArray *gifiArr = [dic objectForKey:@"gift_list"];
            for(int i=0;i<gifiArr.count;i++){
                if (btn.tag == 200+i) {
                    giftTag = 200+i;
                    [mansongTableview reloadData];
                }
            }
        }else
        {
            giftTag=-1;
            [mansongTableview reloadData];
        }
        
    }
    
}
-(void)disappear{
   
    mansongView.hidden = YES;
    for (UIView *subView in mansongView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)ManSongSubBtnClicked:(UIButton *)btn{
    if(btn.tag == 101){
        mansongTag = zhongmansongTag;
        mansongView.hidden = YES;
        for (UIView *subView in mansongView.subviews)
        {
            [subView removeFromSuperview];
        }
        
        //先判断gifttag 若是-1 则提示选择赠品 若是别的则将该赠品的名称 数量存入数组
        if (giftTag == -1) {
            [SYObject failedPrompt:@"请选择赠品"];
            
        }else{
            //发起请求是否成功选定赠品
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            NSDictionary *Mydic = [dataArray objectAtIndex:zhongmansongTag];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GIFT_URL]];
            request_22=[ASIFormDataRequest requestWithURL:url];
            if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                [request_22 setPostValue:_cart_meideng forKey:@"cart_ids"];
            }else{
//                [request_22 setPostValue:_cart_ids forKey:@"cart_ids"];
                NSArray *listArray=[Mydic objectForKey:@"goods_list"];
                NSMutableArray *mArray=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in listArray) {
                    [mArray addObject:[dic objectForKey:@"cart_id"]];
                }
                NSString *mString=[mArray componentsJoinedByString:@","];
                [request_22 setPostValue:mString forKey:@"cart_ids"];
            }
//            NSDictionary *Mydic = [dataArray objectAtIndex:zhongmansongTag];
            NSArray *myArray = [Mydic objectForKey:@"gift_list"];
            NSString *giftid = [NSString stringWithFormat:@"%@",[[myArray objectAtIndex:giftTag-200] objectForKey:@"goods_id"]];
            [request_22 setPostValue:giftid forKey:@"gift_id"];
            NSArray *arrObjc33;
            if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                arrObjc33 = [[NSArray alloc]initWithObjects:@"", nil];
            }else{
                arrObjc33 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
            }
            NSArray *arrKey33 = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy33 = [[NSMutableDictionary alloc]initWithObjects:arrObjc33 forKeys:arrKey33];
            [request_22 setRequestHeaders:dicMy33];
            request_22.tag = 101;
            request_22.delegate =self;
            [request_22 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_22 setDidFinishSelector:@selector(my18_urlRequestSucceeded:)];
            [request_22 startAsynchronous];
        }
        [MyTableView reloadData];
    }
    if(btn.tag == 102){
       
        mansongView.hidden = YES;
        for (UIView *subView in mansongView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if(btn.tag == 100){
        //应该先删除在veiw上面创建的东西然后进行删除
       
        mansongView.hidden = YES;
        for (UIView *subView in mansongView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
}
-(void)my18_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig16:%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] intValue] == 100) {
            [self tableviewRefrsh];
            sureBool = YES;
        }
        giftTag = -1;
    }
    else{
    }
}
#pragma mark -组合明细
-(void)combineClicked:(NSInteger)theNth{
    //点击组合明细按钮 请求数据 对页面进行刷新
    
    NSDictionary *dicQ = [dataArray objectAtIndex:theNth];
    NSArray *arrDic = [dicQ objectForKey:@"goods_list"];
    NSDictionary *dic = [arrDic objectAtIndex:0];
    
    
    NSMutableArray *marry=[[NSMutableArray alloc]init];
    ClassifyModel *claModel = [[ClassifyModel alloc]init];
    claModel.goods_id = [dic objectForKey:@"goods_id"];
    claModel.goods_main_photo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_main_photo"]];
    claModel.goods_name = [dic objectForKey:@"goods_name"];
    claModel.goods_current_price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_price"]];
    [marry addObject:claModel];
    
    NSDictionary *SubDic = [dic objectForKey:@"suit_info"];
    NSArray *arr = [SubDic objectForKey:@"goods_list"];
    for(NSDictionary *ste in arr){
        ClassifyModel *claModel = [[ClassifyModel alloc]init];
        claModel.goods_id = [ste objectForKey:@"id"];
        claModel.goods_main_photo = [NSString stringWithFormat:@"%@/%@",FIRST_URL,[ste objectForKey:@"img"]];
        claModel.goods_name = [ste objectForKey:@"name"];
        claModel.goods_current_price = [ste objectForKey:@"price"];
        claModel.goods_inventory=[NSString stringWithFormat:@"%@",[ste objectForKey:@"inventory"]];
        [marry addObject:claModel];
    }
    [combinDataArray addObject:marry];
    
}
-(void)combineDeleteClicked:(UIButton *)btn{
    if(btn.tag == 99){
       
        mansongView.hidden = YES;
        for (UIView *subView in mansongView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    for(int i=0;i<combinDataArray.count;i++){
        if (btn.tag == 100+i) {
            [OHAlertView showAlertWithTitle:@"⚠️提示" message:@"删除后其他套装商品将不享受优惠！" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }
    }
}

#pragma mark - SectionSelectionView DataSource

// Tell the datasource how many sections we have - best is to forward to the tableviews datasource
-(NSInteger)numberOfSectionsInSectionSelectionView:(CHSectionSelectionView *)sectionSelectionView
{
    return [MyTableView.dataSource numberOfSectionsInTableView:MyTableView];
}

// Create a nice callout view so that you see whats selected when
// your finger covers the sectionSelectionView
-(UIView *)sectionSelectionView:(CHSectionSelectionView *)selectionView callOutViewForSelectedSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:40];
    label.text = [MyTableView.dataSource tableView:MyTableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return label;
}
-(CHSectionSelectionItemView *)sectionSelectionView:(CHSectionSelectionView *)selectionView sectionSelectionItemViewForSection:(NSInteger)section{
    DemoSectionItemSubclass *selectionItem = [[DemoSectionItemSubclass alloc] init];
    selectionItem.titleLabel.text = [MyTableView.dataSource tableView:MyTableView titleForHeaderInSection:section];
    selectionItem.titleLabel.font = [UIFont systemFontOfSize:12];
    selectionItem.titleLabel.textColor = [UIColor darkGrayColor];
    selectionItem.titleLabel.highlightedTextColor = [UIColor redColor];
    selectionItem.titleLabel.shadowColor = [UIColor whiteColor];
    selectionItem.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return selectionItem;
}



@end
