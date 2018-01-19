//
//  HomeModel.h
//  SellerApp
//
//  Created by barney on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property(retain, nonatomic) NSString *store_name;
@property(retain, nonatomic) NSString *store_logo;
@property(retain, nonatomic) NSString *validity;
@property(retain, nonatomic) NSString *browsing_times;
@property(retain, nonatomic) NSString *order_quantity;
@property(retain, nonatomic) NSString *total_transactions;
@property(retain, nonatomic) NSMutableArray *article_title;


@end
