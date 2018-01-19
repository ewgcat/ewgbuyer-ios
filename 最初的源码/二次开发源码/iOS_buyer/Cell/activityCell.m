//
//  activityCell.m
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "activityCell.h"

@implementation activityCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setData:(ClassifyModel *)model{
    [_photoImage sd_setImageWithURL:(NSURL*)model.goods_main_photo placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _preice.text = [NSString stringWithFormat:@"最低价:￥%@",model.goods_current_price];
    _salescount.text = [NSString stringWithFormat:@"销量:%@",model.goods_salenum];
    _name.text = [NSString stringWithFormat:@"%@",model.goods_name];
    _user0_price.text = [NSString stringWithFormat:@"%@元",model.goods_price1];
    _user1_price.text = [NSString stringWithFormat:@"%@元",model.goods_price2];
    _usre2_price.text = [NSString stringWithFormat:@"%@元",model.goods_price3];
    _user3_price.text = [NSString stringWithFormat:@"%@元",model.goods_current_price];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
