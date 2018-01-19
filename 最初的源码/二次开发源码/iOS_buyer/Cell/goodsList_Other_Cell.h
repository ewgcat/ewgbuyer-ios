//
//  goodsList_Other_Cell.h
//  My_App
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsList_Other_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *leftPrice;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *rightName;
@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;





@property (weak, nonatomic) IBOutlet UIView *rightView;


-(void)setData:(ClassifyModel*)classleft rightModel:(ClassifyModel*)classright array:(int )arrCount;

@end
