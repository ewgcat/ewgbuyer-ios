//
//  Chat.m
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Chat.h"

@implementation Chat

//- (void)setDict:(NSDictionary *)dict{
//    
//    _dict = dict;
//    
//    self.icon = dict[@"icon"];
//    self.time = dict[@"time"];
//    self.content = dict[@"content"];
//    self.type = [dict[@"type"] intValue];
//}
+(instancetype)chatWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.addTime = dict[@"addTime"];
        self.content = dict[@"content"];
        self.ID = dict[@"id"];
        self.send_from = dict[@"send_from"];
        self.service_id = dict[@"service_id"];
        self.service_name = dict[@"service_name"];
        self.user_id = dict[@"user_id"];
        self.user_name = dict[@"user_name"];
    }
    return self;
}


@end
