//
//  MyGoodsCell.m
//  My_App
//
//  Created by barney on 15/11/4.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "MyGoodsCell.h"
#import "UIImageView+WebCache.h"


@implementation MyGoodsCell

-(void) config:(StoreHomeInfoModel *) model
{
    self.goodsNameLable.text=[NSString stringWithFormat:@"%@",model.goods_name];
    self.gooodsPriceLable.text=[NSString stringWithFormat:@" ￥%@",model.goods_current_price];
    [self.goodsView sd_setImageWithURL:[NSURL URLWithString:model.goods_main_photo] placeholderImage:[UIImage imageNamed:@"backgroundDefault"]];
}

- (void)awakeFromNib {

}

@end
