//
//  ConsultModel.m
//  My_App
//
//  Created by shiyuwudi on 15/11/26.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "ConsultModel.h"

@implementation ConsultModel

+(instancetype)consultModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        _goods_main_photo = dict[@"goods_main_photo"];
        _goods_name = dict[@"goods_name"];
        _goods_id = dict[@"goods_id"];
        _goods_price = dict[@"goods_price"];
        _addTime = dict[@"addTime"];
        _content = dict[@"content"];
        _goods_domainPath = dict[@"goods_domainPath"];
        _reply_content = dict[@"reply_content"];
        _reply_user = dict[@"reply_user"];
        _reply_time = dict[@"reply_time"];
    }
    return self;
}

@end
