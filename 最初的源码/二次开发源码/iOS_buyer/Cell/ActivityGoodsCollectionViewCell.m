//
//  ActivityGoodsCollectionViewCell.m
//  My_App
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ActivityGoodsCollectionViewCell.h"

@implementation ActivityGoodsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _bottomView.layer.borderColor = [RGB_COLOR(215, 215, 215) CGColor];
    _bottomView.layer.borderWidth  = 0.5;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ActivityGoodsCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
-(void)setData:(ClassifyModel *)classify{
    [_topImage sd_setImageWithURL:[NSURL URLWithString:classify.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _name.text = classify.goods_name;
    _price.text = [NSString stringWithFormat:@"￥%@",classify.goods_current_price];
    _salesCount.text = [NSString stringWithFormat:@"销量%@件",classify.goods_goods_count];
}

@end
