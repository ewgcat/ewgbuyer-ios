//
//  PaySuccessViewController.h
//  My_App
//
//  Created by shiyuwudi on 15/12/9.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessViewController : UITableViewController

@property (nonatomic,copy)NSString *usernameAndPhone;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *realPrice;
@property (nonatomic, assign)BOOL payOnDel;

@property (nonatomic, strong)NSDictionary *userInfo;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *bigView;

//订单类型
@property (nonatomic, strong)NSString *orderType;

@end
