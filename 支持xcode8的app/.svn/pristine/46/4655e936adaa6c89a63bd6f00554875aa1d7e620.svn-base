//
//  Parser.h
//  My_App
//
//  Created by shiyuwudi on 16/2/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+(id)parse:(NSDictionary *)dict;
+(BOOL)parseBool:(NSDictionary *)dict;//需要有特殊返回值就可以断定成功的情况
+(NSArray *)parseArray:(NSDictionary *)dict model:(NSString *)className;//解析成模型数组
+(BOOL)validModel:(id)model;//验证模型中的属性是否全部被赋值(非空)

@end
