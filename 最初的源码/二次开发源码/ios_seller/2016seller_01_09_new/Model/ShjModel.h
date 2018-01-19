//
//  ShjModel.h
//  SellerApp
//
//  Created by apple on 15-3-31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShjModel : NSObject
//常用物流配置
@property(retain, nonatomic) NSString *company_name;
@property(retain, nonatomic) NSString *ecc_common;
@property(retain, nonatomic) NSString *ecc_default;
@property(retain, nonatomic) NSString *ecc_id;

//发货地址列表
@property (retain, nonatomic) NSString *sa_id;
@property (retain, nonatomic) NSString *sa_addr;
@property (retain, nonatomic) NSString *sa_default;
@property (retain, nonatomic) NSString *sa_name;
@property (retain, nonatomic) NSString *sa_sequence;

//地区
@property (retain, nonatomic) NSString *sa_area_id;
@property (retain, nonatomic) NSString *sa_area_name;

@end
