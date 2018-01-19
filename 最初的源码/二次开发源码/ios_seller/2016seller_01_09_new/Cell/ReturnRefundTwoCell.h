//
//  ReturnRefundTwoCell.h
//  2016seller_01_09_new
//
//  Created by barney on 16/1/15.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnRefundTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *refundMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *refuseButton;
@property(nonatomic,strong)UIButton *adoptButton;
@end
