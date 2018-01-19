//
//  ReturnModel.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "BaseModel.h"

@interface ReturnModel : BaseModel

@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *order_form_id;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *goods_mainphoto_path;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *return_goods_id;
@property (nonatomic, copy)NSString *goods_return_status;



@end
