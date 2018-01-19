//
//  orderCell1.m
//  My_App
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "orderCell1.h"

@implementation orderCell1
{
    __weak IBOutlet UILabel *businessNameLabel;

}
-(void)setModel:(Model *)model{
    _model = model;
    if ([model.order_status intValue]==10) {
       businessNameLabel.text = @"待付款";
        if ([model.order_special isEqualToString:@"advance"]) {
           businessNameLabel.text =[NSString stringWithFormat:@"%@ %@",businessNameLabel.text,@"(请在30分钟支付定金)"];
        }
    }else if([model.order_status intValue]==11){
        businessNameLabel.text = @"已付定金";
    }else if([model.order_status intValue]==30){
        businessNameLabel.text = @"待收货";
    }else if([model.order_status intValue]==20){
       businessNameLabel.text = @"待发货";
    }else if([model.order_status intValue]==16){
        businessNameLabel.text = @"待发货";//详情 货到付款
    }else if([model.order_status intValue]==0){
       businessNameLabel.text = @"已取消";
    }else if([model.order_status intValue]==50){
        businessNameLabel.text = @"已评价";
    }else if([model.order_status intValue]==40){
        businessNameLabel.text = @"已收货";
    }else if([model.order_status intValue]==65){
        businessNameLabel.text = @"自动评价";
    }else if([model.order_status intValue]==21){
       businessNameLabel.text = @"已申请退款";
    }else if([model.order_status intValue]==22){
        businessNameLabel.text = @"退款中";
    }else if([model.order_status intValue]==25){
        businessNameLabel.text = @"退款完成";
    }else if([model.order_status intValue]==35){
        businessNameLabel.text = @"自提点已收货";
    }else{
        businessNameLabel.text = @"未知订单";
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
