//
//  PaymentOrderCell1.h
//  My_App
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudCart.h"

@interface PaymentOrderCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *participateLabel;

@property (nonatomic, strong)CloudCart *model;

@end
