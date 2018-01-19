//
//  WDInputView.m
//  My_App
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WDInputView.h"

@implementation WDInputView
/*
 UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34)];
 [topView setBarStyle:UIBarStyleDefault];
 topView.backgroundColor=UIColorFromRGB(0xf0f1f2);
 UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
 [helloButton setTintColor:UIColorFromRGB(0x848689)];
 UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
 UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
 [doneButton setTintColor:UIColorFromRGB(0xf15353)];
 NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
 [topView setItems:buttonsArray];
 [myTextView setInputAccessoryView:topView];
 
 */

- (id)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle leftTarget:(nullable id)leftTarget leftAction:(nullable SEL)leftAction rightTitle:(NSString *)rightTitle rightTarget:(nullable id)rightTarget rightAction:(nullable SEL)rightAction{
    self = [super initWithFrame:frame];
    if (self) {
        self = (WDInputView *)[[UIToolbar alloc]initWithFrame:frame];
        [self setBarStyle:UIBarStyleDefault];
        self.backgroundColor=UIColorFromRGB(0xf0f1f2);
        
        UIBarButtonItem * helloButton;
        if (leftTitle.length>0) {
            helloButton = [[UIBarButtonItem alloc]initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:leftTarget action:leftAction];
            [helloButton setTintColor:UIColorFromRGB(0x848689)];
        }else{
            helloButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:leftTarget action:nil];
        }
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *doneButton;
        if (rightTitle.length>0) {
            doneButton = [[UIBarButtonItem alloc]initWithTitle:rightTitle style:UIBarButtonItemStyleDone target:rightTarget action:rightAction];
            [doneButton setTintColor:UIColorFromRGB(0xf15353)];
        }else{
            doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:rightTarget action:nil];
        }
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [self setItems:buttonsArray];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    // Drawing code
}
@end
