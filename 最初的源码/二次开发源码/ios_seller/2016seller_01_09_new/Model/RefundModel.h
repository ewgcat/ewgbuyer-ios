//
//  RefundModel.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface RefundModel : BaseModel

@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *order_form_id;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *refund_price;
@property (nonatomic, copy)NSString *audit_date;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *apply_form_id;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_main_photo;
@property (nonatomic, copy)NSString *status;

@end
