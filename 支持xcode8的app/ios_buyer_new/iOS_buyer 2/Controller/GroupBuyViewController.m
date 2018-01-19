//
//  GroupBuyViewController.m
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupBuyViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "ThirdViewController.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataVerifier.h"
#import "Order.h"
#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "payRequsestHandler.h"
#import "PaySettingViewController.h"
#import "BundlingViewController.h"
#import "OnlineBalancePayTableViewController.h"
#import "GroupBuyView.h"
#import "GroupPurcheaseDetailModel.h"
#import "GroupBuyInfoModel.h"
#import "SYOrderDetailsModel.h"

#define SY_ALIPAY_VALUE @"alipay_app"
#define SY_WECHAT_VALUE @"wx_app"
#define SY_BAL_VALUE @"balance"
#define SY_UNIONPAY_VALUE @"unionpay"
#define SY_PAY_PIC_KEY @"pay_pic"
#define SY_PAY_DESC_KEY @"pay_decription"

@interface GroupBuyViewController ()<UITextFieldDelegate,WXApiManagerDelegate>
@property (nonatomic,weak)UIButton *currentBtn;
@property (nonatomic,strong)NSMutableArray *cbArray;
@property (nonatomic,strong)NSMutableArray *btnArray;

@end
static GroupBuyViewController *singleInstance=nil;
@implementation GroupBuyViewController
{
    ASIFormDataRequest *requestOnlinePayTypeSelect2;
    ASIFormDataRequest *requestOnlinePayTypeSelect3;
    ASIFormDataRequest *requestOnlinePayTypeSelect_wx;
    ASIFormDataRequest *requestWX_back;
    NSInteger tagZHI;
    GroupBuyView *_topView;
}

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
#pragma mark - 支付宝支付结束回调函数
-(void)aliPayDidFinish:(NSNotification *)notif{
    [SYObject endLoading];
    NSDictionary *userInfo = notif.userInfo;
    NSString *status = userInfo[@"result"];
    NSString *longText = userInfo[@"longText"];
    NSString *desc = [SYShopAccessTool codeDescByCodeNumber:status];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (status.integerValue!=9000) {
            //返回9000不一定成功，还要继续验证reallySuccess
            [SYObject failedPrompt:desc];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (status.intValue == 9000 && [SYShopAccessTool reallySuccess:longText]) {
                //支付成功
                //跳转成功页
                [SYObject redirectAfterPayment:self.navigationController orderNum:@{@"orderNum":th.order_details_model.order_num,@"price":[NSString stringWithFormat:@"%f",[self.groupModel.gg_price floatValue]*[_topView.textField.text floatValue]]}];
            }else if (status.intValue == 9000 && ![SYShopAccessTool reallySuccess:longText]){
                //莫名其妙的支付失败
                [SYObject failedPrompt:@"支付失败:未知原因"];
            }
            else{
                //各种原因的支付失败
                //啥也不干
            }
        });
                                                  
    });
}

