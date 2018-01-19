//
//  StoreHomeInfoModel.h
//  My_App
//
//  Created by barney on 15/11/3.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>
// 店铺首页collectionView的cell数据model
@interface StoreHomeInfoModel : NSObject

@property(nonatomic,strong) NSString * goods_current_price;
@property(nonatomic,strong) NSString * goods_main_photo;
@property(nonatomic,strong) NSString * goods_name;
@property(nonatomic,strong) NSString * id;

@end
