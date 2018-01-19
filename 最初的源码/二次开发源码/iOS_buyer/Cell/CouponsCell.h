//
//  CouponsCell.h
//  My_App
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *coupons_price;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *priceSymbol;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
