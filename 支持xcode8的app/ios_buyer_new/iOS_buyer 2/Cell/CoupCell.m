//
//  CoupCell.m
//  My_App
//
//  Created by shiyuwudi on 16/3/7.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "CoupCell.h"

@interface CoupCell ()

@property (weak, nonatomic) IBOutlet UIView *outView;

@end

@implementation CoupCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _outView.layer.cornerRadius = 5;
    _outView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
