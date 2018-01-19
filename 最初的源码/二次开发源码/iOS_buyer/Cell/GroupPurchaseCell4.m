//
//  GroupPurchaseCell4.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell4.h"
#import "GroupPurcheaseDetailModel.h"

@implementation GroupPurchaseCell4

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    _mainTitle.text = [NSString stringWithFormat:@"%@",model.store_name];
    _address.text = [NSString stringWithFormat:@"%@",model.gai_name];
        
    
}

+(instancetype)cell4WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell4";
    GroupPurchaseCell4 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
