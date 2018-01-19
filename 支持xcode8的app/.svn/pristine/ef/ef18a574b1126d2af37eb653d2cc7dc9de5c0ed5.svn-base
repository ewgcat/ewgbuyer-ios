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
@property (strong, nonatomic) UILabel *lblAllShipfee;
@property (strong, nonatomic) UILabel *cartlabel;
@property (strong, nonatomic) NSString *jieCount;
@property (strong, nonatomic) NSString *good_id;

-(void)upSuccess;
+(id)sharedUserDefault;

@end
