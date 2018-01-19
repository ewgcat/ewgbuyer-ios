//
//  ExchangeCarViewController.h
//  My_App
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface ExchangeCarViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ASIHTTPRequestDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    UITableView *shjTableView;
    NSMutableArray *dataArr;
    NSInteger all_integral;
    NSInteger all_shipfee;
    //商品总金额
    NSInteger goods_total_price;
//    订单总金额
    NSInteger order_total_price;
    
    BOOL btnBool;
    BOOL btnBool2;
//    UILabel *labelTi;
    UIButton *btnAccount;
    
    UIButton *btnAllSelect;
    UIView *InputView;
    UILabel *CountInput;
    UITextField *textFF;
    NSInteger fieldTag;
    UIButton *btnDelete;
    
//    UIView *loadingV;
}

@property (strong, nonatomic) UIImageView *imgLog;
@property (strong, nonatomic) UILabel *lblGoodsName;
@property (strong, nonatomic) UILabel *lblIntegrals;
@property (strong, nonatomic) UILabel *lblIntegralTotal;

//商品金额的数字
@property (strong, nonatomic) UILabel *moneyCountLabel;

//订单总金额的数字
@property (strong, nonatomic) UILabel *allMoneyCountLabel;

@property (strong, nonatomic) UILabel *lblAllShipfee;
@property (strong, nonatomic) UILabel *cartlabel;
@property (strong, nonatomic) NSString *jieCount;
@property (strong, nonatomic) NSString *good_id;

-(void)upSuccess;
+(id)sharedUserDefault;

@end
