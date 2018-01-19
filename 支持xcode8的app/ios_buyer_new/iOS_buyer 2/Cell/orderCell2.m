//
//  orderCell2.m
//  My_App
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//0

#import "orderCell2.h"

@implementation orderCell2
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *photoImage;
    __weak IBOutlet UILabel *specLabel;
    __weak IBOutlet UILabel *priceLabel;
    __weak IBOutlet UILabel *countLabel;

}
-(void)setModel:(Model *)model andIndexRow:(NSInteger)row{
    NSArray *arr = (NSArray*)model.order_photo_list;
    NSArray *name_Array = (NSArray*)model.order_name_list;
    NSArray *gsp_Array = (NSArray*)model.order_gsp_list;
    NSArray *count_Array = (NSArray*)model.order_count_list;
    NSArray *price_Array = (NSArray*)model.order_price_list;

    [photoImage sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:row]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
    nameLabel.text = [name_Array objectAtIndex:row];
    NSString *gspStr = [NSString stringWithFormat:@"%@",[gsp_Array objectAtIndex:row]];
    NSArray *gspStrArray = [gspStr componentsSeparatedByString:@"\n"];
    NSString *gspString = [gspStrArray componentsJoinedByString:@" "];
    specLabel.text = [NSString stringWithFormat:@"%@\n",gspString];
    countLabel.text = [count_Array objectAtIndex:row];
    priceLabel.text = [price_Array objectAtIndex:row];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
