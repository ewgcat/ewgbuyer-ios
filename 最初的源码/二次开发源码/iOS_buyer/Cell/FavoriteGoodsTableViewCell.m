//
//  FavoriteGoodsTableViewCell.m
//  
//
//  Created by apple on 15/10/19.
//
//

#import "FavoriteGoodsTableViewCell.h"

@implementation FavoriteGoodsTableViewCell
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *moneyLabel;
    UILabel *hiLabel;


}
-(void)setModel:(Model *)model{
    _model=model;
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.small_photo]];
    nameLabel.numberOfLines=2;
    nameLabel.text=[NSString stringWithFormat:@"%@",model.name];
    moneyLabel.text=[NSString stringWithFormat:@"￥%@.00",model.good_price];
    if ([model.goods_inventory integerValue]<=0) {
        nameLabel.textColor=UIColorFromRGB(0Xb6b6b6);
        moneyLabel.textColor=UIColorFromRGB(0Xb6b6b6);
        hiLabel.hidden=NO;
        photoImageView.alpha=0.7;
        _shoppingCartButton.hidden=YES;
    }
}
- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    nameLabel.textColor=UIColorFromRGB(0X000000);
    moneyLabel.textColor=UIColorFromRGB(0Xd43e47);
    
    _attractButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-140)/4-40+140, 100,80, 30) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    
    UILabel *ttractlabel=[LJControl labelFrame:CGRectMake(0, 0, 80, 30) setText:@"取消关注" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0Xb6b6b6) textAlignment:NSTextAlignmentCenter];
    [ttractlabel.layer setMasksToBounds:YES];
    [ttractlabel.layer setCornerRadius:8.0];
    [ttractlabel.layer setBorderWidth:1.0];
    ttractlabel.layer.borderColor=UIColorFromRGB(0Xe8e8e8).CGColor;
    [_attractButton addSubview:ttractlabel];
    [self.contentView addSubview:_attractButton];
    
    _shoppingCartButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-140)/4*3-40+140, 100,80, 30) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];

    UILabel *tractlabel=[LJControl labelFrame:CGRectMake(0, 0, 80, 30) setText:@"加入购物车" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0Xb6b6b6) textAlignment:NSTextAlignmentCenter];
    [tractlabel.layer setMasksToBounds:YES];
    [tractlabel.layer setCornerRadius:8.0];
    [tractlabel.layer setBorderWidth:1.0];
    tractlabel.layer.borderColor=UIColorFromRGB(0Xe8e8e8).CGColor;
    [_shoppingCartButton addSubview:tractlabel];
    [self.contentView addSubview:_shoppingCartButton];
    
    hiLabel=[LJControl labelFrame:CGRectMake(0, 80, 100, 20) setText:@"无货" setTitleFont:15 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    hiLabel.alpha=0.7;
    hiLabel.hidden=YES;
    [photoImageView addSubview:hiLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
