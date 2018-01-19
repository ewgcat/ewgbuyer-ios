//
//  SYOrderDetailsCell5.m
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell5.h"
#import "SYOrderDetailsModel.h"

@interface SYOrderDetailsCell5 ()

@property (weak, nonatomic) IBOutlet UILabel *logistic;
@property (weak, nonatomic) IBOutlet UILabel *invoice;
@property (weak, nonatomic) IBOutlet UILabel *payType;

@end

@implementation SYOrderDetailsCell5

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setModel:(SYOrderDetailsModel *)model{
    _model = model;
    
    if(model.order_logistic==nil){
        _logistic.text = @"暂无物流信息";
    }else{
        _logistic.text = model.order_logistic;
    }
    _invoice.text = [SYObject stringByNumber:model.order_invoice];
    _payType.text = model.order_pay_type;
}

+(instancetype)cell5WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell5";
    SYOrderDetailsCell5 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
