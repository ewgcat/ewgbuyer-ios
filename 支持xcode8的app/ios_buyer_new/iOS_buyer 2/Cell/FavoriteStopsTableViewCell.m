//
//  FavoriteStopsTableViewCell.m
//  
//
//  Created by apple on 15/10/19.
//
//

#import "FavoriteStopsTableViewCell.h"

@implementation FavoriteStopsTableViewCell
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *acctLabel;
    __weak IBOutlet UILabel *llLabel;
}
-(void)setModel:(Model *)model{
    _model=model;
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.store_photo] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
    nameLabel.text=[NSString stringWithFormat:@"%@",model.store_name];
    if ([model.favorite_count intValue]/10000>0) {
         acctLabel.text=[NSString stringWithFormat:@"%d.%d万人关注",[model.favorite_count intValue]/10000,[model.favorite_count intValue]%10000];
    }else{
    
        acctLabel.text=[NSString stringWithFormat:@"%@人关注",model.favorite_count];
    }
   
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    photoImageView.image=[UIImage imageNamed:@"kong_lj.png"];
    //设置边框线的宽
    [photoImageView.layer setBorderWidth:1];
    //设置边框线的颜色
    [photoImageView.layer setBorderColor:[UIColorFromRGB(0Xe5e5e5) CGColor]];
    nameLabel.textColor=UIColorFromRGB(0X000000);
    acctLabel.textColor=UIColorFromRGB(0X848688);
    llLabel.backgroundColor=UIColorFromRGB(0Xe5e5e5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
