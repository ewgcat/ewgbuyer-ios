//
//  GroupPurchaseCell7.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell7.h"
#import "GroupPurcheaseDetailModel.h"
@implementation GroupPurchaseCell7

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

+(instancetype)cell7WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell7";
    GroupPurchaseCell7 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell7 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
