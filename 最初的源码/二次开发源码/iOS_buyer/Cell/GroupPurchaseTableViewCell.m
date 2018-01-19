//
//  GroupPurchaseTableViewCell.m
//  
//
//  Created by apple on 15/10/21.
//
//

#import "GroupPurchaseTableViewCell.h"

@implementation GroupPurchaseTableViewCell
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *llabel;
    __weak IBOutlet UILabel *priceLabel;
    __weak IBOutlet UILabel *quantityLabel;
    __weak IBOutlet NSLayoutConstraint *h;

}
-(void)setModel:(GroupModel *)model{
    _model=model;
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.gg_img]];
    nameLabel.text=[NSString stringWithFormat:@"%@",model.gg_name];
    priceLabel.text=[NSString stringWithFormat:@"￥%@",model.gg_price];
    quantityLabel.text=[NSString stringWithFormat:@"%@人已经购买",model.gg_selled_count];
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    llabel.backgroundColor=UIColorFromRGB(0Xf0f0f0);
    nameLabel.textColor=UIColorFromRGB(0X626262);
    priceLabel.textColor=UIColorFromRGB(0Xf94343);
    quantityLabel.textColor=UIColorFromRGB(0X999999);
    h.constant=0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
