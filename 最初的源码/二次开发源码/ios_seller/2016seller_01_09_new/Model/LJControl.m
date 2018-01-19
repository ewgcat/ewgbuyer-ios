//
//  LJControl.m
//  SellerApp
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LJControl.h"
#import "sqlService.h"

@implementation LJControl
+(UIButton *)buttonType:(UIButtonType)type setFrame:(CGRect)frame setNormalImage:(UIImage*)normalimage setSelectedImage:(UIImage*)selectedimage setTitle:(NSString *)title setTitleFont:(NSInteger)titlefont setbackgroundColor:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:normalimage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedimage forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:titlefont];
    button.backgroundColor = color;
    return button;
}
+(UILabel *)labelFrame:(CGRect)frame setText:(NSString *)text setTitleFont:(NSInteger)titlefont setbackgroundColor:(UIColor *)color setTextColor:(UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textcolor;
    label.backgroundColor = color;
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:titlefont];
    return label;
}
+(UIImageView *)imageViewFrame:(CGRect)frame setImage:(NSString *)text setbackgroundColor:(UIColor *)color{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
    imageview.image = [UIImage imageNamed:text];
    imageview.backgroundColor = color;
    return imageview;
}
+(UITextField *)textFieldFrame:(CGRect)frame text:(NSString *)text placeText:(NSString *)placetext setfont:(NSInteger)font textColor:(UIColor *)textcolor keyboard:(UIKeyboardType)keyboard{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.textColor = textcolor;
    textField.font = [UIFont systemFontOfSize:font];
    textField.keyboardType = keyboard;
    textField.placeholder = placetext;
    return textField;
}
+(UIView *)viewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundcolor{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundcolor;
    return view;
}
+(UITextView *)textViewFrame:(CGRect)frame text:(NSString *)text setfont:(NSInteger)font textColor:(UIColor *)textcolor keyboard:(UIKeyboardType)keyboard{
    UITextView *textField = [[UITextView alloc]initWithFrame:frame];
    textField.text = text;
    textField.textColor = textcolor;
    textField.font = [UIFont systemFontOfSize:font];
    textField.keyboardType = keyboard;
    return textField;
}

+(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.frame = CGRectMake(30, 20, 40, 40);
    [activityIndicatorV startAnimating];
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont systemFontOfSize:14];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
+(UIView *)netFaildView{
    UIView *faildView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    faildView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, 160, 100, 100)];
    image.image = [UIImage imageNamed:@"wifi"];
    [faildView addSubview:image];
    
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 325, faildView.frame.size.width, 20)];
    la.text=@"亲，您的手机网络不太顺畅哦~";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor darkGrayColor];
    la.font=[UIFont systemFontOfSize:17];
    [faildView addSubview:la];
    
    return faildView;
}
+ (UIView *)refreshView:(CGRect)rect
{
    UIView * refreshV = [[UIView alloc]initWithFrame:rect];
    UIView *faildView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    refreshV.backgroundColor=[UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, 160, 100, 100)];
    image.image = [UIImage imageNamed:@"wifi"];
    [refreshV addSubview:image];
    
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 325, faildView.frame.size.width, 20)];
    la.text=@"亲，您的手机网络不太顺畅哦~";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor darkGrayColor];
    la.font=[UIFont systemFontOfSize:17];
    [refreshV addSubview:la];
    
    return refreshV;
}
+ (void)cleanAll{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"user_information.txt"];
    BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
    if (bRet2) {
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
                [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            }
        }
//        [self performSelectorOnMainThread:@selector(clearCacheSuccessOut) withObject:nil waitUntilDone:YES];
    });
    
    sqlService *del = [[sqlService alloc]init];
    if ([del deleteChatList]) {
        NSLog(@"成功删除22");
    }else{
        NSLog(@"删除失败11");
    }
}
@end
