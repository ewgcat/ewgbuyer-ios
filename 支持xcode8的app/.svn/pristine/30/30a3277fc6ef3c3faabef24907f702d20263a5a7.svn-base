//
//  GoodsDetailCell7.m
//  My_App
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDetailCell7.h"

@implementation GoodsDetailCell7
{
    UILabel *liftLabel;
    UILabel *rightLabel;
    UILabel *labelDragUp;
}

-(void)setLiftStr:(NSString *)liftStr{
    _liftStr=liftStr;
    liftLabel.text=liftStr;
}
-(void)setRightStr:(NSString *)rightStr{
    _rightStr=rightStr;
    rightLabel.text=rightStr;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    CGFloat trans = -10;
    _liftbutton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(10, 10 + trans,ScreenFrame.size.width/2-20, 40) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    liftLabel=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width/2-20, 40) setText:_liftStr setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    liftLabel.layer.cornerRadius=4;
    liftLabel.layer.masksToBounds= YES;
    liftLabel.layer.borderWidth = 0.5;
    liftLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_liftbutton addSubview:liftLabel];
    [self.contentView addSubview:_liftbutton];
    
    _rightbutton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/2+10,10 + trans,ScreenFrame.size.width/2-20, 40) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    rightLabel=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width/2-20, 40) setText:_rightStr setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    rightLabel.layer.cornerRadius=4;
    rightLabel.layer.masksToBounds= YES;
    rightLabel.layer.borderWidth = 0.5;
    rightLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_rightbutton addSubview:rightLabel];
    [self.contentView addSubview:_rightbutton];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
