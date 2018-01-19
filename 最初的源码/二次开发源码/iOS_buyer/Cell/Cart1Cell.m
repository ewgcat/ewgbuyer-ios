//
//  Cart1Cell.m
//  My_App
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Cart1Cell.h"

@implementation Cart1Cell

- (void)awakeFromNib {
    // Initialization code
    _pictureImageView.layer.borderWidth = 0.5;
    _pictureImageView.layer.borderColor = [UIColorFromRGB(0xd7d7d7) CGColor];
    
    _minusButton.layer.borderWidth = 1;
    _minusButton.layer.borderColor = [UIColorFromRGB(0Xcecece) CGColor];
    
    _plusButton.layer.borderWidth = 1;
    _plusButton.layer.borderColor = [UIColorFromRGB(0Xcecece) CGColor];

    _numericalTextField.layer.borderWidth = 1;
    _numericalTextField.layer.borderColor = [UIColorFromRGB(0Xcecece) CGColor];
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"确定" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [_numericalTextField setInputAccessoryView:inputView];
    
    _markImageView.hidden=YES;
    _markbgImageView.hidden=YES;
    
    
}
-(void)dismissKeyBoard{
    [_numericalTextField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
