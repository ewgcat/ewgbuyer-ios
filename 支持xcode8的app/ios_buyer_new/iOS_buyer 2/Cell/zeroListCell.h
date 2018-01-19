//
//  zeroListCell.h
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zeroListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *tryBtn;
@property (weak, nonatomic) IBOutlet UILabel *count;

-(void)setData:(ClassifyModel *)model;

@end
