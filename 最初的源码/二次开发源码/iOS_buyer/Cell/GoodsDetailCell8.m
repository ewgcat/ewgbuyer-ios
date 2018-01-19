//
//  GoodsDetailCell8.m
//  My_App
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDetailCell8.h"

@implementation GoodsDetailCell8
{
    __weak IBOutlet UIImageView *storeLogo;
    __weak IBOutlet UILabel *storeName;
    __weak IBOutlet UIView *storeRateView;
    UILabel *allGoodsLabel;
    UILabel *concernedLabel;
    UILabel *descriptionLabel;
    UILabel *serviceLabel;
    UILabel *shipLabel;
}
-(void)setStoreInfoDictionary:(NSDictionary *)storeInfoDictionary{
    _storeInfoDictionary=storeInfoDictionary;
    [storeLogo sd_setImageWithURL:[NSURL URLWithString:[storeInfoDictionary objectForKey:@"store_logo"]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
    storeName.text=[NSString stringWithFormat:@"%@",[storeInfoDictionary objectForKey:@"store_name"]];
    allGoodsLabel.text=[NSString stringWithFormat:@"%@",[storeInfoDictionary objectForKey:@"store_goods_count"]];
    concernedLabel.text=[NSString stringWithFormat:@"%@",[storeInfoDictionary objectForKey:@"store_concern_count"]];
    descriptionLabel.text=[NSString stringWithFormat:@"描述相似:%@",[storeInfoDictionary objectForKey:@"description_evaluate"]];
    serviceLabel.text=[NSString stringWithFormat:@"服务态度:%@",[storeInfoDictionary objectForKey:@"service_evaluate"]];
    shipLabel.text=[NSString stringWithFormat:@"发货速度:%@",[storeInfoDictionary objectForKey:@"ship_evaluate"]];
    
    CGFloat storeRate=[[storeInfoDictionary objectForKey:@"store_rate"] floatValue];
    int count=(int)roundf(storeRate);
    NSLog(@"%d",count);
    for (int i=0; i<count; i++) {
        UIImageView *image=[LJControl imageViewFrame:CGRectMake(15*i, 5, 15, 15) setImage:@"star_lj.png" setbackgroundColor:[UIColor clearColor]];
        [storeRateView addSubview:image];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
    storeLogo.layer.borderWidth = 1;
    storeLogo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UIView *view1=[LJControl viewFrame:CGRectMake(10, 80, ScreenFrame.size.width/3-20, 80) backgroundColor:[UIColor clearColor]];
    allGoodsLabel=[LJControl labelFrame:CGRectMake(0, 20, ScreenFrame.size.width/3-20, 25) setText:@"100" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentCenter];
    [view1 addSubview:allGoodsLabel];
    UILabel *allGoods=[LJControl labelFrame:CGRectMake(0, 45, ScreenFrame.size.width/3-20, 25) setText:@"全部商品" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [view1 addSubview:allGoods];
    [self.contentView addSubview:view1];
    
    CGFloat lY = 89;
    CGFloat lH = 62;
    
    UILabel *l=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3, lY, 1, lH) setText:@"" setTitleFont:0 setbackgroundColor:LINE_COLOR setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:l];
    
    UIView *view2=[LJControl viewFrame:CGRectMake(10+ScreenFrame.size.width/3, 80, ScreenFrame.size.width/3-20, 80) backgroundColor:[UIColor clearColor]];
    concernedLabel=[LJControl labelFrame:CGRectMake(0, 20, ScreenFrame.size.width/3-20, 25) setText:@"100" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentCenter];
    [view2 addSubview:concernedLabel];
    UILabel *concerned=[LJControl labelFrame:CGRectMake(0, 45, ScreenFrame.size.width/3-20, 25) setText:@"关注人数" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [view2 addSubview:concerned];
    [self.contentView addSubview:view2];
    
    UILabel *ll=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3*2, lY, 1, lH) setText:@"" setTitleFont:0 setbackgroundColor:LINE_COLOR setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:ll];
    
    UIView *view3=[LJControl viewFrame:CGRectMake(10+ScreenFrame.size.width/3*2, 80,ScreenFrame.size.width/3-20, 80) backgroundColor:[UIColor clearColor]];
    descriptionLabel=[LJControl labelFrame:CGRectMake(0,10, ScreenFrame.size.width/3-20, 20) setText:@"描述相似:5.0" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [view3 addSubview:descriptionLabel];
    serviceLabel=[LJControl labelFrame:CGRectMake(0,30, ScreenFrame.size.width/3-20, 20) setText:@"服务态度:5.0" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [view3 addSubview:serviceLabel];
    shipLabel=[LJControl labelFrame:CGRectMake(0,50, ScreenFrame.size.width/3-20, 20) setText:@"发货速度:5.0" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [view3 addSubview:shipLabel];
    [self.contentView addSubview:view3];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
