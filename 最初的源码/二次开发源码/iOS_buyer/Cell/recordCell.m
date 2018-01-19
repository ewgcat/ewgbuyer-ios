//
//  recordCell.m
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "recordCell.h"

@implementation recordCell

- (void)awakeFromNib {
    // Initialization code
    [_rechargeBtn.layer setMasksToBounds:YES];
    [_rechargeBtn.layer setCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