#pragma mark - 微信支付结束回调函数
-(void)managerDidGetBackType:(WXApiManager *)manager backType:(backType)backtype{
    [SYObject endLoading];
    //提示用户
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *msg = nil;
        if (backtype == backTypePaySuccess) {
            msg = @"微信支付成功!";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转充值成功页
                [SYObject redirectAfterPayment:self.navigationController orderNum:@{@"orderNum":th.order_details_model.order_num,@"price":[NSString stringWithFormat:@"%f",[self.groupModel.gg_price floatValue]*[_topView.textField.text floatValue]]}];
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

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(MyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)MyBtnClicked{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 生命周期方法
-(void)dealloc{
    //注销通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ALIPAY_FINISH_NOTIF object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [SYShopAccessTool groupDetailsByGroupOrderID:self.groupBuy_id s:^(NSDictionary *dict) {
        NSLog(@"zhifu%@",dict);
//        self.longNum = dict;
//        GroupBuyInfoModel *model = [GroupBuyInfoModel yy_modelWithDictionary:dict];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
       // NSArray *infoArr = dict[@"groupinfos"];
        th.ding_fangshi = dict[@"payType"];
        th.ding_hao = dict[@"order_id"];
    } failure:^(NSString *errStr) {
        NSLog(@"%@",errStr);
    }];
    FirstViewController *firest = [FirstViewController sharedUserDefault];
    firest.payType = @"group";
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
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    tagZHI = -1;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    if (_topView.textField.text.intValue>0)
    {
    _topView.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",[self.groupModel.gg_price floatValue]*[_topView.textField.text floatValue]];
    }else
    {
        [SYObject failedPrompt:@"请输入正确数量"];
    }
    
    return  YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillDisappear:YES];
    [requestOnlinePayTypeSelect2 clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect3 clearDelegatesAndCancel];
    [requestWX_back clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect_wx clearDelegatesAndCancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.title = @"支付方式";
    _cbArray = [NSMutableArray array];
    _btnArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [[NSMutableArray alloc]init];
    [self createBackBtn];
    //注册支付宝支付完毕回调通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayDidFinish:) name:ALIPAY_FINISH_NOTIF object:nil];
}
-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        return 667+66;
    }
    return 0;
}
-(void)amountClick:(UIButton *)btn
{
    if (btn.tag==51)
    {
        _topView.textField.text=[NSString stringWithFormat:@"%d",[_topView.textField.text intValue]+1];
    }else
    {
        if ( [_topView.textField.text intValue]>1) {
             _topView.textField.text=[NSString stringWithFormat:@"%d",[_topView.textField.text intValue]-1];
        }
    
    
    }
    _topView.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",[self.groupModel.gg_price floatValue]*[_topView.textField.text floatValue]];
    
}
-(void)changePhone
{
    BundlingViewController * bund=[[BundlingViewController alloc] init];
    [self.navigationController pushViewController:bund animated:YES];


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
        UIFont *normalFont = [UIFont systemFontOfSize:13.f];
        
        GroupBuyView *topView=[[[NSBundle mainBundle]loadNibNamed:@"GroupBuyView" owner:nil options:nil]firstObject];
        _topView=topView;
        topView.frame=CGRectMake(0, 15, ScreenFrame.size.width, 257);
        [topView.img sd_setImageWithURL:[NSURL URLWithString:self.groupModel.gg_img]];
        topView.name.text=self.groupModel.gg_name;
        topView.textField.text=@"1";
        topView.textField.textAlignment=NSTextAlignmentCenter;
        topView.textField.delegate=self;
        topView.price.text=[NSString stringWithFormat:@"￥%@",self.groupModel.gg_price];
        topView.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",[self.groupModel.gg_price floatValue]*[topView.textField.text floatValue]];
        if (self.mobile)
        {
            topView.phone.text=[NSString stringWithFormat:@"%@",self.mobile];
        }
       
        topView.changeBtn.backgroundColor=UIColorFromRGB(0xf15353);
        [topView.changeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [topView.changeBtn addTarget:self action:@selector(changePhone) forControlEvents:(UIControlEventTouchUpInside)];
        [cell addSubview:topView];
        [topView.addBtn addTarget:self action:@selector(amountClick:) forControlEvents:(UIControlEventTouchUpInside)];
        topView.addBtn.tag=51;
        topView.reduceBtn.tag=50;
        [topView.reduceBtn addTarget:self action:@selector(amountClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
         space += 10 + 44 + 44;
        //支付方式区域行高
        CGFloat lH = 50;

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 272, ScreenFrame.size.width, dataArray.count*lH + 44)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        
        UILabel *methodLabel = [[UILabel alloc]init];
        methodLabel.frame = CGRectMake(15, view.top + 0.5 * (44 - lH), ScreenFrame.size.width - 20, lH);
        methodLabel.text = @"支付方式：";
        methodLabel.font = normalFont;
        [cell addSubview:methodLabel];
        
        
        for(int i=0;i<dataArray.count;i++){
            
            CGFloat leftP = 40.f;
            //分隔线
            UIImageView *lableLL = [[UIImageView alloc]initWithFrame:CGRectMake(20,  43+lH*i, ScreenFrame.size.width - 20, 0.5)];
            lableLL.backgroundColor = BACKGROUNDCOLOR;
            if (i == 0) {
                lableLL.hidden = YES;
            }else{
                lableLL.hidden = NO;
            }
            [view addSubview:lableLL];
            
            NSString *imgStr = [dataArray[i] objectForKey:SY_PAY_PIC_KEY];
            UIImage *img = [UIImage imageNamed:imgStr];
            UIImageView *payPicView = [[UIImageView alloc]initWithImage:img];

             payPicView.frame = CGRectMake(15, lableLL.bottom + 5, leftP, leftP);
            [view addSubview:payPicView];
            
            UILabel *lablec = [[UILabel alloc]initWithFrame:CGRectMake(50, lableLL.bottom+3 , ScreenFrame.size.width - 65 - 50, lH * 0.5)];
            lablec.text = [NSString stringWithFormat:@"    %@",[[dataArray objectAtIndex:i] objectForKey:@"pay_name"]];
            lablec.font = normalFont;
            [view addSubview:lablec];
            
            UILabel *lablecc = [[UILabel alloc]init];
            lablecc.font = normalFont;
            lablecc.textColor = [UIColor lightGrayColor];
            lablecc.frame = CGRectMake(lablec.left, lablec.bottom-3, lablec.width, lablec.height);
            NSString *desc = [dataArray[i] objectForKey:SY_PAY_DESC_KEY];
            NSString *desc1 = [NSString stringWithFormat:@"    %@",desc];
            lablecc.text = desc1;
            [view addSubview:lablecc];
            

             CGRect frameCB = CGRectMake(ScreenFrame.size.width - 10 - 35, 54+ lH * i , 35, 35);
            UIImage *nImg = [UIImage imageNamed:@"checkbox_no"];
            UIImage *hImg = [UIImage imageNamed:@"checkbox_yes"];
            UIImageView *checkBox = [[UIImageView alloc]initWithImage:nImg highlightedImage:hImg];
            checkBox.frame = frameCB;
            [view addSubview:checkBox];
            [_cbArray addObject:checkBox];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(0, 42+lH*i , ScreenFrame.size.width, lH);
            [button addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 400 + i;
           
            button.titleLabel.font  = [UIFont systemFontOfSize:14];
            [view addSubview:button];
            [_btnArray addObject:button];
            [SYObject endLoading];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(23, view.bottom + 20, ScreenFrame.size.width - 2 * 23, 45);
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 201;
        [button addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交订单" forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(0xf15353);
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:4.0];
        button.titleLabel.font  = [UIFont boldSystemFontOfSize:17.f];
        [cell addSubview:button];
    }
    return cell;
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
-(void)btnClicked:(UIButton *)btn{
    if (!self.groupBuy_id||[self.groupBuy_id isEqualToString:@"(null)"]||[self.groupBuy_id isEqualToString:@""]) {
        [SYObject failedPrompt:@"订单ID为空"];
        return;
    }
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    //th.ding_order_id = self.groupBuy_id;
    if (btn.tag == 201) {
        [SYObject startLoading];
        if (dataArray.count!=0) {
            //TODO: 这里传值,发送请求
            if (tagZHI==-1) {
                [SYObject endLoading];
                [SYObject failedPrompt:@"还没选择支付方式!"];
                return;
            }
            NSDictionary *dic = [dataArray objectAtIndex:tagZHI];
            NSLog(@"dic=====%@",dic);
            //支付宝
            if ([[dic objectForKey:@"pay_mark"] isEqualToString:online_mark])
            {//根据顾客选择的数量来生成真正的订单号(order_id)
                [SYShopAccessTool lifeSaveOrderWithGroupItemID:self.groupBuy_id orderCount:_topView.textField.text payMethod:online_mark s:^(BOOL success)
                {
                    
                     [SYShopAccessTool orderDetailsByOrderID:th.ding_order_id s:^(SYOrderDetailsModel *model) {
                         th.order_details_model=model;
                         [SYShopAccessTool aliPayWithOrderID:th.ding_order_id orderType:@"group"];}  failure:^(NSString *errStr) {
                             NSLog(@"err: %@",errStr);
                         }];

                }
                failure:^(NSString *errStr) {
                NSLog(@"%@",errStr);
                }];
                
            }
            //预存款
            else if ([[dic objectForKey:@"pay_mark"] isEqualToString:balance_mark]){
                [SYObject startLoading];
                //本页面就是团购页面
                //根据顾客选择的数量来生成真正的订单号(order_id)传给下个控制器
                [SYShopAccessTool lifeSaveOrderWithGroupItemID:self.groupBuy_id orderCount:_topView.textField.text payMethod:balance_mark s:^(BOOL success) {
                    [SYShopAccessTool orderDetailsByOrderID:th.ding_order_id s:^(SYOrderDetailsModel *model) {
                        th.order_details_model = model;
                        th.jie_order_goods_price = [SYObject stringByNumber:model.order_price4];
                        //检查支付密码+手机绑定
                        [SYShopAccessTool checkPswdNMobile:^(BOOL has) {
                            if (!has) {
                                [SYObject endLoading];
                                [OHAlertView showAlertWithTitle:@"您还未绑定手机！" message:@"是否去绑定？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                                    if (buttonIndex==0) {
                                        BundlingViewController *bvVC = [[BundlingViewController alloc]init];//没设置支付密码，绑定手机
                                        bvVC.enterType = BUNDLINGVC_ENTER_TYPE_FROM_PAY_SELECT;
                                        [self.navigationController pushViewController:bvVC animated:YES];

                                    }else{
                                    }
                                }];

                        }else{
                                [SYObject endLoading];
                                //安全
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
                                OnlineBalancePayTableViewController *obTVC = [storyboard instantiateViewControllerWithIdentifier:@"onlineBalancePay"];
                                obTVC.group = YES;
                                obTVC.group1=NO;
                                obTVC.oid=self.groupBuy_id;
                                [self.navigationController pushViewController:obTVC animated:YES];
                            }
                        } failure:nil];
                    } failure:^(NSString *errStr) {
                        NSLog(@"err: %@",errStr);
                    }];
                } failure:^(NSString *errStr) {
                    NSLog(@"%@",errStr);
                }];
                
                
            }
            //微信
            else if ([[dic objectForKey:@"pay_mark"] isEqualToString:weixin_mark]){
                //根据顾客选择的数量来生成真正的订单号(order_id)
                [SYShopAccessTool lifeSaveOrderWithGroupItemID:self.groupBuy_id orderCount:_topView.textField.text payMethod:weixin_mark s:^(BOOL success) {
                    [SYShopAccessTool orderDetailsByOrderID:th.ding_order_id s:^(SYOrderDetailsModel *model) {
                        th.order_details_model=model;
                    [SYShopAccessTool wechatPayWithID:th.ding_order_id type:@"group"];
                    }failure:^(NSString *errStr) {
                        NSLog(@"err: %@",errStr);
                    }];}
                   failure:^(NSString *errStr) {
                        NSLog(@"%@",errStr);
                    }];
            }
            //银联
            else if ([[dic objectForKey:@"pay_mark"] isEqualToString:SY_UNIONPAY_VALUE]){
                //根据顾客选择的数量来生成真正的订单号(order_id)
                [SYShopAccessTool lifeSaveOrderWithGroupItemID:self.groupBuy_id orderCount:_topView.textField.text payMethod:weixin_mark s:^(BOOL success) {
                    [SYShopAccessTool orderDetailsByOrderID:th.ding_order_id s:^(SYOrderDetailsModel *model) {
                        th.order_details_model=model;
                       [UPPayManager unionpayManagerStartPay:th.ding_order_id andOrderType:@"group" viewController:self];
                    }failure:^(NSString *errStr) {
                        NSLog(@"err: %@",errStr);
                    }];}
                failure:^(NSString *errStr) {
                    NSLog(@"%@",errStr);
                }];
            }

        }
    }
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
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
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
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
