//
//  ReceiveSuccessCell.m
//  My_App
//
//  Created by apple on 15/10/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ReceiveSuccessCell.h"

@implementation ReceiveSuccessCell

- (void)awakeFromNib {
    // Initialization code
    [_UseBtn.layer setMasksToBounds:YES];
    [_UseBtn.layer setCornerRadius:4];
    _UseBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _UseBtn.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
