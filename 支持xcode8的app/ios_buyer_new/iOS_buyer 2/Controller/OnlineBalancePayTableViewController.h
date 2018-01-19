//
//  OnlineBalancePayTableViewController.h
//  My_App
//
//  Created by shiyuwudi on 15/12/7.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineBalancePayTableViewController : UITableViewController<ASIHTTPRequestDelegate>

@property (assign, nonatomic)BOOL group;
@property (assign, nonatomic)BOOL group1;
@property (copy, nonatomic)NSString *oid;

@property(nonatomic,strong)NSString *orderType;
@property (weak, nonatomic) IBOutlet UITextField *canPayMoneyTF;

//支付方式的数组
@property (nonatomic,strong) NSArray *payStyleArr;
@end
