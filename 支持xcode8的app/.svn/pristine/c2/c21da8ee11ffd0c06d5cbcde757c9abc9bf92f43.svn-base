//
//  activity0Cell.m
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "activity0Cell.h"

@implementation activity0Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}
-(void)setData:(ClassifyModel *)classM{
    _ActivityName.text = classM.coupon_name;
    [_TopImage sd_setImageWithURL:[NSURL URLWithString:classM.goods_main_photo] placeholderImage:[self grayImage]];
    if([classM.goods_goods_spec intValue]>0){
        _ActivityTime.text = [NSString stringWithFormat:@"还有%@天结束",classM.goods_goods_spec];
    }else{
        _ActivityTime.text = [NSString stringWithFormat:@"还有%@天开始",classM.goods_goods_spec];
    }
    
}
-(UIImage *)grayImage{
    return [UIImage imageNamed:@"pure_gray"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
