//
//  CoupCell.h
//  My_App
//
//  Created by shiyuwudi on 16/3/7.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
