//
//  ReceiveGoodsCell.m
//  My_App
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ReceiveGoodsCell.h"

@implementation ReceiveGoodsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [_ReceiveGoods_LeftView.layer setMasksToBounds:YES];
    [_ReceiveGoods_LeftView.layer setCornerRadius:4];
    
    [_ReceiveGoods_RightView.layer setMasksToBounds:YES];
    [_ReceiveGoods_RightView.layer setCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData:(ClassifyModel *)modelLeft rightData:(ClassifyModel *)modelRight{
    [_ReceiveGoods_LeftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelLeft.goods_main_photo]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    [_ReceiveGoods_RightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelRight.goods_main_photo]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    _ReceiveGoods_LeftName.text = modelLeft.goods_name;
    _ReceiveGoods_LeftPrice.text = [NSString stringWithFormat:@"￥%@",modelLeft.goods_current_price];
    
    _ReceiveGoods_RightName.text = modelRight.goods_name;
    _ReceiveGoods_RightPrice.text = [NSString stringWithFormat:@"￥%@",modelRight.goods_current_price];
}
@end
