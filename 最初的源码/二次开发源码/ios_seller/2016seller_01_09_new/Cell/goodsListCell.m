//
//  goodsListCell.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "goodsListCell.h"

@implementation goodsListCell

- (void)awakeFromNib {
    // Initialization code
    _saleOffLabel=[LJControl labelFrame:CGRectMake(42, 15,38, 20) setText:@"" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X717171) textAlignment:NSTextAlignmentLeft];
    if (ScreenFrame.size.height<=480) {
        _saleOffLabel.frame=CGRectMake(43, 15,38, 20);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        _saleOffLabel.frame=CGRectMake(45, 15,38, 20);
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
        _saleOffLabel.frame=CGRectMake(52, 15,38, 20);
    }else{
        _saleOffLabel.frame=CGRectMake(55, 15,38, 20);
    }

    
    [_saleOff addSubview:_saleOffLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
