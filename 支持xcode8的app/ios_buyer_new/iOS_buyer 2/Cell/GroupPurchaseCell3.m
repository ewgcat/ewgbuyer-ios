//
//  GroupPurchaseCell3.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell3.h"
#import "GroupPurcheaseDetailModel.h"
@implementation GroupPurchaseCell3

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cell3WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell3";
    GroupPurchaseCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


@end
