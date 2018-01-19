//
//  CloudPurchaseGoodsModel.h
//  My_App
//
//  Created by barney on 16/2/16.
//  Copyright © 2016年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudPurchaseGoodsModel : NSObject
@property (nonatomic, copy)NSString *primary_photo;
@property (nonatomic, copy)NSString *least_rmb;//1或10
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_price;
@property (nonatomic, copy)NSString *purchased_times;
@property (nonatomic, copy)NSString *purchased_id;
@property (nonatomic, copy)NSString *purchased_left_times;

@property (nonatomic, copy)NSString *period;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *goods_description;
@property (nonatomic, copy)NSString *secondary_photo;
@property (nonatomic, copy)NSString *sell_num;
@property (nonatomic, copy)NSString *pictureID;
@property (nonatomic, copy)NSString *announced_date;
@property (nonatomic, copy)NSString *addTime;

@end
