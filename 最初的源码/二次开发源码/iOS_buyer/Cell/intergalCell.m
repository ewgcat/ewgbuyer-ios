//
//  intergalCell.m
//  My_App
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "intergalCell.h"

@implementation intergalCell

- (void)awakeFromNib {
    // Initialization code
    [_btn1.layer setMasksToBounds:YES];
    [_btn1.layer setCornerRadius:4];
    [_btn2.layer setMasksToBounds:YES];
    [_btn2.layer setCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
