//
//  goodsListCell.m
//  My_App
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "goodsListCell.h"

@implementation goodsListCell

- (void)awakeFromNib {
    // Initialization code
    _status  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 20)];
    _status.text = @"活动";
    _status.backgroundColor = [UIColor redColor];
    _status.textColor = [UIColor whiteColor];
    [_status.layer setMasksToBounds:YES];
    [_status.layer setCornerRadius:2.0];
    _status.textAlignment = NSTextAlignmentCenter;
    _status.font = [UIFont boldSystemFontOfSize:11];
    [self addSubview:_status];
    
}
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}
-(void)setData:(ClassifyModel *)class{
    _name.text = class.goods_name;
    _price.text = [NSString stringWithFormat:@"￥%@",class.goods_current_price];
    _count.text =class.goods_evaluate;
    _status.text =class.goods_evaluate;
    NSLog(@"~~%@",class.goods_evaluate);
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:class.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    if (class.goods_status.length == 0) {
        _status.backgroundColor = [UIColor whiteColor];
    }else{
        _status.backgroundColor = [UIColor redColor];
        _status.text = class.goods_status;
    }
    CGRect labelFrame=[self labelSizeHeight:_count.text frame:CGRectMake(15, 0, 0.0, 0.0) font:13];
    _status.frame = CGRectMake(107+labelFrame.size.width+30, 101, 25, 15);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
