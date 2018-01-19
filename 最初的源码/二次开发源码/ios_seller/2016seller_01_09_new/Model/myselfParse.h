//
//  myselfParse.h
//  SellerApp
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myselfParse : NSObject
@property (nonatomic ,strong)NSDictionary *dicBig;

+(myselfParse *)parse:(NSDictionary *)reponseObj;
+(myselfParse *)parseFail:(NSDictionary *)reponseObj;

@end
