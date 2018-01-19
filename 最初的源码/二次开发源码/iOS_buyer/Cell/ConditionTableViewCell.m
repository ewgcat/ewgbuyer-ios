//
//  ConditionTableViewCell.m
//  
//
//  Created by apple on 15/10/21.
//
//

#import "ConditionTableViewCell.h"

@implementation ConditionTableViewCell
{
    __weak IBOutlet UILabel *titleLabel;
 



}
-(void)setModel:(AreaModel *)model{
    _model=model;
    titleLabel.text=[NSString stringWithFormat:@"  %@",model.areaName];
    titleLabel.userInteractionEnabled=YES;
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    titleLabel.textColor=UIColorFromRGB(0X666666);
//    titleLabel.text=@" 全部      100 ";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
