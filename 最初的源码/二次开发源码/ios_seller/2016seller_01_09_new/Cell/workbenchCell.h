//
//  workbenchCell.h
//  SellerApp
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface workbenchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *overCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitsureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitMoneyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitestimateCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitSendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *overBtn;

@property (weak, nonatomic) IBOutlet UIButton *waitSendBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitEstimateBtn;






@end
