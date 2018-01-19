
//
//  PaySuccessViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/12/9.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "NotifWebViewController.h"
#import "OrderListViewController.h"
#import "LoginViewController.h"
#import "FirstViewController.h"
#import "IndianaRecordsViewController.h"
#import "SYOrderDetailsTableViewController.h"
#import "ThirdViewController.h"
#import "IntegraDetialViewController.h"
#import "IntegralExchangeViewController.h"

@interface PaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernamephone;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *realprice;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (assign, nonatomic)SEL action;

@end

@implementation PaySuccessViewController

#pragma mark - 生命周期方法
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self createBackBtn];
    [self createGoReview];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -去评价App 1.7 00025
-(void)createGoReview{
    NSInteger num = 0;
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    if ([defau objectForKey:@"PaySuccessNum"]) {//不是第一次购买成功
        num = [[defau objectForKey:@"PaySuccessNum"] integerValue];
        num++;
        [defau setObject:[NSNumber numberWithInteger:num] forKey:@"PaySuccessNum"];
    }else{//第一次购买成功
        [defau setObject:[NSNumber numberWithInteger:num] forKey:@"PaySuccessNum"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSInteger loginNum = [[defau objectForKey:@"PaySuccessNum"] integerValue];
    NSInteger notToLoginNum = [[defau objectForKey:@"notToCommentNum"] integerValue];
    NSLog(@"lPaySuccess = %ld ,notToLoginNum=%ld",(long)loginNum,(long)notToLoginNum);
    
    if(loginNum==0 && notToLoginNum < 3){
        [OHAlertView showAlertWithTitle:@"求五星好评~~" message:@"程序猿熬夜奋战，只为您更好的体验!" cancelButton:nil otherButtons:@[@"去评价",@"离开"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
                //去评价
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
            }else{
                //离开
                NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
                if ([defau objectForKey:@"notToCommentNum"]) {//不是第一次拒绝
                    NSInteger nonum = [[defau objectForKey:@"notToCommentNum"] integerValue];
                    nonum++;
                    [defau setObject:[NSNumber numberWithInteger:nonum] forKey:@"notToCommentNum"];
                }else{//第一次拒绝
                    [defau setObject:[NSNumber numberWithInteger:num] forKey:@"notToCommentNum"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }else{
    }
    //测试使用
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaySuccessNum"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notToCommentNum"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
#pragma mark - 初始化设置
-(void)setupUI{
    self.title = @"成功页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _backBtn.layer.cornerRadius = 5.f;
    [_backBtn.layer setMasksToBounds:YES];
    
   
    if (self.userInfo) {
        NSString *orderNum = self.userInfo[@"orderNum"];
        NSString *price = self.userInfo[@"price"];
        _usernamephone.text = [NSString stringWithFormat:@"订单号：%@",orderNum];
        _usernamephone.hidden=YES;
        _addressLabel.text = @"";
        _line.hidden=YES;
        UIView *line=[LJControl viewFrame:CGRectMake(0, 75, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [_bigView addSubview:line];
        UILabel *moneyLab=[LJControl labelFrame:CGRectMake(23, 86, ScreenFrame.size.width-23, 50) setText:[NSString stringWithFormat:@"实付款：￥%@",price] setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:(NSTextAlignmentLeft)];
        [_bigView addSubview:moneyLab];
        
        UILabel *orderLab=[LJControl labelFrame:CGRectMake(23, 15, ScreenFrame.size.width-23, 50) setText:[NSString stringWithFormat:@"订单号：%@",orderNum] setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:(NSTextAlignmentLeft)];
        [_bigView addSubview:orderLab];
        
        
        _realprice.hidden=YES;
        
        
      
        if ([_orderType isEqualToString:@"integral"]) {
            UIButton *btn= [LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake((ScreenFrame.size.width-129.f)/2.f, 146, 129.f, 37) setNormalImage:nil setSelectedImage:nil setTitle:@"查看我的订单" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0xf15353)];
            [_bigView addSubview:btn];
            btn.titleLabel.textColor=[UIColor whiteColor];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];
            _bigView.height=100;
            
            
            [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

        }else{
            UIButton *btn= [LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake((ScreenFrame.size.width-129.f)/2.f, 146, 129.f, 37) setNormalImage:nil setSelectedImage:nil setTitle:@"返回首页" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0xf15353)];
            [_bigView addSubview:btn];
            btn.titleLabel.textColor=[UIColor whiteColor];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];
             _bigView.height=100;

            
             [btn addTarget:self action:@selector(backFirstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        _backBtn.hidden=YES;
        

        [self.view updateConstraintsIfNeeded];
        _realprice.text = [NSString stringWithFormat:@"实付款：￥%@",price];
        [_backBtn addTarget:self action:@selector(backFirstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        
    }else{
        NSString *string = [_usernameAndPhone stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        if (string==nil) {
            _usernamephone.text = @"";

        }else{
            _usernamephone.text = [NSString stringWithFormat:@"收货人：%@",string];

        }
        if(_address==nil){
            _addressLabel.text = @"";

        }else{
            _addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",_address];

        }
        _realprice.text = [NSString stringWithFormat:@"实付款：￥%@",_realPrice];
        [_backBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [_backBtn setTitle:@"查看订单" forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    if ([_orderType isEqualToString:@"cloudpurchase"]) {
        _usernamephone.text = @"祝君好运";
        _addressLabel.text = @"敬请期待，即将揭晓！";
    }
    if ([_orderType isEqualToString:@"ios"]) {
        _usernamephone.text = @"";
        _addressLabel.text = @"升级成功";
    }
}
- (void)click{
    UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    IntegralExchangeViewController *ievc = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];
    [self.navigationController pushViewController:ievc animated:YES];
}
-(void)backFirstBtnClicked:(UIButton *)btn
{

    [self.navigationController popToRootViewControllerAnimated:NO];
    FirstViewController *first = [FirstViewController sharedUserDefault];
        [first tabbarIndex:0];



}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    if (!self.action) {
        self.action = @selector(backBtnClicked2);
    }
    [button addTarget:self action:self.action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked2
{
 [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 点击方法
-(IBAction)backBtnClicked:(id)sender{
    if ([_orderType isEqualToString:@"cloudpurchase"]) {
        IndianaRecordsViewController *irvc=[[IndianaRecordsViewController alloc]init];
        irvc.backType=@"paySuccess";
        [self.navigationController pushViewController:irvc animated:YES];
    }else{
        
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
        SYOrderDetailsTableViewController *detailTVC = [sb instantiateViewControllerWithIdentifier:@"orderDetails"];
        detailTVC.orderID = [SYObject stringByNumber:th.ding_order_id ];
        detailTVC.successLogin=YES;
        [self.navigationController pushViewController:detailTVC animated:YES];
       
        
    }
}
//更多防骗秘籍
- (IBAction)moreBtn:(id)sender {
    NotifWebViewController *web = [[NotifWebViewController alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/s?wd=%E9%98%B2%E9%AA%97%E7%A7%98%E7%B1%8D"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    web.title = @"防骗秘籍";
    web.request = request;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}

@end
