//
//  templet_Five_Cell.h
//  My_App
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface templet_Five_Cell : UITableViewCell

@property (strong,nonatomic)UIImageView *imageView_one;
@property (strong,nonatomic)UIImageView *imageView_two;
@property (strong,nonatomic)UIImageView *imageView_three;
@property (strong,nonatomic)UIImageView *Line;
@property (strong,nonatomic)UIImageView *Line2;
@property (strong,nonatomic)UIButton *OneBtn;
@property (strong,nonatomic)UIButton *TwoBtn;
@property (strong,nonatomic)UIButton *ThreeBtn;
@property (strong,nonatomic)UIImageView *imageLine3;

-(void)setData_Left:(NSDictionary *)imageUrlLeft Middle:(NSDictionary *)imageUrlMiddle Right:(NSDictionary *)imageUrlRight;

@end
