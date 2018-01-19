//
//  ConsultModel.h
//  My_App
//
//  Created by shiyuwudi on 15/11/26.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultModel : NSObject

@property (nonatomic, copy)NSString *goods_main_photo;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *goods_price;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *goods_domainPath;

@property (nonatomic, copy)NSString *reply_content;
@property (nonatomic, copy)NSString *reply_user;
@property (nonatomic, copy)NSString *reply_time;

+(instancetype)consultModelWithDict:(NSDictionary *)dict;

@end
