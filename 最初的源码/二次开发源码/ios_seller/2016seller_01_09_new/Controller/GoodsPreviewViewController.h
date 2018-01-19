//
//  GoodsPreviewViewController.h
//  2016seller_01_09_new
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "BaseViewControllerNoTabbar.h"
#import "goodsModel.h"
@interface GoodsPreviewViewController : BaseViewControllerNoTabbar

@property(nonatomic,strong)goodsModel *model;
@property(nonatomic,copy)NSString *staticID;
@end
