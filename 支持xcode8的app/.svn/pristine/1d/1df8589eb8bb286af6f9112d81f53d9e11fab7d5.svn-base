//
//  GoodsDetailCell4.m
//  My_App
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDetailCell4.h"

@implementation GoodsDetailCell4
{
    UIImageView *imageView;
}
-(void)setAreaSelectionString:(NSString *)areaSelectionString{
    _areaSelectionString=areaSelectionString;
    CGRect rect=[areaSelectionString boundingRectWithSize:CGSizeMake(247-15, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _areaSelectionLabel.frame=CGRectMake(0, 0, rect.size.width, 35);
    imageView.frame=CGRectMake(rect.size.width+2, 10, 15, 15);
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    _areaSelectionLabel=[LJControl labelFrame:CGRectMake(0, 0, 80, 35) setText:@"局域网" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [_areaSelectionButton addSubview:_areaSelectionLabel];
    imageView=[LJControl imageViewFrame:CGRectMake(80, 10, 15, 15) setImage:@"position.png" setbackgroundColor:[UIColor clearColor]];
    [_areaSelectionButton addSubview:imageView];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
