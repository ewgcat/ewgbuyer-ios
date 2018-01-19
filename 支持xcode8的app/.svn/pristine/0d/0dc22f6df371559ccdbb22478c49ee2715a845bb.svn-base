//
//  ExchangeListViewController.h
//  My_App
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"

@interface ExchangeListViewController : UIViewController<ASIHTTPRequestDelegate,UITextViewDelegate>{
//    UILabel *labelTi;
//    UIView *loadingV;
    
    NSString *area;
    
    UILabel *labeltext;
    NSString *igo_msg;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
}


@property (strong, nonatomic) UIImageView *imgAddBG;
@property (strong, nonatomic) UIImageView *imgAddrBG2;
@property (strong, nonatomic) UILabel *personAddress;
@property (strong, nonatomic) UILabel *lblTitleMes;
@property (strong, nonatomic) UILabel *lblArea;
@property (strong, nonatomic) UILabel *lblUserName;
@property (strong, nonatomic) UILabel *lblPhone;
@property (strong, nonatomic) UITextView *messField;

@property (strong, nonatomic) UILabel *lblIntegrals;
@property (strong, nonatomic) UILabel *lblTransfee;

//商品金额的数字
@property (strong, nonatomic) UILabel *goodCountLabel;

//订单总金额的数字
@property (strong, nonatomic) UILabel *orderCountLabel;

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *order_sn;
@property (assign, nonatomic) BOOL myBool;
+(id)sharedUserDefault;
@end
