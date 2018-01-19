//
//  buyer_returnCell.m
//  My_App
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "buyer_returnCell.h"

@implementation buyer_returnCell

- (void)awakeFromNib {
    // Initialization code
    [_applyBtn.layer setMasksToBounds:YES];
    [_applyBtn.layer setCornerRadius:2];
}
-(void)setData:(ClassifyModel *)model{
    _order_num.text = [NSString stringWithFormat:@"%@",model.goods_sn];
    _status.text = [NSString stringWithFormat:@"退款状态: %@",model.goods_refund_msg];
    [self fuwenbenLabel:_status FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 5) AndColor:[UIColor blackColor]];
    _order_time.text = [NSString stringWithFormat:@"%@",model.goods_addTime];
    [_photoImage sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",model.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _name.text = model.goods_name;
    _price.text = [NSString stringWithFormat:@"￥%@",model.goods_current_price];
    [_applyBtn setTitle:model.goods_refund_msg forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}
@end
