//
//  searchViewController.h
//  SellerApp
//
//  Created by apple on 15-4-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *orderlist_tableview;
    
   // UILabel *label_prompt;//提示label
   // UIView *loadingV;//正在加载视图
    NSMutableArray *orderlist_Array;
    
    UILabel *over_label;//已完成
    UILabel *All_label;//全部
    UILabel *sendGoods_label;//已发货
    UILabel *waitGoods_label;//等待发货
    UILabel *waitMoney_label;//等待付款
    
    UITextField *MyTextField;
}

@end
