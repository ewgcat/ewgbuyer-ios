//
//  EvaModel.m
//  My_App
//
//  Created by shiyuwudi on 15/11/12.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "EvaModel.h"

@implementation EvaModel

+(instancetype)evaModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
