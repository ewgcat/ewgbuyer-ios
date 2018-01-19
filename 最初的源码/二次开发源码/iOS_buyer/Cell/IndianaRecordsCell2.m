//
//  IndianaRecordsCell2.m
//  My_App
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaRecordsCell2.h"

@implementation IndianaRecordsCell2

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
    
    _functionLabel.textColor=UIColorFromRGB(0Xdd5244);
    _functionLabel.layer.borderColor = [UIColorFromRGB(0Xdd5244) CGColor];
    if ([_model.cloudPurchaseLottery.delivery_status integerValue]==-1) {
       _functionLabel.text=@"收货地址";
    }else if ([_model.cloudPurchaseLottery.delivery_status integerValue]==0){
        _functionLabel.text=@"修改地址";
    }else if ([_model.cloudPurchaseLottery.delivery_status integerValue]==1){
        _functionLabel.text=@"确认收货";
    }else{
     _functionLabel.text=@"已完成";
        _functionLabel.textColor=UIColorFromRGB(0XDCDCDC);
         _functionLabel.layer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
    _functionLabel=[LJControl labelFrame:CGRectMake(0, 0, 114, 30) setText:@"预留按钮" setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xdd5244) textAlignment:NSTextAlignmentCenter];
    _functionLabel.layer.cornerRadius = 4;
    _functionLabel.layer.masksToBounds = YES;
    _functionLabel.layer.borderWidth = 1;
    _functionLabel.layer.borderColor = [UIColorFromRGB(0Xdd5244) CGColor];
    [_functionButton addSubview:_functionLabel];
    
    
    _detailsButton.tag=1000;
    _functionLabel.tag=1001;
    [_detailsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_functionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)buttonClick:(UIButton *)btn{
    if (btn.tag==1000) {
        [self.delegate detailsButtonCLick:_model];
    }else{
        if ([_model.cloudPurchaseLottery.delivery_status integerValue]==-1) {
            [self.delegate addressSelectionButtonCLick:_model];
        }else if ([_model.cloudPurchaseLottery.delivery_status integerValue]==0){
            [self.delegate addressSelectionButtonCLick:_model];
        }else if ([_model.cloudPurchaseLottery.delivery_status integerValue]==1){
            [self.delegate confirmReceiptButtonCLick:_model];
        }else{
            
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
