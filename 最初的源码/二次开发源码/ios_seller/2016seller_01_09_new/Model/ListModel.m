//
//  ListModel.m
//  SellerApp
//
//  Created by barney on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        _article_id=value;
    }
    
}
@end
