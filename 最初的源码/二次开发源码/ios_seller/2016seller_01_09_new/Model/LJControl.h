//
//  LJControl.h
//  SellerApp
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJControl : NSObject

+(UIButton *)buttonType:(UIButtonType)type setFrame:(CGRect)frame setNormalImage:(UIImage*)normalimage setSelectedImage:(UIImage*)selectedimage setTitle:(NSString *)title setTitleFont:(NSInteger)titlefont setbackgroundColor:(UIColor *)color;

+(UILabel *)labelFrame:(CGRect)frame setText:(NSString *)text setTitleFont:(NSInteger)titlefont setbackgroundColor:(UIColor *)color setTextColor:(UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment;

+(UIImageView *)imageViewFrame:(CGRect)frame setImage:(NSString *)text setbackgroundColor:(UIColor *)color;

+(UITextField *)textFieldFrame:(CGRect)frame text:(NSString *)text placeText:(NSString *)placetext setfont:(NSInteger)font textColor:(UIColor *)textcolor keyboard:(UIKeyboardType)keyboard;

+(UIView *)viewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundcolor;

+(UITextView *)textViewFrame:(CGRect)frame text:(NSString *)text setfont:(NSInteger)font textColor:(UIColor *)textcolor keyboard:(UIKeyboardType)keyboard;

+(UIView *)loadingView:(CGRect)rect;

+(UIView *)netFaildView;

//
+ (UIView *)refreshView:(CGRect)rect;
+ (void)cleanAll;
@end
