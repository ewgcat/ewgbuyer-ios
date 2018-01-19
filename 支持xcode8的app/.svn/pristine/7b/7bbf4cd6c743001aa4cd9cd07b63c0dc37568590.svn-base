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

+(UIScrollView *)scrollViewFrame:(CGRect)frame contentSize:(CGSize)contentSize showsVertical:(BOOL)showsVertical showsHorizontal:(BOOL)showsHorizontal paging:(BOOL)enabled canScroll:(BOOL)canScroll;
//正在加载
+(UIView *)loadingView:(CGRect)rect;

//网络请求失败
+(UIView *)netFaildView;
//返回按钮
+(UIButton *)backBtn;
//更多view
+(UIView *)MuchView:(CGRect)rect;
//圆角、边框
+(id)controllayer:(id)control CornerRadius:(CGFloat)cornerradius boderColor:(UIColor *)color boderWidth:(CGFloat)width;
+(UIBarButtonItem *)BarButtonItem;
+ (UIView *)refreshView:(CGRect)rect;
+(NSMutableDictionary *)requestHeaderDictionary;
@end
