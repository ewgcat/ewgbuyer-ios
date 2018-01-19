//
//  LJControl.m
//  SellerApp
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LJControl.h"

@implementation LJControl
+(UIScrollView *)scrollViewFrame:(CGRect)frame contentSize:(CGSize)contentSize showsVertical:(BOOL)showsVertical showsHorizontal:(BOOL)showsHorizontal paging:(BOOL)enabled canScroll:(BOOL)canScroll{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = frame;
    scrollView.contentSize = contentSize;
    scrollView.showsVerticalScrollIndicator = showsVertical;
    scrollView.showsHorizontalScrollIndicator = showsHorizontal;
    scrollView.pagingEnabled = enabled;
    scrollView.scrollEnabled = canScroll;
    return scrollView;
}
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
+(UIButton *)backBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 15, 23.5);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
//    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    return button;
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
    loadV.backgroundColor=[UIColor grayColor];
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 55, 80, 20)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont systemFontOfSize:11];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=8;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
+(UIView *)MuchView:(CGRect)rect{
    UIView *muchView = [[UIView alloc]initWithFrame:rect];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(126-35, 0, 20, 10)];
    imageView.image = [UIImage imageNamed:@"square"];
    imageView.alpha = 0.8;
    [muchView addSubview:imageView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 126, 200)];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:4];
    [muchView addSubview:view];
    UIImageView *imageViewBig = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 126, 200)];
    imageViewBig.backgroundColor = [UIColor blackColor];
    imageViewBig.alpha = 0.8;
    [view addSubview:imageViewBig];
    NSArray *arr = [NSArray arrayWithObjects:@"首页",@"分类",@"购物车",@"品牌",@"个人中心", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"tabbar1",@"tabbar2",@"tabbar3",@"tabbar4",@"tabbar5", nil];
    for (int i=0; i<5; i++) {
        UILabel *label = [LJControl labelFrame:CGRectMake(45, 0+i*40, 126-45, 40) setText:[arr objectAtIndex:i] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        UIImageView *imageV = [LJControl imageViewFrame:CGRectMake(10, 7+i*40, 26, 26) setImage:[arr2 objectAtIndex:i] setbackgroundColor:[UIColor clearColor]];
        [view addSubview:imageV];
        
        if (i<4) {
            UIImageView *imageV2 = [LJControl imageViewFrame:CGRectMake(0, 40*(i+1), 126, 0.5) setImage:@"" setbackgroundColor:BACKGROUNDCOLOR];
            [view addSubview:imageV2];
        }
    }
    return muchView;
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
+(UIBarButtonItem *)BarButtonItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    return  backItem;
}
+(NSMutableDictionary *)requestHeaderDictionary{
    NSArray *arrObjc;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
    return dicMy;
}
+(id)controllayer:(id)control CornerRadius:(CGFloat)cornerradius boderColor:(UIColor *)color boderWidth:(CGFloat)width{
//    [control.layer setMasksToBounds:YES];
//    [control.layer setCornerRadius:10];
    
    return control;
}
@end
