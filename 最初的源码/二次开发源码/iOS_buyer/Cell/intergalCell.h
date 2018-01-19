//
//  intergalCell.h
//  My_App
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface intergalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *shipprice;
@property (weak, nonatomic) IBOutlet UILabel *intergalLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UIView *muchView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
