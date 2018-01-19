//
//  normalGoodsEvaluation_TieCell.m
//  My_App
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "normalGoodsEvaluation_TieCell.h"

@implementation normalGoodsEvaluation_TieCell

- (void)awakeFromNib {
    // Initialization code
    _labelContent = [LJControl labelFrame:CGRectMake(15, 50, ScreenFrame.size.width-30, 30) setText:@"" setTitleFont:16 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    _labelContent.numberOfLines = 0;
    [self addSubview:_labelContent];
    
    _Tiecontent = [LJControl labelFrame:CGRectMake(15, _labelContent.frame.size.height+_labelContent.frame.origin.y, ScreenFrame.size.width-30, 30) setText:@"" setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    _Tiecontent.numberOfLines = 0;
    [self addSubview:_Tiecontent];
    
    _labelspec = [LJControl labelFrame:CGRectMake(15, _Tiecontent.frame.size.height+_Tiecontent.frame.origin.y, ScreenFrame.size.width-30, 30) setText:@"" setTitleFont:11 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    _labelspec.numberOfLines = 0;
    [self addSubview:_labelspec];
}
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}
-(void)setData:(ClassifyModel *)model{
    _userName.text = model.ping_user;
    if (model.ping_content.length == 0) {
        [_labelContent setFrame:CGRectMake(15, 50, ScreenFrame.size.width, 30)];
        _labelContent.text = @"该用户没有做出评论！";
        
        [_Tiecontent setFrame:[self labelSizeHeight:model.ping_Tie frame:CGRectMake(15, 80, 0.0, 0.0) font:13]];
        _Tiecontent.text = model.ping_Tie;
        
        [_labelspec setFrame:[self labelSizeHeight:[NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec] frame:CGRectMake(15, 80+_Tiecontent.frame.size.height, 0.0, 0.0) font:12]];
        _labelspec.text = [NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec];
        
    }else{
        [_labelContent setFrame:[self labelSizeHeight:model.ping_content frame:CGRectMake(15, 50, 0.0, 0.0) font:16]];
        _labelContent.text = model.ping_content;
        
        [_Tiecontent setFrame:[self labelSizeHeight:model.ping_Tie frame:CGRectMake(15, _labelContent.frame.origin.y, 0.0, 0.0) font:13]];
        _Tiecontent.text = model.ping_Tie;
        
        [_labelspec setFrame:[self labelSizeHeight:[NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec] frame:CGRectMake(15, _Tiecontent.frame.origin.y, 0.0, 0.0) font:12]];
        _labelspec.text = [NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
