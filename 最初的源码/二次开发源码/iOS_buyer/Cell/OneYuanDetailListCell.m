//
//  OneYuanDetailListCell.m
//  My_App
//
//  Created by barney on 16/2/17.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "OneYuanDetailListCell.h"

@implementation OneYuanDetailListCell

- (void)awakeFromNib {
    // Initialization code
    self.img.layer.cornerRadius=self.img.size.width/2;
    self.img.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
