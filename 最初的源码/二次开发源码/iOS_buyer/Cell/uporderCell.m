//
//  uporderCell.m
//  My_App
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "uporderCell.h"

@implementation uporderCell

- (void)awakeFromNib {
    // Initialization code
//    UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 39, self.goodsLabel.frame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xe3e3e3)];
//     UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 39, self.goodsLabel.frame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xe3e3e3)];
//     UIView *grayLine3=[LJControl viewFrame:CGRectMake(0, 39, self.goodsLabel.frame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xe3e3e3)];
//    [self.goodsLabel addSubview:grayLine1];
//    [self.shipLabel addSubview:grayLine2];
//    [self.couponsLabel addSubview:grayLine3];
   
    self.h1.constant=0.5;
    self.h2.constant=0.5;
    self.h3.constant=0.5;
    self.h4.constant=0.5;
    self.h55.constant=0.5;
    self.h6.constant=0.5;
    
    self.hg.constant=0.5;
    self.hs.constant=0.5;
    self.hc.constant=0.5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
