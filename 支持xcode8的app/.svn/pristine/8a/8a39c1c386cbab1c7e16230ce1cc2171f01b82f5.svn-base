//
//  LeftRightButton.m
//  SellerApp
//
//  Created by barney on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LeftRightButton.h"

@interface LeftRightButton ()

@property (nonatomic, assign)IBInspectable CGFloat imgWidth;
@property (nonatomic, assign)IBInspectable CGFloat imgHeight;
@property (nonatomic, assign)IBInspectable CGFloat midXRatio;
@property (nonatomic, assign)IBInspectable CGFloat midSpace;

@end

@implementation LeftRightButton

+(instancetype)leftRightButtonWithImageName:(NSString *)imgName title:(NSString *)title frame:(CGRect)frame{
    LeftRightButton *lfb = [[LeftRightButton alloc]init];
    UIImage *img = [UIImage imageNamed:imgName];
    [lfb setImage:img forState:UIControlStateNormal];
    [lfb setTitle:title forState:UIControlStateNormal];
    [lfb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lfb.titleLabel.textAlignment = NSTextAlignmentLeft;
    lfb.frame = frame;
    return lfb;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat x = _midXRatio * contentRect.size.width + _midSpace;
    CGFloat y = 0;
    CGFloat w = (1 - _midXRatio) * contentRect.size.width - _midSpace;
    CGFloat h = contentRect.size.height;
    CGRect titleRect = CGRectMake(x, y, w, h);
    return titleRect;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = _midXRatio * contentRect.size.width - _imgWidth - _midSpace;
    CGFloat y = 0.5 * (contentRect.size.height - _imgHeight);
    CGFloat w = _imgWidth;
    CGFloat h =  _imgHeight;
    CGRect imgRect = CGRectMake(x, y, w, h);
    return imgRect;
}



@end
