//
//  Chat.h
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ChatTypeMe = 0, // 自己发的
    ChatTypeOther = 1 //别人发得
    
} ChatType;

@interface Chat : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) ChatType type;

@property (nonatomic, copy) NSDictionary *dict;

@end
