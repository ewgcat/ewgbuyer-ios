//
//  returnMoneyCell.m
//  My_App
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "returnMoneyCell.h"

@implementation returnMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    [_returnBtn.layer setMasksToBounds:YES];
    [_returnBtn.layer setCornerRadius:2];
    
    [_topLabel.layer setMasksToBounds:YES];
    [_topLabel.layer setCornerRadius:4];
}
-(void)setData:(ClassifyModel *)model{
    _order_num.text = [NSString stringWithFormat:@"%@",model.goods_sn];
    _statue.text = [NSString stringWithFormat:@"退款状态: %@",model.goods_refund_msg];
    _order_time.text = [NSString stringWithFormat:@"%@",model.goods_addTime];
    [_photoImage sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",model.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _name.text = model.goods_name;
    _price.text = [NSString stringWithFormat:@"￥%@",model.goods_current_price];
    [_returnBtn setTitle:model.goods_refund_msg forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
