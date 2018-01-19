//
//  zeroListCell.m
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "zeroListCell.h"

@implementation zeroListCell

- (void)awakeFromNib {
    // Initialization code
//    [_tryBtn.layer setMasksToBounds:YES];
//    [_tryBtn.layer setCornerRadius:4];
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setData:(ClassifyModel *)model{
    [_photoImage sd_setImageWithURL:(NSURL*)model.free_acc placeholderImage:[UIImage imageNamed:@"pure_gray"]];
//    _count.text = [NSString stringWithFormat:@"%@已人申请",model.free_count];
    _count.text = [NSString stringWithFormat:@"%@件",model.free_count];
    _name.text = model.free_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
