//
//  ReturnRefundTwoCell.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/15.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ReturnRefundTwoCell.h"

@implementation ReturnRefundTwoCell

- (void)awakeFromNib {
    // Initialization code
    _timeLabel=[LJControl labelFrame:CGRectMake(10, 15,ScreenFrame.size.width/2-10, 40) setText:@"2016-01-07 11:30:45" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X808080) textAlignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:_timeLabel];
    
    _refuseButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/2+10, 15, ScreenFrame.size.width/4-15, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"审核拒绝" setTitleFont:13 setbackgroundColor:UIColorFromRGB(0X4169E1)];
    [_refuseButton.layer setMasksToBounds:YES];
    [_refuseButton.layer  setCornerRadius:6.0];
    [self.bottomView addSubview:_refuseButton];
    
    _adoptButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/4*3+5, 15, ScreenFrame.size.width/4-15, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"审核通过" setTitleFont:13 setbackgroundColor:UIColorFromRGB(0X4169E1)];
    [_adoptButton.layer setMasksToBounds:YES];
    [_adoptButton.layer  setCornerRadius:6.0];
    [self.bottomView addSubview:_adoptButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
