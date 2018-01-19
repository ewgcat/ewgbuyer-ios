//
//  WDInputView.h
//  My_App
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDInputView : UIToolbar
- (id)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle leftTarget:(nullable id)leftTarget leftAction:(nullable SEL)leftAction rightTitle:(NSString *)rightTitle rightTarget:(nullable id)rightTarget rightAction:(nullable SEL)rightAction;

@end
