//
//  UserCenterTableViewCell.m
//  My_App
//
//  Created by 邱炯辉 on 16/9/13.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "UserCenterTableViewCell.h"

@implementation UserCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled=YES;
    [_logPhotoImageview.layer setMasksToBounds:YES];
    [_logPhotoImageview.layer setCornerRadius:42];
    _logPhotoImageview.layer.borderColor = [[UIColor whiteColor] CGColor];
    _logPhotoImageview.layer.borderWidth = 1;
    
    [_logCircleImageview.layer setMasksToBounds:YES];
    [_logCircleImageview.layer setCornerRadius:46];
    _logCircleImageview.layer.borderColor = [RGB_COLOR(234, 141, 142) CGColor];
    _logCircleImageview.layer.borderWidth = 1.5;
    
    
    [_messageCountLabel.layer setMasksToBounds:YES];
    [_messageCountLabel.layer setCornerRadius:10];
    
    [self createNotLogUI];
}
-(void)createNotLogUI{
    _NotLoggedphotoButton=[[UIImageView alloc]init];
    _NotLoggedphotoButton.frame=CGRectMake(0, 0, 84, 84);

    _NotLoggedphotoButton.center=CGPointMake(ScreenFrame.size.width/2,114 );
    [_NotLoggedphotoButton setImage:[UIImage imageNamed:@"integral_logbtn"]];
    [self.contentView addSubview:_NotLoggedphotoButton];
    [_NotLoggedphotoButton.layer setMasksToBounds:YES];
    [_NotLoggedphotoButton.layer setCornerRadius:42];
    _NotLoggedphotoButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _NotLoggedphotoButton.layer.borderWidth = 1;
    //            [_NotLoggedphotoButton setImage:[UIImage imageNamed:@"integral_logbtn"] ];
    _NotLoggedcircleImage=[[UIImageView alloc]init];
    _NotLoggedcircleImage.frame=CGRectMake(0, 0, 94, 94);

    _NotLoggedcircleImage.center=CGPointMake(ScreenFrame.size.width/2,114 );
    [self.contentView addSubview:_NotLoggedcircleImage];

    
    [_NotLoggedcircleImage.layer setMasksToBounds:YES];
    [_NotLoggedcircleImage.layer setCornerRadius:46];
    _NotLoggedcircleImage.layer.borderColor = [RGB_COLOR(234, 141, 142) CGColor];
    _NotLoggedcircleImage.layer.borderWidth = 1.5;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
