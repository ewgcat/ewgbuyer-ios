//
//  IntegraDetialViewController.h
//  My_App
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface IntegraDetialViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate>{
    UITableView *shjTableView;
    BOOL scrollBool;
    UIWebView *myWebView;
    
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIView *loadingV;
    
    NSMutableArray *dataArr;
    NSString *ig_user_level;
    NSString *exchange_status;
    UILabel *labelTi;
    NSString *ig_id;
    NSString *integral_id;
    NSString *CountExchange;
    
    ASIFormDataRequest *request102;
    ASIFormDataRequest *request101;
}
@property (strong, nonatomic) UIImageView *ig_goods_img;
@property (strong, nonatomic) UILabel *lblGoodsName;
@property (strong, nonatomic) UILabel *lblIntegraNeeds;
@property (strong, nonatomic) UILabel *lblGoodsPrice;
@property (strong, nonatomic) UILabel *lblShelvesTime;
@property (strong, nonatomic) UILabel *lblLimitCount;
@property (strong, nonatomic) UILabel *lblClassNeeds;
@property (strong, nonatomic) UILabel *lblMyClass;
@property (strong, nonatomic) UILabel *lblMyIntegral;
@property (strong, nonatomic) UILabel *lblTransfee;
@property (strong, nonatomic) UILabel *lblGoodsCount;
@property (strong, nonatomic) UILabel *lblLimitCountChoose;
@property (strong, nonatomic) UITextField *countField;
@property (strong, nonatomic) UIButton *btnMinus;
@property (strong, nonatomic) UIButton *btnAdd;
@property (strong, nonatomic) NSString *totalIntegral;
@property (strong, nonatomic) NSString *limitCountChoose;
@property (strong, nonatomic) NSString *userLevel;



@end
