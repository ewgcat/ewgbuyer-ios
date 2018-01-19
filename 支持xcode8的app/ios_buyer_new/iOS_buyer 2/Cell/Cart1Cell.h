//
//  Cart1Cell.h
//  My_App
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cart1Cell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationssLabel0;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UITextField *numericalTextField;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *specificationssLabel1;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;

@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UIImageView *markbgImageView;
@end
