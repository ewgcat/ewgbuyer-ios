//
//  StoreHomeTopModel.h
//  My_App
//
//  Created by barney on 15/11/5.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>
// 店铺首页顶部店铺名称的model
@interface StoreHomeTopModel : NSObject

@property(nonatomic,strong) NSString * store_name;
@property(nonatomic,strong) NSString * store_logo;
@property(nonatomic,strong) NSString * fans_count;
@property(nonatomic,strong) NSString * favourited;

@end
