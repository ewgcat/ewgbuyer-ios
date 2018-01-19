//
//  Chat.h
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    
//    ChatTypeMe = 0, // 自己发的
//    ChatTypeOther = 1 //别人发得
//    
//} ChatType;

@interface Chat : NSObject

@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *send_from;
@property (nonatomic, copy)NSString *service_id;
@property (nonatomic, copy)NSString *service_name;
@property (nonatomic, strong)NSNumber *user_id;
@property (nonatomic, copy)NSString *user_name;

+(instancetype)chatWithDict:(NSDictionary *)dict;

@end
