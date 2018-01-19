//
//  IndianaRecordsCell.m
//  My_App
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaRecordsCell.h"

@implementation IndianaRecordsCell

- (void)setModel:(CloudCart *)model{
    _model=model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.cloudPurchaseLottery.cloudPurchaseGoods.primary_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    if (model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name.length<10) {
        self.nameLabel.text=[NSString stringWithFormat:@"%@\n",model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name];
    }else{
        self.nameLabel.text = model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name;
    }
    self.nameLabel.numberOfLines = 2;
    
    self.numberLabel.text=[NSString stringWithFormat:@"期号：%@",model.cloudPurchaseLottery.period];
    
    self.needLabel.text=[NSString stringWithFormat:@"总需：%@人次",model.cloudPurchaseLottery.cloudPurchaseGoods.goods_price];
    
    NSString *text =[NSString stringWithFormat:@"本期参与：%@人次",model.purchased_times];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"参与：%@",model.purchased_times]];
    NSRange range1 = NSMakeRange(range.location + 3, range.length - 3);
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc]initWithString:text];
    [statusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0Xef0000) range:range1];
    self.participateLabel.attributedText =statusText;

    self.winnerwLabel.text=[NSString stringWithFormat:@"获奖者：%@",model.cloudPurchaseLottery.lucky_username];
    
    NSString *texting =[NSString stringWithFormat:@"本期参与：%@人次",model.cloudPurchaseLottery.lucky_usertimes];
    NSRange rangeing = [texting rangeOfString:[NSString stringWithFormat:@"参与：%@",model.cloudPurchaseLottery.lucky_usertimes]];
    NSRange rangeing1 = NSMakeRange(rangeing.location + 3, rangeing.length - 3);
    NSMutableAttributedString *statusText1 = [[NSMutableAttributedString alloc]initWithString:texting];
    [statusText1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0Xef0000) range:rangeing1];
    self.attendLabel.attributedText =statusText1;
    
    NSString *luckytexting =[NSString stringWithFormat:@"幸运号码：%@",model.cloudPurchaseLottery.lucky_code];
    NSRange luckyrangeing = [luckytexting rangeOfString:[NSString stringWithFormat:@"号码：%@",model.cloudPurchaseLottery.lucky_code]];
    NSRange luckyrangeing1 = NSMakeRange(luckyrangeing.location + 3, luckyrangeing.length - 3);
    NSMutableAttributedString *luckystatusText1 = [[NSMutableAttributedString alloc]initWithString:luckytexting];
    [luckystatusText1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0Xef0000) range:luckyrangeing1];
    self.luckyLabel.attributedText =luckystatusText1;
    
    self.timeLabel.text=[NSString stringWithFormat:@"揭晓时间：%@",model.cloudPurchaseLottery.announced_date];
}
- (void)awakeFromNib {
    // Initialization code
    [_detailsButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonClick{
    [self.delegate detailsButtonCLick:_model];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
