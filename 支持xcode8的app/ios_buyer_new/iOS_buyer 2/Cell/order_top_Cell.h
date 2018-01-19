//
//  order_top_Cell.h
//  My_App
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface order_top_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *shipPrice;
@property (weak, nonatomic) IBOutlet UILabel *couponPrice;
@property (weak, nonatomic) IBOutlet UILabel *ordernum;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@end
