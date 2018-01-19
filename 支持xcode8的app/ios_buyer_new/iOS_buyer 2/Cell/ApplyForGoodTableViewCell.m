//
//  ApplyForGoodTableViewCell.m
//  
//
//  Created by apple on 15/10/22.
//
//

#import "ApplyForGoodTableViewCell.h"
#import "LoginViewController.h"

@implementation ApplyForGoodTableViewCell
{
    __weak IBOutlet UIImageView *photoimage;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *numlabel;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [photoimage.layer setMasksToBounds:YES];
    [photoimage.layer setBorderWidth:1];
    [photoimage.layer setBorderColor:[UIColorFromRGB(0Xd7d7d7) CGColor]];
    
    nameLabel.textColor=UIColorFromRGB(0X333333);
    numlabel.textColor=UIColorFromRGB(0X797979);
    
    LoginViewController *log = [LoginViewController sharedUserDefault];
    
    [photoimage sd_setImageWithURL:[NSURL URLWithString: log.return_ImagePhoto]];
    nameLabel.text=log.return_Name;
    numlabel.text=[NSString stringWithFormat:@"￥%@    数量:%@",log.return_goods_price ,log.return_goods_count];

    
//    [photoimage sd_setImageWithURL:[NSURL URLWithString:@"http://192.168.1.209:90/upload/store/5/51505632-8010-468e-ae0d-42e8029e80e2.jpg"]];
//    nameLabel.text=@"和首都萨hi对按时擦伤擦撒uh独护士撒回复i爱是对是";
//    numlabel.text=@"￥430.99  数量：33";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
