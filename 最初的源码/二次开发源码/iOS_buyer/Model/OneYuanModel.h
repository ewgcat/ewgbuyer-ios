//
//  OneYuanModel.h
//  My_App
//
//  Created by shiyuwudi on 16/2/14.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudPurchaseGoods.h"

@interface OneYuanModel : NSObject

//最新揭晓,上架新品
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSArray *picUrlArray;
@property (nonatomic, strong)NSArray *prizeWinnerArray;
@property (nonatomic, strong)NSArray *freshGoodsNameArray;

//今日热门商品
@property (nonatomic, copy)NSString *specialTitle;
@property (nonatomic, copy)NSString *picUrl;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *progress;
@property (nonatomic, assign)BOOL addedToCart;

//商品详情
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, strong)CloudPurchaseGoods *cloudPurchaseGoods;
@property (nonatomic, copy)NSString *deleteStatus;
@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *period;
@property (nonatomic, copy)NSString *purchased_times;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *lucky_username;

@end
