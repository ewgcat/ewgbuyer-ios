//
//  TSModel.h
//  My_App
//
//  Created by barney on 15/11/24.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSModel : NSObject
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_img;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *goods_gsp_ids;
@property (nonatomic, copy)NSString *oid;
@property (nonatomic, copy)NSArray *goods_maps;

//@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *store_name;

//+(instancetype)TSModelWithDict:(NSDictionary *)dict;
@end
