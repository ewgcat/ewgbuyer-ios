//
//  UserCenterTableViewCell.h
//  My_App
//
//  Created by 邱炯辉 on 16/9/13.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIImageView *logCircleImageview;
@property (weak, nonatomic) IBOutlet UIImageView *logPhotoImageview;


@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

@property (weak, nonatomic) IBOutlet UIView *blackBottomView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageview;

//
@property (strong, nonatomic)  UIImageView *NotLoggedphotoButton;
@property (strong, nonatomic)  UIImageView *NotLoggedcircleImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
