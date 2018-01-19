//
//  orderCell.m
//  My_App
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "orderCell.h"

@implementation orderCell

- (void)awakeFromNib {
    // Initialization code
    [_btn.layer setMasksToBounds:YES];
    [_btn.layer setCornerRadius:4];
    _btn.layer.borderColor = [RGB_COLOR(241, 83, 83) CGColor];
    _btn.layer.borderWidth = 0.5;
    
    [_otherBtn.layer setMasksToBounds:YES];
    [_otherBtn.layer setCornerRadius:4];
    _otherBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _otherBtn.layer.borderWidth = 0.5;
}
-(void)setOtherBtnToActive{
    _otherBtn.layer.borderColor = [RGB_COLOR(241, 83, 83) CGColor];
    [_otherBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
