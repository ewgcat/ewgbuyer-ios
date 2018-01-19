//
//  Chat.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Chat.h"

@implementation Chat

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.icon = dict[@"icon"];
    self.time = dict[@"time"];
    self.content = dict[@"content"];
    self.type = [dict[@"type"] intValue];
}


@end
