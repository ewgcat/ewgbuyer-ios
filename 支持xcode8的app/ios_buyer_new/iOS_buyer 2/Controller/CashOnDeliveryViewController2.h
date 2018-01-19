//
//  CashOnDeliveryViewController2.h
//  My_App
//
//  Created by shiyuwudi on 15/12/8.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashOnDeliveryViewController2 : UIViewController

//订单号，订单ID在创建时被赋值
@property(nonatomic,copy)NSString *orderNum;
@property(nonatomic,copy)NSString *orderID;
@property (nonatomic, assign)CGFloat realPrice;

@end
