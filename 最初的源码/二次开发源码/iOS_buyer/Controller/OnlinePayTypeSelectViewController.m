//
//  OnlinePayTypeSelectViewController.m
//  My_App
//
//  Created by apple on 15-2-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OnlinePayTypeSelectViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataVerifier.h"
#import "Order.h"
#import "WXApiManager.h"
#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "payRequsestHandler.h"
#import "PaySettingViewController.h"
#import "BundlingViewController.h"
#import "OnlineBalancePayTableViewController.h"
#import "SYOrderDetailsModel.h"

#define SY_ALIPAY_VALUE @"alipay_app"
#define SY_WECHAT_VALUE @"wx_app"
#define SY_BAL_VALUE @"balance"
#define SY_UNIONPAY_VALUE @"unionpay"
#define SY_PAY_PIC_KEY @"pay_pic"
#define SY_PAY_DESC_KEY @"pay_decription"

@interface OnlinePayTypeSelectViewController ()<WXApiManagerDelegate>

@property (nonatomic,weak)UIButton *currentBtn;
@property (nonatomic,strong)NSMutableArray *cbArray;
@property (nonatomic,strong)NSMutableArray *btnArray;
@property (nonatomic,strong)SYOrderDetailsModel *odtModel;

@end

static OnlinePayTypeSelectViewController *singleInstance=nil;

@implementation OnlinePayTypeSelectViewController
{
    ASIFormDataRequest *requestOnlinePayTypeSelect2;
    ASIFormDataRequest *requestOnlinePayTypeSelect3;
    ASIFormDataRequest *requestOnlinePayTypeSelect_wx;
    ASIFormDataRequest *requestWX_back;
    NSInteger tagZHI;
}

#pragma mark - 单例
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
#pragma mark - 初始化
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(MyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)MyBtnClicked{
    [OHAlertView showAlertWithTitle:@"确认操作" message:@"您的订单尚未支付，确定要终止支付操作吗？" cancelButton:nil otherButtons:@[@"取消",@"我要离开"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex==0) {
        }else{
//           [self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
        }
        
    }];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 生命周期方法
