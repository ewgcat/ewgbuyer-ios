//
//  BlackbottomView.m
//  My_App
//
//  Created by 邱炯辉 on 16/9/14.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "BlackbottomView.h"

@implementation BlackbottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float width=ScreenFrame.size.width/3;
        //没有登录的承载视图
        _unlogedView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, frame.size.height)];
        [self addSubview:_unlogedView];
        NSArray *titles=@[@"关注的商品",@"关注的店铺",@"足迹"];
        for (int i=0; i<3; i++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 0, width, frame.size.height)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:13];
            label.text=titles[i];
            label.textColor=[UIColor whiteColor];
            [_unlogedView addSubview:label];
            
        }
        
        //登录后的承载视图,未完成的
        
        _logedView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, frame.size.height)];
        [self addSubview:_logedView];
        
        _labelcount1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 23)];
        _labelcount1.textAlignment=NSTextAlignmentCenter;
        _labelcount1.font=[UIFont systemFontOfSize:11];
        _labelcount1.textColor=[UIColor whiteColor];

        [_logedView addSubview:_labelcount1];
        
        
        _labelcount2=[[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, 23)];
        _labelcount2.textAlignment=NSTextAlignmentCenter;
        _labelcount2.font=[UIFont systemFontOfSize:11];
        _labelcount2.textColor=[UIColor whiteColor];

        [_logedView addSubview:_labelcount2];
        
        
        _labelcount3=[[UILabel alloc]initWithFrame:CGRectMake(width*2, 0, width, 23)];
        _labelcount3.textAlignment=NSTextAlignmentCenter;
        _labelcount3.font=[UIFont systemFontOfSize:11];
        _labelcount3.textColor=[UIColor whiteColor];

        [_logedView addSubview:_labelcount3];
        
        //添加底部的按钮
        
        _button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 47)];
        [_logedView addSubview:_button1];
        
        _button2=[[UIButton alloc]initWithFrame:CGRectMake(width, 0, width, 47)];
        [_logedView addSubview:_button2];
        
        
        _button3=[[UIButton alloc]initWithFrame:CGRectMake(width*2, 0, width, 47)];
        [_logedView addSubview:_button3];
        
        
        
        for (int i=0; i<3; i++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 23, width,23)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:11];
            label.text=titles[i];
            label.textColor=[UIColor whiteColor];
            [_logedView addSubview:label];
            
        }
        
    }
    return self;
}

@end
