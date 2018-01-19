//
//  orderCell3.m
//  My_App
//
//  Created by1 apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "orderCell3.h"

@implementation orderCell3
{
    __weak IBOutlet UILabel *priceLabel;
    __weak IBOutlet NSLayoutConstraint *lineHeight;


}
-(void)setModel:(Model *)model{
    _model = model;
    priceLabel.text = [NSString stringWithFormat:@"订单金额:￥%.2f(含运费¥%.2f)",[model.order_total_price floatValue],[model.order_ship_price floatValue]];
    NSRange range = [priceLabel.text rangeOfString:@"."];
    [self fuwenbenLabel:priceLabel FontNumber:[UIFont systemFontOfSize:16] AndRange:NSMakeRange(6,range.location-6) AndColor:UIColorFromRGB(0x3d4245)];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    lineHeight.constant = 0.5;
}
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
