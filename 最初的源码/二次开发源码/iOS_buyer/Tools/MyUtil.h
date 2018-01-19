//
//  MyUtil.h
//  MyKitchen
//
//  Created by gaokunpeng on 15/4/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BACKGROUND_COLOR (@"0XF5F5F5")
#define BORDER_COLOR (@"0XDCDCDC")
/*
 封装的快速创建基本视图控件的类型
 */

@interface MyUtil : NSObject

+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment fontSize:(CGFloat)fontSize;

+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

+ (UITextField *)createTextFieldFrame:(CGRect)frame placeHolder:(NSString *)placeHolder isPwd:(BOOL)isPwd;

+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title image:(NSString *)imageName highlighImage:(NSString *)hightlighImageName selectImage:(NSString *)selectImageName target:(id)target action:(SEL)action;
// 返回本地存储的文件数组
+ (NSArray *) returnLocalUserFile;
// 返回字典，post请求店铺首页全部商品需要回传的参数
+(NSMutableDictionary *) createPostData :(NSInteger )beginNum :(NSInteger)selectNum :(NSString *) orderb :(NSString *) ordert :(NSString *) storeID;

@end
