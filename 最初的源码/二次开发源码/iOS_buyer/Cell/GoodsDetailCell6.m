//
//  GoodsDetailCell6.m
//  My_App
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDetailCell6.h"

@implementation GoodsDetailCell6

- (void)awakeFromNib {
    // Initialization code
    _userImgView.layer.cornerRadius=15;
     _userImgView.layer.masksToBounds= YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
