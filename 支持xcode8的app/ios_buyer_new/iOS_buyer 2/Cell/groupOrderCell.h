//
//  groupOrderCell.h
//  My_App
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end
