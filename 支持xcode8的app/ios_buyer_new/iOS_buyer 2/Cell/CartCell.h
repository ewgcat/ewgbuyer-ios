//
//  CartCell.h
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell<UITextFieldDelegate>{
    UILabel *labelTi;
    NSInteger jie;
    NSInteger qianCount;
}
@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UILabel *zongPrice;
@property (weak, nonatomic) IBOutlet UILabel *carid;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nsme;
@property (weak, nonatomic) IBOutlet UILabel *bian;
@property (weak, nonatomic) IBOutlet UILabel *huo;
@property (weak, nonatomic) IBOutlet UIButton *minuBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextField *count;

@property (weak, nonatomic) IBOutlet UIButton *xuanzhongBtn;
@property (weak, nonatomic) IBOutlet UITextField *countcheng;

@property (weak, nonatomic) IBOutlet UILabel *countMy;
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;

@property (weak, nonatomic) IBOutlet UILabel *minusLabel;

+(id)sharedUserDefault;

@end
