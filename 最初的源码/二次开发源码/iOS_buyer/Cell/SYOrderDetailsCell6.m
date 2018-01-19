//
//  SYOrderDetailsCell6.m
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell6.h"
#import "SYOrderDetailsModel.h"

@interface SYOrderDetailsCell6 ()
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *price4;
@property (weak, nonatomic) IBOutlet UILabel *reduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reduceTitle;

@end

@implementation SYOrderDetailsCell6

- (void)awakeFromNib {
    // Initialization code
    
    
    
    
    
}

- (void)setModel:(SYOrderDetailsModel *)model{
    _model = model;
    
    _price1.text = [NSString stringWithFormat:@"￥%.2f",[model.order_price1 floatValue]];
    _price2.text = [NSString stringWithFormat:@"+￥%.2f",[model.order_price2 floatValue]];
    _price3.text = [NSString stringWithFormat:@"-￥%.2f",[model.order_price3 floatValue]];
    _price4.text = [NSString stringWithFormat:@"￥%.2f",[model.order_price4 floatValue]];
    _reduceLabel.text= [NSString stringWithFormat:@"-￥%.2f",[model.order_price5 floatValue]];

    
    if ([model.order_special isEqualToString:@"advance"]&& [model.status isEqualToString:@"0"]) {
        _price4.text = [NSString stringWithFormat:@"￥%.2f",[model.advance_din floatValue]];
    }else if ([model.order_special isEqualToString:@"advance"]&& [model.status isEqualToString:@"1"]){
        _price4.text = [NSString stringWithFormat:@"￥%.2f",[model.advance_wei floatValue]];
    }

    
    
}

+(instancetype)cell6WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell6";
    SYOrderDetailsCell6 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell6 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
