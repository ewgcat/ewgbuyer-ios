//
//  CarWeiTableViewCell.h
//  My_App
//
//  Created by 邱炯辉 on 16/11/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarWeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *psaawordLabel;
@end
