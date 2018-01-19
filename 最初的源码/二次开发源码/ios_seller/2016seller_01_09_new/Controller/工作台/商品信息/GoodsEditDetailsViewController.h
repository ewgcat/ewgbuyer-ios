//
//  GoodsEditDetailsViewController.h
//  2016seller_01_09_new
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "BaseViewControllerNoTabbar.h"
#import "goodsModel.h"

@protocol GoodsEditDetailsViewControllerDelegate <NSObject>

-(void)getGoodsEditDetailsData:(NSArray *)goodsSpecIds andGoodsSpecIdValue:(NSArray*)goodsSpecIdValues andGoodsInventoryDetail:(NSArray *)goodsInventoryDetails;

@end

@interface GoodsEditDetailsViewController : BaseViewControllerNoTabbar

@property(nonatomic,strong)goodsModel *model;
@property(nonatomic,strong)NSString *speFlay;
@property(nonatomic,strong)NSArray *seleArray;
@property(nonatomic,assign)id<GoodsEditDetailsViewControllerDelegate>delegate;

@end
