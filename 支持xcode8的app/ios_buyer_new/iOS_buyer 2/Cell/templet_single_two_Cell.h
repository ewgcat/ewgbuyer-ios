//
//  templet_single_two_Cell.h
//  My_App
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface templet_single_two_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageRight;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftPrice;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageBottom;

@end
