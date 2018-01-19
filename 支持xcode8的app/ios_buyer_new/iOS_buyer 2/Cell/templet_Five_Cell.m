//
//  templet_Five_Cell.m
//  My_App
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "templet_Five_Cell.h"

@implementation templet_Five_Cell

#define LINE_WIDTH 1.f
#define LINE_COLOR1 RGB_COLOR(235, 235, 235)

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    _imageView_one = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width/3, 157)];
    [self addSubview:_imageView_one];
    _OneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OneBtn.frame = _imageView_one.frame;
    [self addSubview:_OneBtn];
    
    _imageView_three = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, 157)];
    [self addSubview:_imageView_three];
    _ThreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ThreeBtn.frame = _imageView_three.frame;
    [self addSubview:_ThreeBtn];
    
    _imageView_two = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, 157)];
    [self addSubview:_imageView_two];
    _TwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TwoBtn.frame = _imageView_two.frame;
    [self addSubview:_TwoBtn];
    
    _Line = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3, 0, LINE_WIDTH, self.frame.size.height-1)];
    _Line.backgroundColor = LINE_COLOR1;
    [self addSubview:_Line];
    _Line2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, LINE_WIDTH, self.frame.size.height-1)];
    _Line2.backgroundColor = LINE_COLOR1;
    [self addSubview:_Line2];
    _imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _imageView_one.frame.size.height, self.frame.size.width , LINE_WIDTH)];
    _imageLine3.backgroundColor = LINE_COLOR1;
    [self addSubview:_imageLine3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData_Left:(NSDictionary *)imageUrlLeft Middle:(NSDictionary *)imageUrlMiddle Right:(NSDictionary *)imageUrlRight{
    CGFloat www = [[imageUrlLeft objectForKey:@"width"] floatValue];
    CGFloat hhh = [[imageUrlLeft objectForKey:@"height"] floatValue];
    
    _imageView_one.frame = CGRectMake(0, 0, ScreenFrame.size.width/3, ScreenFrame.size.width/3*hhh/www);
    _imageView_two.frame = CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, ScreenFrame.size.width/3*hhh/www);
    _imageView_three.frame = CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, ScreenFrame.size.width/3*hhh/www);
    
    _Line.frame = CGRectMake(ScreenFrame.size.width/3, 0, 1, ScreenFrame.size.width/3*hhh/www);
    _Line2.frame = CGRectMake(ScreenFrame.size.width/3*2, 0, 1, ScreenFrame.size.width/3*hhh/www);
    _imageLine3.frame = CGRectMake(0, ScreenFrame.size.width/3*hhh/www, ScreenFrame.size.width, 1);
    
    [_imageView_one sd_setImageWithURL:[NSURL URLWithString:[imageUrlLeft objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
    [_imageView_two sd_setImageWithURL:[NSURL URLWithString:[imageUrlMiddle objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
    [_imageView_three sd_setImageWithURL:[NSURL URLWithString:[imageUrlRight objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
}
@end
