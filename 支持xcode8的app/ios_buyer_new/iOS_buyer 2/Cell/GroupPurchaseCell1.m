//
//  GroupPurchaseCell1.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell1.h"
#import "GroupPurcheaseDetailModel.h"

#import "UIImageView+WebCache.h"

@implementation GroupPurchaseCell1

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    _name.text = [NSString stringWithFormat:@"%@",model.gg_name];
    [_img sd_setImageWithURL:[NSURL URLWithString:model.gg_img]];
    
}

+(instancetype)cell1WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell1";
    GroupPurchaseCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
