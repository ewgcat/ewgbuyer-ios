//
//  FGTableViewCell.m
//  My_App
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FGTableViewCell.h"

@implementation FGTableViewCell
{
    UIImageView *photoImageView;
    UILabel *nameLabel;
    UILabel *moneyLabel;
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
    }
}

- (void)commonInit
{
    [super commonInit];
    
    photoImageView=[LJControl imageViewFrame:CGRectMake(10, 10, 110, 110) setImage:@"kong_lj.png" setbackgroundColor:[UIColor clearColor]];
    //设置边框线的宽
    [photoImageView.layer setBorderWidth:0.5];
    //设置边框线的颜色
    [photoImageView.layer setBorderColor:[UIColorFromRGB(0Xe5e5e5) CGColor]];
    [self.myContentView addSubview:photoImageView];
    
    nameLabel=[LJControl labelFrame:CGRectMake(130, 10, ScreenFrame.size.width-140, 60) setText:@"" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X000000) textAlignment:NSTextAlignmentLeft];
    nameLabel.numberOfLines=2;
    [self.myContentView addSubview:nameLabel];
    
    moneyLabel=[LJControl labelFrame:CGRectMake(130, 80,  ScreenFrame.size.width-140, 30) setText:@"" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xd43e47) textAlignment:NSTextAlignmentLeft];
    moneyLabel.font=[UIFont boldSystemFontOfSize:14];
    [self.myContentView addSubview:moneyLabel];
    
    hiLabel=[LJControl labelFrame:CGRectMake(0, 90, 110, 20) setText:@"无货" setTitleFont:15 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    hiLabel.alpha=0.7;
    hiLabel.hidden=YES;
    [photoImageView addSubview:hiLabel];
    
    UILabel *ll=[LJControl labelFrame:CGRectMake(0, 129,  ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe5e5e5) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.myContentView addSubview:ll];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
