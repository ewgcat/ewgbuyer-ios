//
//  goodsModel.m
//  SellerApp
//
//  Created by barney on 16/1/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "goodsModel.h"

@implementation goodsModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        _goods_id=value;
    }
    
}
@end
