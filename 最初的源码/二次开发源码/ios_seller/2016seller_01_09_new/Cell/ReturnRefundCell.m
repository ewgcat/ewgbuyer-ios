//
//  ReturnRefundCell.m
//  2016seller_01_09_new
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ReturnRefundCell.h"

@implementation ReturnRefundCell
{
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIView *ifView;
    __weak IBOutlet UIView *timeView;

}
- (void)awakeFromNib {
    // Initialization code
    _buyersLabel=[LJControl labelFrame:CGRectMake(10, 10,ScreenFrame.size.width/2-10, 30) setText:@"买家名" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X808080) textAlignment:NSTextAlignmentLeft];
    [titleView addSubview:_buyersLabel];
    
    _orderLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+5, 10,ScreenFrame.size.width/2-10, 30) setText:@"订单号：8888888888888" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xc9c9c9) textAlignment:NSTextAlignmentLeft];
    [titleView addSubview:_orderLabel];
    
    _timeLabel=[LJControl labelFrame:CGRectMake(10, 15,ScreenFrame.size.width/2-10, 40) setText:@"2016-01-07 11:30:45" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X808080) textAlignment:NSTextAlignmentLeft];
    [timeView addSubview:_timeLabel];
    
    _refuseButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/2+10, 15, ScreenFrame.size.width/4-15, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"审核拒绝" setTitleFont:13 setbackgroundColor:UIColorFromRGB(0X4169E1)];
    [_refuseButton.layer setMasksToBounds:YES];
    [_refuseButton.layer  setCornerRadius:6.0];
    [timeView addSubview:_refuseButton];
    
    _adoptButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/4*3+5, 15, ScreenFrame.size.width/4-15, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"审核通过" setTitleFont:13 setbackgroundColor:UIColorFromRGB(0X4169E1)];
    [_adoptButton.layer setMasksToBounds:YES];
    [_adoptButton.layer  setCornerRadius:6.0];
    [timeView addSubview:_adoptButton];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
