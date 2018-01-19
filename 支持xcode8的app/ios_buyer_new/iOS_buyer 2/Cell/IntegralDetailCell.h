//
//  IntegralDetailCell.h
//  My_App
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *integralScore;
@property (weak, nonatomic) IBOutlet UILabel *shipprice;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
