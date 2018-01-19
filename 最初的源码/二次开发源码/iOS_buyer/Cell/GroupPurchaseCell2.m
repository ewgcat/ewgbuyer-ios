//
//  GroupPurchaseCell2.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell2.h"
#import "GroupPurcheaseDetailModel.h"
@implementation GroupPurchaseCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    _nowPrice.text = [NSString stringWithFormat:@"%@",model.gg_price];
    _oldPrice.text = [NSString stringWithFormat:@"门市价: ￥%@",model.gg_store_price];
    _saler.text = [NSString stringWithFormat:@"已售%@",model.gg_selled_count];
    _buyBtn.layer.cornerRadius=4;
    [_buyBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_buyBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0XFE9900);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0XFE9910);
}
+(instancetype)cell2WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell2";
    GroupPurchaseCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
