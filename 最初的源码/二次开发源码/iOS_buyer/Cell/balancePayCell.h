//
//  balancePayCell.h
//  My_App
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface balancePayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_id;
@property (weak, nonatomic) IBOutlet UILabel *order_price;
@property (weak, nonatomic) IBOutlet UITextField *passwordsTextField;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
