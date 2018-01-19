//
//  StockWarningModel.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface StockWarningModel : BaseModel

@property (nonatomic, copy)NSNumber *goods_id;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSNumber *goods_warn_inventory;
@property (nonatomic, copy)NSString *main_photo;

//+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
