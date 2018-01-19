//
//  InformCell.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "InformCell.h"

@implementation InformCell

- (void)awakeFromNib {
    self.redView.layer.cornerRadius = 5;
    self.redView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
