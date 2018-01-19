//
//  SimilarTableViewCell.m
//  
//
//  Created by apple on 15/10/20.
//
//

#import "SimilarTableViewCell.h"

@implementation SimilarTableViewCell
{

    __weak IBOutlet UIImageView *photoImageView;
   
    __weak IBOutlet UILabel *nameLabel;


}
-(void)setModel:(Model *)model{
    _model=model;
    NSLog(@"%@",model.goods_photo);
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_photo]];
    nameLabel.numberOfLines=2;
    nameLabel.text=[NSString stringWithFormat:@"%@",model.goods_name];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    nameLabel.textColor=UIColorFromRGB(0X000000);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
