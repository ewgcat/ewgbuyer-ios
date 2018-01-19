//
//  OrderlistViewController.h
//  SellerApp
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderlistViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
//    PullToRefreshTableView *orderlist_tableview;
    UITableView *orderlist_tableview;
    BOOL requestBool;//请求bool
    
//    UILabel *label_prompt;//提示label
//    UIView *loadingV;//正在加载视图
    UIView *faildV;//加载失败视图
    NSMutableArray *orderlist_Array;
    NSMutableArray *orderlistPull_Array;
    
    NSString *order_status;//订单状态
    BOOL btnClickedBool;
    
    UISegmentedControl *MysegmentControl;
}

@property (retain,nonatomic)NSString *order_id;
@property (retain,nonatomic)NSString *order_num;
@property (retain,nonatomic)NSString *good_id;
@property (assign,nonatomic)NSInteger labelTag;
+(id)sharedUserDefault;

@end