-(void)dealloc{
    //清理通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ALIPAY_FINISH_NOTIF object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    FirstViewController *firest = [FirstViewController sharedUserDefault];
    firest.payType = @"goods";
    if (_MyBool == NO) {
        
    }else{
        _MyBool = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    NSURL *url22 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ALLPAYTYPE_URL]];
    requestOnlinePayTypeSelect2 = [ASIFormDataRequest requestWithURL:url22];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    [requestOnlinePayTypeSelect2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestOnlinePayTypeSelect2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestOnlinePayTypeSelect2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestOnlinePayTypeSelect2.tag = 102;
    requestOnlinePayTypeSelect2.delegate = self;
    [requestOnlinePayTypeSelect2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestOnlinePayTypeSelect2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [requestOnlinePayTypeSelect2 startAsynchronous];
    self.tabBarController.tabBar.hidden = YES;
    tagZHI = -1;
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    [SYShopAccessTool orderDetailsByOrderID:th.ding_order_id s:^(SYOrderDetailsModel *model) {
        self.odtModel = model;
    } failure:^(NSString *errStr) {
        [SYObject failedPrompt:errStr];
    }];
    [SYObject startLoading];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        }else{
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+0, ScreenFrame.size.width, ScreenFrame.size.height-0)];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        MyTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        [self.view addSubview:MyTableView];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillDisappear:YES];
    [requestOnlinePayTypeSelect2 clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect3 clearDelegatesAndCancel];
    [requestWX_back clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect_wx clearDelegatesAndCancel];
    _order_type=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付方式";
    _cbArray = [NSMutableArray array];
    _btnArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [[NSMutableArray alloc]init];
    [self createBackBtn];
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayProcessDidFinish:) name:ALIPAY_FINISH_NOTIF object:nil];
}
#pragma mark - 支付宝支付结束回调函数
-(void)aliPayProcessDidFinish:(NSNotification *)notif{
    [SYObject endLoading];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSDictionary *userInfo = notif.userInfo;
    NSString *status = userInfo[@"result"];
    NSString *longText = userInfo[@"longText"];
    NSString *desc = [SYShopAccessTool codeDescByCodeNumber:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (status.integerValue!=9000) {
            //返回9000不一定成功，还要继续验证reallySuccess
            [SYObject failedPrompt:desc];
        }else if (status.intValue == 9000 && [SYShopAccessTool reallySuccess:longText]) {
            //支付成功
            //跳转
            [SYObject failedPrompt:@"支付成功,即将跳转..."];
            NSString *nameNphone = [NSString stringWithFormat:@"%@ %@",_odtModel.order_username,_odtModel.order_mobile];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_order_type isEqualToString:@"cloudpurchase"]) {
                    [SYObject redirectPurchaseOfCloud:self.navigationController nameNphone:nameNphone address:_odtModel.order_address realprice:th.jie_order_goods_price];
                }else{
                    [SYObject redirectAfterPayment:self.navigationController nameNphone:nameNphone address:_odtModel.order_address realprice:th.jie_order_goods_price];
                }
            });
        }else if (status.intValue == 9000 && ![SYShopAccessTool reallySuccess:longText]){
            //莫名其妙的支付失败
            [SYObject failedPrompt:@"支付失败:未知原因"];
        }
    });
    
}
#pragma mark - 微信支付结束回调函数
-(void)managerDidGetBackType:(WXApiManager *)manager backType:(backType)backtype{
    [SYObject endLoading];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    //提示用户
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *msg = nil;
        if (backtype == backTypePaySuccess) {
            msg = @"微信支付成功!";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *nameNphone = [NSString stringWithFormat:@"%@ %@",_odtModel.order_username,_odtModel.order_mobile];
//                [SYObject redirectAfterPayment:self.navigationController nameNphone:nameNphone address:_odtModel.order_address realprice:th.jie_order_goods_price];
                if ([_order_type isEqualToString:@"cloudpurchase"]) {
                    [SYObject redirectPurchaseOfCloud:self.navigationController nameNphone:nameNphone address:_odtModel.order_address realprice:th.jie_order_goods_price];
                }else{
                    [SYObject redirectAfterPayment:self.navigationController nameNphone:nameNphone address:_odtModel.order_address realprice:th.jie_order_goods_price];
                }
            });
        }else if (backtype == backTypeCancelOrder){
            msg = @"您已取消微信支付!";
        }else if (backtype == backTypePayError){
            msg = @"微信支付遇到错误!";
        }else{
            msg = @"未知错误!";
        }
        [SYObject failedPrompt:msg];
    });
    
}
#pragma mark - tableview数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        return 537+66;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    }
    if (dataArray.count!=0) {
        CGFloat space = 10.f;
        CGFloat h1 = 50.f;
        
        ThirdViewController *th  = [ThirdViewController sharedUserDefault];
        UILabel *lableD = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + space, ScreenFrame.size.width, h1)];
        lableD.text = @"    订单号:";
        lableD.backgroundColor = [UIColor whiteColor];
        [cell addSubview:lableD];
        UILabel *lableH = [[UILabel alloc]initWithFrame:CGRectMake(30, 5 + space, ScreenFrame.size.width - 50, h1)];
        lableH.text = [NSString stringWithFormat:@"%@",th.ding_hao];
        lableH.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lableH];
        
        UIImageView *lineH = [[UIImageView alloc]init];
        lineH.backgroundColor = BACKGROUNDCOLOR;
        lineH.frame = CGRectMake(0,lableH.bottom,ScreenFrame.size.width,1);
        [cell addSubview:lineH];
        
        UILabel *lableJ = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + space + h1, ScreenFrame.size.width, h1)];
        lableJ.text = @"    订单金额:";
        lableJ.backgroundColor = [UIColor whiteColor];
        [cell addSubview:lableJ];
        
        UILabel *lableJM = [[UILabel alloc]initWithFrame:CGRectMake(30, 5 + space + h1, ScreenFrame.size.width - 50, h1)];
        lableJM.text = [NSString stringWithFormat:@"￥%0.2f",[th.jie_order_goods_price floatValue]];
        lableJM.textColor=UIColorFromRGB(0xf15353);
        lableJM.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lableJM];
        
        space += 10 + 44 + 44;
        //支付方式区域行高
        CGFloat lH = 66;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 70 + space - 44, ScreenFrame.size.width, dataArray.count*lH + 44)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        
        UILabel *methodLabel = [[UILabel alloc]init];
        methodLabel.frame = CGRectMake(15, view.top + 0.5 * (44 - lH), ScreenFrame.size.width - 20, lH);
        methodLabel.text = @"支付方式：";
        [cell addSubview:methodLabel];
        
        
        for(int i=0;i<dataArray.count;i++){
            CGFloat space1 = 10.f;
            CGFloat picWH = 46.f;
            //分隔线
            UIImageView *lableLL = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70 + lH * i + space, ScreenFrame.size.width - 20, 0.5)];
            lableLL.backgroundColor = BACKGROUNDCOLOR;
            [cell addSubview:lableLL];
            
            NSString *imgStr = [dataArray[i] objectForKey:SY_PAY_PIC_KEY];
            UIImage *img = [UIImage imageNamed:imgStr];
            UIImageView *payPicView = [[UIImageView alloc]initWithImage:img];
            payPicView.frame = CGRectMake(15, lableLL.bottom + space1, picWH, picWH);
            [cell addSubview:payPicView];
            
            UILabel *lablec = [[UILabel alloc]initWithFrame:CGRectMake(payPicView.right - 10, lableLL.bottom + 10, ScreenFrame.size.width - 35 - payPicView.right, (lH - 2 * space1) * 0.5)];
            lablec.text = [NSString stringWithFormat:@"    %@",[[dataArray objectAtIndex:i] objectForKey:@"pay_name"]];
            [cell addSubview:lablec];
            
            UILabel *lablecc = [[UILabel alloc]init];
            lablecc.textColor = [UIColor lightGrayColor];
            lablecc.frame = CGRectMake(lablec.left, lablec.bottom, lablec.width, lablec.height);
            NSString *desc = [dataArray[i] objectForKey:SY_PAY_DESC_KEY];
            NSString *desc1 = [NSString stringWithFormat:@"    %@",desc];
            lablecc.text = desc1;
            lablecc.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lablecc];
            
            CGRect frameCB = CGRectMake(ScreenFrame.size.width - 10 - 35, 70+ lH * i + space + (lH - 35) * 0.5, 35, 35);
            UIImage *nImg = [UIImage imageNamed:@"checkbox_no"];
            UIImage *hImg = [UIImage imageNamed:@"checkbox_yes"];
            UIImageView *checkBox = [[UIImageView alloc]initWithImage:nImg highlightedImage:hImg];
            checkBox.frame = frameCB;
            [cell addSubview:checkBox];
            [_cbArray addObject:checkBox];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(0, 70+lH*i + space, ScreenFrame.size.width, lH);
            [button addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 400 + i;
            button.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button];
            [_btnArray addObject:button];
            [SYObject endLoading];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, view.bottom + 20, ScreenFrame.size.width - 2 * 10, 44);
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 201;
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(0xf15353);
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:4.0];
        [cell addSubview:button];
        
        [cell bringSubviewToFront:lineH];
    }
    return cell;
}
-(IBAction)selectBtnClicked:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag - 400;//0 1 2
    if (!_currentBtn) {
        _currentBtn = btn;
        NSInteger index = [_btnArray indexOfObject:_currentBtn];
        UIImageView *curCB = _cbArray[index];
        [curCB setHighlighted:YES];
        tagZHI = tag;
    }
    else if (_currentBtn!=btn) {
        NSInteger index = [_btnArray indexOfObject:_currentBtn];
        UIImageView *curCB = _cbArray[index];
        [curCB setHighlighted:NO];
        _currentBtn = btn;
        index = [_btnArray indexOfObject:_currentBtn];
        curCB = _cbArray[index];
        [curCB setHighlighted:YES];
        tagZHI = tag;
    }
}
#pragma mark - 点击方法
-(void)btnClicked:(UIButton *)btn{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    if (btn.tag == 201) {
        [SYObject startLoading];
        if (dataArray.count!=0) {
            
            if (tagZHI==-1) {
                [SYObject endLoading];
                [SYObject failedPrompt:@"支付方式不能为空"];
                return;
            }
            NSString *orderID=[NSString stringWithFormat:@"%@",th.ding_order_id] ;
            if (orderID==nil||[orderID isEqualToString:@""]||[orderID isEqualToString:@"(null)"]) {
                [SYObject failedPrompt:@"订单信息有误!"];
                return;
            }
            NSDictionary *dic = [dataArray objectAtIndex:tagZHI];
            NSLog(@"dic=====%@",dic);
            if ([[dic objectForKey:@"pay_mark"] isEqualToString:online_mark]) {//支付宝支付
                //这里指定支付类型
//                NSString *orderType = @"goods";
                if (_order_type) {
                }else{
                    _order_type = @"goods";
                }
                NSString *orderType=_order_type;
                [SYShopAccessTool aliPayWithOrderID:th.ding_order_id orderType:orderType];
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:balance_mark]){//预存款支付
                //提前判断是否设置了支付密码
                [SYObject startLoading];
                [SYShopAccessTool checkPswdNMobile:^(BOOL has) {
                    if (!has) {
                        [SYObject endLoading];
                        [OHAlertView showAlertWithTitle:@"您还未设置支付密码！" message:@"是否去设置？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                            if (buttonIndex==0) {
                                PaySettingViewController *pay = [[PaySettingViewController alloc]init];
                                
                                [self.navigationController pushViewController:pay animated:YES];
                            }else{
                            }
                        }];
                    }else{
                        [SYObject endLoading];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
                        OnlineBalancePayTableViewController *obTVC = [storyboard instantiateViewControllerWithIdentifier:@"onlineBalancePay"];
                        if (self.group==YES){
                            obTVC.group=YES;
                            obTVC.group1=YES;
                        }
                        if (_order_type) {
                        }else{
                            _order_type = @"goods";
                        }
                        obTVC.orderType=_order_type;
                        [self.navigationController pushViewController:obTVC animated:YES];
                    }
                } failure:nil];
                
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:weixin_mark]){//微信支付
                //这里指定支付方式:
//                NSString *typeString = @"goods";
               
                if (_order_type) {
                }else{
                    _order_type = @"goods";
                }
                 NSString *typeString=_order_type;
                
                [SYShopAccessTool wechatPayWithID:th.ding_order_id type:typeString];
            }else if ([[dic objectForKey:@"pay_mark"] isEqualToString:unionpay_mark]){//银联支付
                NSLog(@"%@",dic);
                if (_order_type) {
                }else{
                    _order_type = @"goods";
                }
                NSString *typeString=_order_type;
                [UPPayManager unionpayManagerStartPay:th.ding_order_id andOrderType:typeString viewController:self];
                
            }
        }
    }
}
#pragma mark - 网络请求
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1dicBig:%@",dicBig);
        if(dicBig){
            if (dataArray.count !=0) {
                [dataArray removeAllObjects];
            }
            NSArray *arr = [dicBig objectForKey:@"datas"];
            for(NSDictionary *dic in arr){
                //放入图片
                NSMutableDictionary *dict = [dic mutableCopy];
                NSString *value = [dict objectForKey:@"pay_mark"];
                if ([value isEqualToString:SY_WECHAT_VALUE]) {
                    [dict setObject:@"pay_select_wechat" forKey:SY_PAY_PIC_KEY];
                    [dict setObject:@"推荐微信支付用户使用" forKey:SY_PAY_DESC_KEY];
                }else if ([value isEqualToString:SY_ALIPAY_VALUE]){
                    [dict setObject:@"pay_select_alipay" forKey:SY_PAY_PIC_KEY];
                    [dict setObject:@"推荐支付宝用户使用" forKey:SY_PAY_DESC_KEY];
                }else if ([value isEqualToString:SY_BAL_VALUE]){
                    [dict setObject:@"pay_select_balance" forKey:SY_PAY_PIC_KEY];
                    [dict setObject:@"推荐商城预存款用户使用" forKey:SY_PAY_DESC_KEY];
                }else if ([value isEqualToString:SY_UNIONPAY_VALUE]){
                    [dict setObject:@"pay_select_unionpay" forKey:SY_PAY_PIC_KEY];
                    [dict setObject:@"推荐银联用户使用" forKey:SY_PAY_DESC_KEY];
                }else{
                }
                [dataArray addObject:dict];
            }
            [MyTableView reloadData];
        }
        [SYObject endLoading];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
