//
//  UIImage+Scale.m
//  ISkyShopTest01
//
//  Created by wzs on 15/9/21.
//  Copyright (c) 2015年 cy. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
+(UIImage*)imageWithOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGRect rect=CGRectZero;
    rect.size=size;
    [image drawInRect:rect];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

