//
//  PreviousRecordCell.m
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "PreviousRecordCell.h"

@interface PreviousRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *winner;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIView *wrapper;

@end

@implementation PreviousRecordCell

- (void)awakeFromNib {
    // Initialization code
    self.wrapper.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.wrapper.layer.borderWidth = 1;
    self.wrapper.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 5.f;
    self.avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PreviousWinnerRecord *)model{
    _model = model;
    
    NSString *str1 = [NSString stringWithFormat:@"期号: %@(揭晓时间：%@)",model.period,model.addTime];
    self.period.text = str1;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    NSAttributedString *str2 = [NSAttributedString stringWithFullStr:[NSString stringWithFormat:@"获奖者：%@",model.winner] attributedPart:model.winner attribute:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    self.winner.attributedText = str2;
    
    self.num.attributedText = [NSAttributedString stringWithFullStr:[NSString stringWithFormat:@"幸运号码：%@",model.number] attributedPart:model.number attribute:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    self.total.attributedText = [NSAttributedString stringWithFullStr:[NSString stringWithFormat:@"本期参与：%@",model.totalCount] attributedPart:model.totalCount attribute:@{NSForegroundColorAttributeName:[UIColor redColor]}];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    PreviousRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PreviousRecordCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

+(CGFloat)cellHeight{
    return 112.f;
}


@end
