//
//  Cart2Cell.h
//  My_App
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cart2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UITextField *numericalTextField;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *specificationssLabel0;
@end
