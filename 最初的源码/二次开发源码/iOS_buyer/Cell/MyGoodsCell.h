//
//  MyGoodsCell.h
//  My_App
//
//  Created by barney on 15/11/4.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreHomeInfoModel.h"
// 自定义的collectionView cell
@interface MyGoodsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLable;
@property (weak, nonatomic) IBOutlet UILabel *gooodsPriceLable;

-(void) config:(StoreHomeInfoModel *) model;

@end
