//
//  OneYuanGoodsClassCell3.m
//  My_App
//
//  Created by barney on 16/2/18.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "OneYuanGoodsClassCell3.h"

@implementation OneYuanGoodsClassCell3

- (void)awakeFromNib {
    // Initialization code
    self.redView.backgroundColor=[UIColor colorWithRed:0.90f green:0.18f blue:0.28f alpha:1.00f];
    [self.JSBtn.layer setMasksToBounds:YES];
    [self.JSBtn.layer setCornerRadius:2.0];
    //边界
    self.JSBtn.layer.borderWidth=1;
    self.JSBtn.layer.borderColor=[UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
