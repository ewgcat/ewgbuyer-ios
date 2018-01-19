//
//  CityModel.m
//  My_App
//
//  Created by shiyuwudi on 15/11/19.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _cID=value;
    }else  if ([key isEqualToString:@"name"]) {
        _cName=value;
    }
    
}
@end
