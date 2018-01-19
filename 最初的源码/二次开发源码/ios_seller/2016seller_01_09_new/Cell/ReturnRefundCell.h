//
//  ReturnRefundCell.h
//  2016seller_01_09_new
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnRefundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong)UILabel *buyersLabel;
@property(nonatomic,strong)UILabel *orderLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *refuseButton;
@property(nonatomic,strong)UIButton *adoptButton;

@end
