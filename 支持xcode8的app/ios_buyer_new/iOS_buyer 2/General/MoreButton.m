//
//  MoreButton.m
//  My_App
//
//  Created by shiyuwudi on 15/12/21.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "MoreButton.h"

@implementation MoreButton

static CGFloat space = 10.f;
static CGFloat imgW = 20.f;

+(instancetype)moreButtonWithTitle:(NSString *)title imageName:(NSString *)imageName{
    MoreButton *mBtn = [[MoreButton alloc]init];
    [mBtn setTitle:title forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:imageName];
    [mBtn setImage:img forState:UIControlStateNormal];
    UIColor *color = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [mBtn setBackgroundColor:color];
    return mBtn;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat x = 2 * space + imgW;
    CGFloat x = (contentRect.size.width-imgW-space-40)*0.5+imgW+space+2;
    CGFloat y = 0.f;
//    CGFloat w = contentRect.size.width - 3 * space - imgW;
    CGFloat w = 40;
    CGFloat h = contentRect.size.height;
    CGRect frame = CGRectMake(x, y, w, h);
    return frame;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat bh = contentRect.size.height;
//    CGFloat x = space;
    CGFloat x = (contentRect.size.width-imgW-space-40)*0.5+2;
    CGFloat y = (bh - imgW) * 0.5;
    CGFloat w = imgW;
    CGFloat h = imgW;
    CGRect frame = CGRectMake(x, y, w, h);
    return frame;
}

@end
