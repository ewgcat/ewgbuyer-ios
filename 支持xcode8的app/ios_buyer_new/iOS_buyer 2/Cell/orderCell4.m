//
//  orderCell4.m
//  My_App
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 ap1ple. All rights reserved.
//

#import "orderCell4.h"

@implementation orderCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_btn.layer setMasksToBounds:YES];
    [_btn.layer setCornerRadius:2];
    _btn.layer.borderColor = [UIColorFromRGB(0Xdb2222) CGColor];
    _btn.layer.borderWidth = 0.5;
    
    [_otherBtn.layer setMasksToBounds:YES];
    [_otherBtn.layer setCornerRadius:2];
    _otherBtn.layer.borderColor = [UIColorFromRGB(0Xbababa) CGColor];
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
