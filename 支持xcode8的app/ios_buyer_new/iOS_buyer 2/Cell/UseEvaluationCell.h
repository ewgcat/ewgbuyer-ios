//
//  UseEvaluationCell.h
//  My_App
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"
@interface UseEvaluationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *berView;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (nonatomic,strong) UILabel  *numberLabel;
@property (nonatomic,strong) ClassifyModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(ClassifyModel *)model;

@end
