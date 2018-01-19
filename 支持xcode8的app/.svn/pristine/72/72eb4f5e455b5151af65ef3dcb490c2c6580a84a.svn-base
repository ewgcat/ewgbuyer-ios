//
//  GroupPurchaseCell8.m
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell8.h"
#import "GroupPurcheaseDetailModel.h"
@implementation GroupPurchaseCell8

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    
    
}

+(instancetype)cell8WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell8";
    GroupPurchaseCell8 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
