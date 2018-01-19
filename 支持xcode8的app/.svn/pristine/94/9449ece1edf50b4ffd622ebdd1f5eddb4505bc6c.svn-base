//
//  RemainderCouponsListCell.m
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RemainderCouponsListCell.h"

@implementation RemainderCouponsListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [_CouponsUseInfo.layer setMasksToBounds:YES];
    [_CouponsUseInfo.layer setCornerRadius:10];
    [_RemainderLabel.layer setMasksToBounds:YES];
    [_RemainderLabel.layer setCornerRadius:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData:(ClassifyModel *)model{
    _CouponsName.text = model.coupon_name;
    [_PhotoImage sd_setImageWithURL:(NSURL*)model.coupon_pic placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _CouponsPrice.text = [NSString stringWithFormat:@"%@",model.coupon_amount];
    _CouponsTime.text = [NSString stringWithFormat:@"%@至%@",model.coupon_beginTime,model.coupon_endTime];
    _CouponsUseInfo.text = [NSString stringWithFormat:@"  满%@元使用",model.coupon_order_amount];
    _RemainderLabel.text = [NSString stringWithFormat:@"剩余%@张",model.coupon_info];
    if([model.coupon_status intValue] == 0){//可领取
        [_bottomImage setImage:[UIImage imageNamed:@"coupons_left"]];
        [_coupons_right setImage:[UIImage imageNamed:@"coupons_right"]];
//        _SymbolLabel.textColor = RGB_COLOR(95, 186, 245);
        _CouponsUseInfo.backgroundColor = RGB_COLOR(216, 243, 255);
        _CouponsPrice.textColor = RGB_COLOR(95, 186, 245);
//        _OverImage.hidden = YES;
    }else{//不可领取
//        _OverImage.hidden = NO;
        [_bottomImage setImage:[UIImage imageNamed:@"coupons_overleft"]];
        [_coupons_right setImage:[UIImage imageNamed:@"coupons_overright"]];
//        _SymbolLabel.textColor = [UIColor lightGrayColor];
        _CouponsUseInfo.backgroundColor = RGB_COLOR(235, 235, 235);
        _CouponsPrice.textColor = [UIColor lightGrayColor];
    }
}
@end
