//
//  FilterCell.m
//  My_App
//
//  Created by apple on 15/10/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(ClassifyModel *)class{
    _LeftLabel.text = class.goods_name;
    if ([[class.classify_thirdArray objectAtIndex:class.ping_height] isEqualToString:@"全部"]) {
        _RightLabel.textColor = [UIColor lightGrayColor];
    }else{
        _RightLabel.textColor = [UIColor redColor];
    }
    _RightLabel.text = [class.classify_thirdArray objectAtIndex:class.ping_height];
}
@end
