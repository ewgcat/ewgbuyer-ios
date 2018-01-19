//
//  UsercenterCell.m
//  My_App
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UsercenterCell.h"

@implementation UsercenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_photoImage.layer setMasksToBounds:YES];
    [_photoImage.layer setCornerRadius:42];
    _photoImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    _photoImage.layer.borderWidth = 1;
    
    [_circleImage.layer setMasksToBounds:YES];
    [_circleImage.layer setCornerRadius:46];
    _circleImage.layer.borderColor = [RGB_COLOR(234, 141, 142) CGColor];
    _circleImage.layer.borderWidth = 1.5;
    
    [_notLoggedphotoImage.layer setMasksToBounds:YES];
    [_notLoggedphotoImage.layer setCornerRadius:42];
    _notLoggedphotoImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    _notLoggedphotoImage.layer.borderWidth = 1;
    [_notLoggedphotoImage setImage:[UIImage imageNamed:@"integral_logbtn"] ];
    
    [_notLoggedcircleImage.layer setMasksToBounds:YES];
    [_notLoggedcircleImage.layer setCornerRadius:46];
    _notLoggedcircleImage.layer.borderColor = [RGB_COLOR(234, 141, 142) CGColor];
    _notLoggedcircleImage.layer.borderWidth = 1.5;
}
// 未赋值的key会报错
-(void)  setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
