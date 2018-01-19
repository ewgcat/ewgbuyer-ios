//
//  normalGoodsEvaluationCell.m
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "normalGoodsEvaluationCell.h"

@implementation normalGoodsEvaluationCell

- (void)awakeFromNib {
    // Initialization code
    _labelContent = [LJControl labelFrame:CGRectMake(15, 50, ScreenFrame.size.width-30, 30) setText:@"" setTitleFont:16 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    _labelContent.numberOfLines = 0;
    [self addSubview:_labelContent];
    _labelspec = [LJControl labelFrame:CGRectMake(15, _labelContent.frame.size.height+_labelContent.frame.origin.y, ScreenFrame.size.width-30, 30) setText:@"" setTitleFont:11 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    _labelspec.numberOfLines = 0;
    [self addSubview:_labelspec];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
