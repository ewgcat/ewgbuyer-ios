//
//  OneYuanGoodsCell.m
//  My_App
//
//  Created by barney on 16/2/15.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "OneYuanGoodsCell.h"

@implementation OneYuanGoodsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
    return 100.f;
}

-(void)setModel:(OneYuanModel *)model{
    
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.cloudPurchaseGoods.primary_photo];
    [_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    _goodsName.text = model.cloudPurchaseGoods.goods_name;
    
    //总需
    _allPeople.text = [NSString stringWithFormat:@"总需: %@人次", model.cloudPurchaseGoods.goods_price];
    
    //剩余
    NSInteger balance = model.cloudPurchaseGoods.goods_price.integerValue - model.purchased_times.integerValue;
    NSString *text = [NSString stringWithFormat:@"%ld",(long)balance];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%ld",(long)balance]];
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc]initWithString:text];
    [statusText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    _unAll.attributedText = statusText;
    
    //进度条
    _progressView.progress = model.purchased_times.floatValue / model.cloudPurchaseGoods.goods_price.floatValue;
    
    _specialImg.hidden = model.cloudPurchaseGoods.least_rmb.integerValue == 10 ? false : true;
}
//添加购物车按钮被点击
- (IBAction)addBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addToCartBtnClicked:)]) {
        [self.delegate addToCartBtnClicked:self];
    }
}

@end
