//
//  PayofflogCell.h
//  SellerApp
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface PayofflogCell : UITableViewCell
-(void)my_cell:(Model *)mm;
@property(nonatomic,weak)UIButton *checkBtn;
@property(nonatomic,strong)Model *model;
@end
