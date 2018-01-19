//
//  Cart4Cell.m
//  My_App
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Cart4Cell.h"

@implementation Cart4Cell

- (void)awakeFromNib {
    // Initialization code
    _pictureImageView.layer.borderWidth = 0.5;
    _pictureImageView.layer.borderColor = [UIColorFromRGB(0xd7d7d7) CGColor];
    _lineH.constant=0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
