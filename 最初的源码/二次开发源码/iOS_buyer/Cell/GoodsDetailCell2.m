//
//  GoodsDetailCell2.m
//  My_App
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDetailCell2.h"

@implementation GoodsDetailCell2

- (void)awakeFromNib {
    // Initialization code
    
    UILabel *totalQuantity=[LJControl labelFrame:CGRectMake(20, 40,ScreenFrame.size.width/2-60 , 35) setText:@"总限购数量：" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:totalQuantity];
    _totalQuantityLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-40, 40, 40, 35) setText:@"000" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_totalQuantityLabel];
    
    UILabel *availableQuantities=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+20, 40,ScreenFrame.size.width/2-60 , 35) setText:@"可购买数量：" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:availableQuantities];
    _availableQuantitiesLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width-40, 40, 40, 35) setText:@"000" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_availableQuantitiesLabel];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
