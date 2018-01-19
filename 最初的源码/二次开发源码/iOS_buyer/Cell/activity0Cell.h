//
//  activity0Cell.h
//  My_App
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activity0Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *TopImage;
@property (weak, nonatomic) IBOutlet UILabel *ActivityName;
@property (weak, nonatomic) IBOutlet UILabel *ActivityTime;
-(void)setData:(ClassifyModel *)classM;
@end
