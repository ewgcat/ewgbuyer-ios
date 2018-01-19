//
//  pingjiaCell.m
//  My_App
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "pingjiaCell.h"

@implementation pingjiaCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

    CALayer *lay  =  _touImage.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:9.0];
    
    _questionLabel = [LJControl labelFrame:CGRectMake(40, 60, ScreenFrame.size.width-55, 30) setText:@"" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    _questionLabel.numberOfLines = 0;
    [self addSubview:_questionLabel];
    
    _repluR = [LJControl labelFrame:CGRectMake(40, _questionLabel.frame.size.height+_questionLabel.frame.origin.y, ScreenFrame.size.width-140, 64) setText:@"商家回复:" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_repluR];
    
    UIImageView *replyImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopreply.png"]];
    replyImgv.frame = CGRectMake(20, _repluR.frame.origin.y, 15, 14);
    _replyImgv = replyImgv;
    [self addSubview:replyImgv];
    
    
    _replyTime = [LJControl labelFrame:CGRectMake(ScreenFrame.size.width-135, _questionLabel.frame.size.height+_questionLabel.frame.origin.y, 120, 20) setText:@"回复时间" setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0xcdcdcd) textAlignment:NSTextAlignmentRight];
    [self addSubview:_replyTime];
    
    _replyLabel = [LJControl labelFrame:CGRectMake(40, _questionLabel.frame.size.height+_questionLabel.frame.origin.y, ScreenFrame.size.width-55, 30) setText:@"" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    _replyLabel.numberOfLines = 0;
    [self addSubview:_replyLabel];
}
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x-15,  0)];
    return labelFrameTie;
}
-(void)setData:(ClassifyModel *)model{
    _name.text = model.ping_user;
    _time.text = model.ping_addTime;
    [_questionLabel setFrame:[self labelSizeHeight:model.ping_content frame:CGRectMake(40, 50, 0.0, 0.0) font:15]];
    _questionLabel.text = model.ping_content;
    
    if ([model.ping_reply intValue] == 1) {
        _repluR.hidden = NO;
        _replyImgv.hidden = NO;
        _replyTime.hidden = NO;
        _replyLabel.hidden = NO;
        [_repluR setFrame:CGRectMake(40, _questionLabel.frame.size.height+_questionLabel.frame.origin.y, ScreenFrame.size.width-135, 20)];
//        _repluR.text = [NSString stringWithFormat:@"商家回复:%@",model.ping_reply_user];
         _repluR.text = [NSString stringWithFormat:@"%@回复:",model.ping_reply_user];
        [_replyTime setFrame:CGRectMake(ScreenFrame.size.width-135, _questionLabel.frame.size.height+_questionLabel.frame.origin.y, 120, 20)];
        _replyTime.text = model.ping_reply_time;
        
        [_replyLabel setFrame:[self labelSizeHeight:model.ping_reply_content frame:CGRectMake(40, _repluR.frame.size.height+_repluR.frame.origin.y, 0.0, 0.0) font:15]];
        _replyLabel.text = model.ping_reply_content;
        
    }else{
        _repluR.hidden = YES;
        _replyImgv.hidden = YES;
        _replyTime.hidden = YES;
        _replyLabel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
