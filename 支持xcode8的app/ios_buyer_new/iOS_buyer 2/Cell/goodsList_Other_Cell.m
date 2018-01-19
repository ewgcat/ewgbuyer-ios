//
//  goodsList_Other_Cell.m
//  My_App
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "goodsList_Other_Cell.h"

@implementation goodsList_Other_Cell

- (void)awakeFromNib {
    // Initialization code
    //self.imgH.constant=173.5;
    [super awakeFromNib];

    
}
-(void)setData:(ClassifyModel*)classleft rightModel:(ClassifyModel*)classright array:(int )arrCount{
    if (arrCount%2 == 0) {
        _leftName.text = classleft.goods_name;
        _leftPrice.text = [NSString stringWithFormat:@"￥%@",classleft.goods_current_price];
        [_leftImage sd_setImageWithURL:[NSURL URLWithString:classleft.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        
        _rightName.text = classright.goods_name;
        _rightPrice.text = [NSString stringWithFormat:@"￥%@",classright.goods_current_price];
        [_rightImage sd_setImageWithURL:[NSURL URLWithString:classright.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    }else{
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
