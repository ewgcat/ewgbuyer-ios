//
//  OneYuanGoodsClassCell2.m
//  My_App
//
//  Created by barney on 16/2/17.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "OneYuanGoodsClassCell2.h"

@implementation OneYuanGoodsClassCell2

- (void)awakeFromNib {
    // Initialization code
    self.bottomView.backgroundColor=[UIColor colorWithRed:0.86f green:0.21f blue:0.32f alpha:1.00f];
    [self.checkJS.layer setMasksToBounds:YES];
    [self.checkJS.layer setCornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
