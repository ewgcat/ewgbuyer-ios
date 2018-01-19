//
//  LoginViewController.h
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSString *name;
    NSString *level_name;
    NSString *coupon;
    NSString *balance;
    NSString *photo_url;
    NSString *integral;
    NSString *favoutite_goods_count;
    NSString *favoutite_store_count;
    NSString *footPoint_count;


//是否体验会员的字段
    NSString *vip_experience;
    NSString *timeString;

    __weak IBOutlet UIView *navImage;
    
  
}

@property(assign, nonatomic) BOOL logBool;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

//退货管理
@property (strong, nonatomic) NSString *return_goods_id;
@property (strong, nonatomic) NSString *return_oid;
@property (strong, nonatomic) NSString *return_gsp_ids;
////
@property (strong, nonatomic) NSString *return_goods_count;
@property (strong, nonatomic) NSString *return_goods_price;
@property (strong, nonatomic) NSString *return_ImagePhoto;
@property (strong, nonatomic) NSString *return_Name;

@property (assign, nonatomic) NSInteger orderTag;

@property (assign, nonatomic) BOOL return_CancelBool;

@property (strong, nonatomic) NSString *return_group_id;
@property (strong, nonatomic) NSString *return_group_ImagePhoto;
@property (strong, nonatomic) NSString *return_group_Name;
@property (strong, nonatomic) NSString *return_group_Code;


@property (strong, nonatomic) NSString *lifeGroup_oid;

+(id)sharedUserDefault;//刷新登录页面弹出个人中心
-(void)logOut;
-(void)setPassword;

@end
