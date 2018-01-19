//
//  MyUtil.m
//  MyKitchen
//
//  Created by gaokunpeng on 15/4/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+(UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    if (fontSize) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    return label;
    
}

+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageview.image = [UIImage imageNamed:imageName];
    }
    return imageview;
}

+(UITextField *)createTextFieldFrame:(CGRect)frame placeHolder:(NSString *)placeHolder isPwd:(BOOL)isPwd
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (placeHolder) {
        textField.placeholder = placeHolder;
    }
    if (isPwd) {
        textField.secureTextEntry = YES;
    }
    return textField;
}

+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title image:(NSString *)imageName highlighImage:(NSString *)hightlighImageName selectImage:(NSString *)selectImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.9] forState:UIControlStateNormal];
    }
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (hightlighImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:hightlighImageName] forState:UIControlStateHighlighted];
    }
    if (selectImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+ (NSArray *) returnLocalUserFile
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDone=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDone];
    return fileContent;
}

+(NSMutableDictionary *) createPostData :(NSInteger )beginNum :(NSInteger)selectNum :(NSString *) orderb :(NSString *) ordert :(NSString *) storeID
{
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)beginNum] forKey:@"beginCount"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)selectNum] forKey:@"selectCount"];
    [dict setObject:orderb forKey:@"orderBy"];
    [dict setObject:ordert forKey:@"orderType"];
    [dict setObject:storeID forKey:@"store_id"];
    return dict;
}
@end
