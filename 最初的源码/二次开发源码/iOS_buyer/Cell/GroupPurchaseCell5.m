//
//  GroupPurchaseCell5.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurchaseCell5.h"
#import "GroupPurcheaseDetailModel.h"
@implementation GroupPurchaseCell5

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    if (model.gg_rules.length>0) {
        _rule.text = [NSString stringWithFormat:@"%@",model.gg_rules];
    }else
    {
        _rule.text=@"暂无";
    
    }
    
    _useTime.text = [NSString stringWithFormat:@"%@ 至 %@",model.beginTime,model.endTime];
    if (model.gg_scope.length>0) {
         _conclude.text = [NSString stringWithFormat:@"%@",model.gg_scope];
    }else
    {
         _conclude.text=@"暂无";
    }
   
    
    
    
}

+(instancetype)cell5WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell5";
    GroupPurchaseCell5 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupPurchaseCell5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
