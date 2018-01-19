//
//  Model.h
//  SellerApp
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

//订单列表
@property (retain,nonatomic) NSString *addTime;
@property (retain,nonatomic) NSString *order_id;
@property (retain,nonatomic) NSString *order_num;
@property (retain,nonatomic) NSString *order_type;
@property (retain,nonatomic) NSString *payment;
@property (retain,nonatomic) NSArray *photo_list;
@property (retain,nonatomic) NSString *ship_price;
@property (retain,nonatomic) NSString *totalPrice;
@property (retain,nonatomic) NSArray *name_list;
@property (retain,nonatomic) NSString *order_status;

@property (retain,nonatomic) NSString *coupon_price;
@property (retain,nonatomic) NSString *goods_price;
@property (retain,nonatomic) NSString *invoice;
@property (retain,nonatomic) NSString *invoiceType;
@property (retain,nonatomic) NSString *payTime;
@property (retain,nonatomic) NSString *payType;
@property (retain,nonatomic) NSString *receiver_Name;
@property (retain,nonatomic) NSString *receiver_area;
@property (retain,nonatomic) NSString *receiver_area_info;
@property (retain,nonatomic) NSString *receiver_mobile;
@property (retain,nonatomic) NSString *receiver_telephone;
@property (retain,nonatomic) NSString *receiver_zip;
@property (retain,nonatomic) NSString *reduce_amount;
@property (retain,nonatomic) NSArray *trans_list;
@property (retain,nonatomic) NSString *sendTime;
@property (retain,nonatomic) NSString *company;

@property (retain,nonatomic) NSString *goods_inventory;
@property (retain,nonatomic) NSString *goods_name;
@property (retain,nonatomic) NSString *goods_main_photo;
@property (retain,nonatomic) NSString *goods_salenum;
@property (retain,nonatomic) NSString *goods_id;
@property (retain,nonatomic) NSString *goods_recommend;
@property (retain,nonatomic) NSArray *goods_specs_info;


@property (retain,nonatomic) NSString *user_id;
@property (retain,nonatomic) NSString *user_name;

//账单
@property (retain,nonatomic) NSString *apply_time;
@property (retain,nonatomic) NSString *commission_amount;
@property (retain,nonatomic) NSString *complete_time;
@property (retain,nonatomic) NSString *o_id;
@property (retain,nonatomic) NSString *order_total_price;
@property (retain,nonatomic) NSString *payoff_remark;
@property (retain,nonatomic) NSString *payoff_type;
@property (retain,nonatomic) NSString *pl_info;
@property (retain,nonatomic) NSString *pl_sn;
@property (retain,nonatomic) NSString *reality_amount;
@property (retain,nonatomic) NSString *total_amount;

@end
