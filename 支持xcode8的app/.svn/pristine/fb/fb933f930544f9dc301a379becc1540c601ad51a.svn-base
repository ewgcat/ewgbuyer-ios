//
//  Parser.m
//  My_App
//
//  Created by shiyuwudi on 16/2/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "Parser.h"

static NSString *successString = @"SUCCESS";


static int nonNullCode = 10000;//有数据
static int emptyCode = 10002;//无数据

static int cartDeleteSuccessCode = 70001;//购物车删除成功
static int cartModifySuccessCode = 70003;//购物车数量调整成功

@implementation Parser

+(id)parse:(NSDictionary *)dict{
    
    int code = [dict[@"code"] intValue];
    NSObject *obj = nil;
    
    if (![dict[@"result"] isEqualToString:successString]){
        
    } else if (code == emptyCode) {
        
    }
    
    return obj;
}

+(BOOL)parseBool:(NSDictionary *)dict {
    int code = [dict[@"code"] intValue];
    
    if (![dict[@"result"] isEqualToString:successString]){
        return false;
    } else if (code == cartDeleteSuccessCode) {
        return true;
    } else if (code == cartModifySuccessCode){
        return true;
    }
    return false;
}

+(NSArray *)parseArray:(NSDictionary *)dict model:(NSString *)className{
    Class cla = NSClassFromString(className);
    int code = [dict[@"code"] intValue];
    if (![dict[@"result"] isEqualToString:successString]){
        return nil;
    } else if (code == nonNullCode) {
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            id obj = [cla yy_modelWithDictionary:dict1];
            [tempArr addObject:obj];
        }
        return tempArr;
    }
    
    
    return nil;
}

+(BOOL)validModel:(id)model {
    
    unsigned int count = 0;
    unsigned int nullCount = 0;
    Ivar *ivars = class_copyIvarList([model class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        id obj = object_getIvar(model, ivar);
        if (obj == nil) {
            NSLog(@"%@->%s没有赋值", model, ivar_getName(ivar));
            nullCount += 1;
        }
    }
    return nullCount == 0;
}

@end
