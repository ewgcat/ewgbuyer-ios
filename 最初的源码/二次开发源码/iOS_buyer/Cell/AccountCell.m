//
//  AccountCell.m
//  
//
//  Created by apple on 15/10/14.
//
//

#import "AccountCell.h"

@implementation AccountCell
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *moneyLabel;


}
-(void)setModel:(AccountModel *)model{
    _model=model;
    titleLabel.text=[NSString stringWithFormat:@" %@",model.title];
    timeLabel.text=[NSString stringWithFormat:@" %@",model.time];
    if ([model.money integerValue]>0) {
        moneyLabel.text=[NSString stringWithFormat:@"+%@",model.money];
    }else if ([model.money integerValue]<0){
        moneyLabel.text=[NSString stringWithFormat:@"%@",model.money];
    }else{
        moneyLabel.text=[NSString stringWithFormat:@"%@",model.money];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    titleLabel.textColor=UIColorFromRGB(0X000000);
    timeLabel.textColor=UIColorFromRGB(0X939393);
    moneyLabel.textColor=UIColorFromRGB(0X000000);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
