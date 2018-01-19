//
//  NSAttributedString+Range.m
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "NSAttributedString+Range.h"

@implementation NSAttributedString (Range)

+(instancetype)stringWithFullStr:(NSString *)full attributedPart:(NSString *)part attribute:(NSDictionary *)attribute{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:full];
    if (!part) {
        return str;
    }
    NSRange range = [full rangeOfString:part];
    [str addAttributes:attribute range:range];
    return str;
}

@end
