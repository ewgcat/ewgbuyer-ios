//
//  activityCell.h
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *user0_price;
@property (weak, nonatomic) IBOutlet UILabel *user1_price;
@property (weak, nonatomic) IBOutlet UILabel *usre2_price;
@property (weak, nonatomic) IBOutlet UILabel *user3_price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *preice;
@property (weak, nonatomic) IBOutlet UILabel *salescount;
-(void)setData:(ClassifyModel *)model;
@end
