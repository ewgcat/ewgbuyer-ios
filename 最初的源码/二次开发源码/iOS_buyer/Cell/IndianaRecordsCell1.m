//
//  IndianaRecordsCell1.m
//  My_App
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaRecordsCell1.h"

@implementation IndianaRecordsCell1
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
