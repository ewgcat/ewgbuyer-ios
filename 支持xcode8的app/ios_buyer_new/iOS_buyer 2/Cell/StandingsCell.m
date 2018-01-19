//
//  StandingsCell.m
//  
//
//  Created by apple on 15/10/16.
//
//

#import "StandingsCell.h"

@implementation StandingsCell
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *moneyLabel;


}
-(void)setModel:(AccountModel *)model{
    _model=model;
    titleLabel.text=[NSString stringWithFormat:@" %@",model.title];
    timeLabel.text=[NSString stringWithFormat:@" %@",model.time];
    
    if ([model.money integerValue]>=0) {
        moneyLabel.text=[NSString stringWithFormat:@"+%@",model.money];
        moneyLabel.textColor=UIColorFromRGB(0Xef5151);
    }else{
        moneyLabel.text=[NSString stringWithFormat:@"%@",model.money];
        moneyLabel.textColor=UIColorFromRGB(0X5f5f5f);
    }

}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    titleLabel.textColor=UIColorFromRGB(0X333333);
    timeLabel.textColor=UIColorFromRGB(0X5d5d5d);
   }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
