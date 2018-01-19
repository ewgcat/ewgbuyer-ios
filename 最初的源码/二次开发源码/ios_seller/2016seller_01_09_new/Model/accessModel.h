//
//  accessModel.h
//  SellerApp
//
//  Created by barney on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface accessModel : NSObject
@property(retain, nonatomic) NSString *goods_click;
@property(retain, nonatomic) NSString *goods_click_yesterday;
@property(retain, nonatomic) NSString *goods_id;
@property(retain, nonatomic) NSString *goods_name;
@property(retain, nonatomic) NSString *main_photo;

@property(retain, nonatomic) NSString *goods_salenum;
@property(retain, nonatomic) NSString *goods_salenum_yesterday;

@end
