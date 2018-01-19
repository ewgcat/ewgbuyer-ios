//
//  zeroOrderCell.h
//  My_App
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zeroOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *statusBottom;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
