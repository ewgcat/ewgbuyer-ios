//
//  uporderCell.h
//  My_App
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uporderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *realPrice;
@property (weak, nonatomic) IBOutlet UILabel *reduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reducePrice;
@property (weak, nonatomic) IBOutlet UILabel *couponsPrice;
@property (weak, nonatomic) IBOutlet UILabel *shipPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *ticketTop;
@property (weak, nonatomic) IBOutlet UILabel *ticketType;

@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsListBtn;
@property (weak, nonatomic) IBOutlet UIButton *ticketBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet UIView *h5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h55;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hc;


@end
