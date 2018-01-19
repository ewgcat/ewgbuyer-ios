//
//  GroupPurchaseCell6.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell6.h"
#import "GroupPurcheaseDetailModel.h"

@implementation GroupPurchaseCell6

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    _name.text=@"DvP314283917";
    _bottom.text=@"djsliaiajlksv";
    _date.text=@"2015-11-04";
    
}

+(instancetype)cell6WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell6";
    GroupPurchaseCell6 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell6 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
