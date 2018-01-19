//
//  publishTableViewCell.m
//  My_App
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "publishTableViewCell.h"

@implementation publishTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _pingkuangImage.layer.borderWidth = 0.5;
    _pingkuangImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    CALayer *lay = self.image.layer;
    lay.borderColor = [UIColorFromRGB(0xd7d7d7) CGColor];
    lay.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
