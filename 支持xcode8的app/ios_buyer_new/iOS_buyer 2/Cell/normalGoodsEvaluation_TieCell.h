//
//  normalGoodsEvaluation_TieCell.h
//  My_App
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface normalGoodsEvaluation_TieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) UILabel *labelContent;
@property (strong, nonatomic) UILabel *Tiecontent;
@property (strong, nonatomic) UILabel *labelspec;

-(void)setData:(ClassifyModel *)model;
@end
