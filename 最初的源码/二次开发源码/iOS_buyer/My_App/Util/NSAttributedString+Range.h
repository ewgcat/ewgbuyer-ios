//
//  NSAttributedString+Range.h
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Range)

+(instancetype)stringWithFullStr:(NSString *)full attributedPart:(NSString *)part attribute:(NSDictionary *)attribute;

@end
