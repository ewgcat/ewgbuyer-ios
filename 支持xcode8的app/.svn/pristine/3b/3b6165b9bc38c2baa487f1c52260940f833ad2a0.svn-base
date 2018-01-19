//
//  SYOrderDetailsCell1.m
//  My_App
//
//  Created by shiyuwudi on 15/11/4.
//  Copyright © 1015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell1.h"
#import "SYOrderDetailsModel.h"

@interface SYOrderDetailsCell1 ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SYOrderDetailsCell1

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

-(void)setModel:(SYOrderDetailsModel *)model{
    _model = model;
    
    NSString *statusStr = [SYObject orderStatusStringByCode:model.order_status];
    _statusLabel.text = statusStr;
    _numLabel.text = [SYObject stringByNumber:model.order_num];
    _timeLabel.text = [SYObject stringByNumber:model.order_time];

    if (model.order_status.integerValue==10||model.order_status.integerValue==11) {
        //通知控制器显示取消订单按钮
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDisplayCancelOrderBarButtonItem:)]) {
            [self.delegate shouldDisplayCancelOrderBarButtonItem:self];
        }
    }
}

+(instancetype)cell1WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell1";
    SYOrderDetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
