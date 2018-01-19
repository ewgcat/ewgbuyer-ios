//
//  templet_six_Cell.m
//  My_App
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "templet_six_Cell.h"

@implementation templet_six_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    CGFloat sw = ScreenFrame.size.width;
    CGFloat h1 = SEVEN_HEIGHT/2;
    CGFloat h2 = SEVEN_HEIGHT-h1;
    CGFloat w2 = (sw-2.0)/3.0;
    
    _imageView_one = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (sw-2.0)/3.0, SEVEN_HEIGHT)];
    [self addSubview:_imageView_one];
    _OneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OneBtn.frame = _imageView_one.frame;
    [self addSubview:_OneBtn];
    
//    _imageView_two = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*227/650, 0, ScreenFrame.size.width-ScreenFrame.size.width*227/650, (ScreenFrame.size.width-ScreenFrame.size.width*227/650)*129/422)];
    _imageView_two = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_one.right+1, 0, sw-_imageView_one.right-1, h1)];
    [self addSubview:_imageView_two];
    _TwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TwoBtn.frame = _imageView_two.frame;
    [self addSubview:_TwoBtn];
    
    _imageView_three = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_two.left, _imageView_two.bottom+1, w2, h2)];
    [self addSubview:_imageView_three];
    _ThreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ThreeBtn.frame = _imageView_three.frame;
    [self addSubview:_ThreeBtn];
    
    _imageView_four = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_three.right+1, _imageView_three.top, w2, h2)];
    [self addSubview:_imageView_four];
    _FourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _FourBtn.frame = _imageView_four.frame;
    [self addSubview:_FourBtn];
    
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_one.frame.size.width, 0, 0.5, SEVEN_HEIGHT)];
    _line.backgroundColor = RGB_COLOR(235, 235, 235);
    [self addSubview:_line];
    _line2 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_one.frame.size.width, _imageView_two.frame.size.height, ScreenFrame.size.width-_imageView_one.frame.size.width, 0.5)];
    _line2.backgroundColor = RGB_COLOR(235, 235, 235);
    [self addSubview:_line2];
    _line3 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_one.frame.size.width+_imageView_four.frame.size.width, _imageView_two.frame.size.height, 0.5, _imageView_four.frame.size.height)];
    _line3.backgroundColor = RGB_COLOR(235, 235, 235);
    [self addSubview:_line3];
    _line4 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView_one.frame.size.width+_imageView_four.frame.size.width, _imageView_two.frame.size.height, 0.5, _imageView_four.frame.size.height)];
    _line4.backgroundColor = RGB_COLOR(235, 235, 235);
    [self addSubview:_line4];
    
    self.backgroundColor = BACKGROUNDCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData_Left:(NSDictionary *)imageUrlLeft Middle:(NSDictionary *)imageUrlMiddle BottomLeft:(NSDictionary *)bottomUrlLeft BottomRight:(NSDictionary *)bottomUrlRight{
    CGFloat www = [[imageUrlLeft objectForKey:@"width"] floatValue];
    CGFloat hhh = [[imageUrlLeft objectForKey:@"height"] floatValue];
    
    CGFloat h = ScreenFrame.size.width/3.0*hhh/www;
    CGFloat h1 = h/(129+210)*129;//固定比例
    CGFloat h2 = h - h1;
    
    _imageView_one.frame = CGRectMake(0, 0, ScreenFrame.size.width/3.0, h);
    _imageView_two.frame = CGRectMake(ScreenFrame.size.width/3.0, 0, ScreenFrame.size.width-ScreenFrame.size.width/3.0, h1);
    _imageView_three.frame = CGRectMake(ScreenFrame.size.width/3.0, _imageView_two.frame.size.height, ScreenFrame.size.width/3.0, h2);
    _imageView_four.frame = CGRectMake(_imageView_three.frame.origin.x+ScreenFrame.size.width/3.0, _imageView_two.frame.size.height, ScreenFrame.size.width/3.0, h2);
    
    _line.frame = CGRectMake(ScreenFrame.size.width/3.0, 0, 1, ScreenFrame.size.width/3.0*hhh/www);
    _line2.frame = CGRectMake(ScreenFrame.size.width/3.0, _imageView_two.frame.size.height, _imageView_two.frame.size.width, 1);
    _line3.frame = CGRectMake(_imageView_four.frame.origin.x, _imageView_four.frame.origin.y, 1, h2);
    _line4.frame = CGRectMake(0, ScreenFrame.size.width/3.0*hhh/www, ScreenFrame.size.width, 1);
    
    [_imageView_one sd_setImageWithURL:[NSURL URLWithString:[imageUrlLeft objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
    [_imageView_two sd_setImageWithURL:[NSURL URLWithString:[imageUrlMiddle objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
    [_imageView_three sd_setImageWithURL:[NSURL URLWithString:[bottomUrlLeft objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
    [_imageView_four sd_setImageWithURL:[NSURL URLWithString:[bottomUrlRight objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"pure_gray"]];
}
@end
