//
//  PaymentOrderCell1.m
//  My_App
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaymentOrderCell1.h"

@implementation PaymentOrderCell1
-(void)setModel:(CloudCart *)model{
    _model = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.cloudPurchaseLottery.cloudPurchaseGoods.primary_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    if (model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name.length<10) {
        self.titleLabel.text=[NSString stringWithFormat:@"%@\n",model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name];
    }else{
        self.titleLabel.text = model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name;
    }
    self.titleLabel.numberOfLines = 2;

    NSString *text =[NSString stringWithFormat:@"参与人次：%@人次",model.purchased_times];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"人次：%@",model.purchased_times]];
    NSRange range1 = NSMakeRange(range.location + 3, range.length - 3);
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc]initWithString:text];
    [statusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0Xef0000) range:range1];
    self.participateLabel.attributedText =statusText;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
