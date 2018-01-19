//
//  ;
//  My_App
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pingjiaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *touImage;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UILabel *replyLabel;
@property (strong, nonatomic) UILabel *repluR;
@property (strong, nonatomic) UILabel *replyTime;
@property (nonatomic, weak)UIImageView *replyImgv;

-(void)setData:(ClassifyModel *)model;
@end
