//
//  GoodsSpecModel.h
//  2016seller_01_09_new
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsSpecModel : NSObject

//spec_list
@property(nonatomic,strong)NSString *specId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *property;
@property(nonatomic,strong)NSString *type;
//specification_detail
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *detailId;
@property(nonatomic,strong)NSArray *detailIdArray;
@property(nonatomic,strong)NSString *detailValue;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *supp;

@end
