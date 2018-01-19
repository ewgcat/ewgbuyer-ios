//
//  GoodsCell.h
//  SellerApp
//
//  Created by apple on 15/5/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface GoodsCell : UITableViewCell
@property (strong,nonatomic)UIView *view;
@property (strong,nonatomic)UILabel *orderid_label;
@property (strong,nonatomic)UILabel *timeadd_label;
@property (strong,nonatomic)UIImageView *image;
@property (strong,nonatomic)UIImageView *imagek;
@property (strong,nonatomic)UIButton *buttonSelect;
@property (strong,nonatomic)UIButton *buttonEdit;
@property (strong,nonatomic)UIView *selectview;
-(void)my_cell:(Model *)model goodid_Str:(NSString *)goodid_Str;

@end
