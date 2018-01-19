//
//  UIView+setFrame.h
//  SellerApp
//
//  Created by barney on 15/12/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (setFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

- (void)setLeft:(CGFloat)x;
- (void)setTop:(CGFloat)y;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

@end
