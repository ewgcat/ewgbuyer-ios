//
//  BaseModel.m
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+(instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
