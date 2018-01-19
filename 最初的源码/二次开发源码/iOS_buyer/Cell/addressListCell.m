//
//  addressListCell.m
//  My_App
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "addressListCell.h"

@implementation addressListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setData:(addressListModel *)model{
    _name.text = model.lastName;
    _phone.text  = model.tmpPhoneIndex;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
