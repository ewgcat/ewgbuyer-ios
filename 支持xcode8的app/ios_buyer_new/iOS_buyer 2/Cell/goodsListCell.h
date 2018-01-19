//
//  goodsListCell.h
//  My_App
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;
//@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) UILabel *status;
-(void)setData:(ClassifyModel *)class;
@end
