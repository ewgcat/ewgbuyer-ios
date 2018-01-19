//
//  WaitForEvaluateCell.m
//  My_App
//
//  Created by shiyuwudi on 15/11/30.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "WaitForEvaluateCell.h"

@implementation WaitForEvaluateCell

- (void)awakeFromNib {
    // Initialization code
    self.button.layer.cornerRadius = 5.f;
    [self.button.layer setMasksToBounds:YES];
    self.button.layer.borderColor = [UIColorFromRGB(0xf15353) CGColor];
    self.button.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
