//
//  RemainderCouponsListCell.h
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemainderCouponsListCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *SymbolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImage;
//@property (weak, nonatomic) IBOutlet UIImageView *OverImage;
@property (weak, nonatomic) IBOutlet UILabel *CouponsPrice;
@property (weak, nonatomic) IBOutlet UILabel *CouponsUseInfo;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UILabel *CouponsName;
@property (weak, nonatomic) IBOutlet UILabel *CouponsTime;
@property (weak, nonatomic) IBOutlet UILabel *RemainderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coupons_right;
-(void)setData:(ClassifyModel *)model;
@end
