//
//  CloudCartCell.h
//  My_App
//
//  Created by shiyuwudi on 16/2/16.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneYuanModel.h"
#import "CloudPurchaseGoods.h"
#import "CloudCart.h"
#import "CloudPurchaseLottery.h"

@interface CloudCartCell : UITableViewCell

@property (nonatomic, strong)CloudCart *model;

+(instancetype)cell;
+(CGFloat)cellHeight;

-(void)setPurchasedNumber;

@end
