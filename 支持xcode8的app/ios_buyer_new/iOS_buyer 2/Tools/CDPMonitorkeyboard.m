//
//  CDPMonitorkeyboard.m
//  JianPantongzhi
//
//  Created by KVC on 15-5-15.
//  Copyright (c) 2015年 Cui Yan. All rights reserved.
//

#import "CDPMonitorkeyboard.h"
static CDPMonitorkeyboard* monitorKeyboard;

@implementation CDPMonitorkeyboard
//当前对象只创建一次，单例模式
//建立的对象，所有键盘的处理都有这个对象进行
+(CDPMonitorkeyboard*)defaultMonitorKeyboard{
    if(!monitorKeyboard){
        monitorKeyboard=[[self alloc]init];
    }
    return monitorKeyboard;
}
-(void)keyboardWillShowWithSuperView:(UIView*)superView
                     andNotification:(NSNotification*)notification higerTanKeyboard:(NSInteger)valueOfTheHiger{
    _superView=superView;
 _superViewOldFrame=superView.frame;
    NSDictionary *userInfo=[notification userInfo];
    NSLog(@"userInsfo=%@",userInfo);
    NSValue *aValue=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    NSInteger keyHIGHT=keyboardRect.size.height;
    for (UIView *view in superView.subviews) {
        if (view.isFirstResponder==YES) {
            NSInteger winHeight=superView.bounds.size.height;
            NSInteger ViewYPoint=view.frame.origin.y;
            NSInteger ViewHeight=view.bounds.size.height;
            NSInteger SYHeight=winHeight-ViewYPoint-ViewHeight;
            if (SYHeight<keyHIGHT) {
                [UIView animateWithDuration:0.3 animations:^{
                    superView.frame=CGRectMake(0, SYHeight-keyHIGHT, superView.bounds.size.width, superView.bounds.size.height);
                }];
            }
        }
    }
    }
-(void)keyboardWillHide{
  [UIView animateWithDuration:0.3 animations:^{
      _superView.frame=_superViewOldFrame;
  }];
}
@end
