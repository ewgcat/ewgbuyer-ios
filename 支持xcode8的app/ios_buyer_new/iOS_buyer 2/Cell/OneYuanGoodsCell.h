//
//  OneYuanGoodsCell.h
//  My_App
//
//  Created by barney on 16/2/15.
//  Copyright © 2016年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneYuanModel.h"
#import "CloudPurchaseGoods.h"

@class OneYuanGoodsCell;

@protocol OneYuanGoodsCellDelegate <NSObject>

@optional
-(void)addToCartBtnClicked:(OneYuanGoodsCell *)cell;

@end

@interface OneYuanGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *allPeople;
@property (weak, nonatomic) IBOutlet UILabel *unAll;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *specialImg;
@property (strong, nonatomic) OneYuanModel *model;
@property (weak, nonatomic)id<OneYuanGoodsCellDelegate> delegate;

+(CGFloat)cellHeight;

@end
