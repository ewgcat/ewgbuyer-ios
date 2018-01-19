//
//  XibCell.m
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "XibCell.h"
#import "GroupPurcheaseDetailModel.h"
#import "NewLoginViewController.h"
@implementation XibCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GroupPurcheaseDetailModel *)model{
    _model = model;
    
    _nowPrice.text = [NSString stringWithFormat:@"%@",model.gg_price];
    _oldPrice.text = [NSString stringWithFormat:@"门市价: ￥%@",model.gg_store_price];
    
    _buyBtn.layer.cornerRadius=5;
    
}

+(instancetype)xibcellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"xibcell";
    XibCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XibCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (IBAction)btnClick:(id)sender
{
    
}

@end
