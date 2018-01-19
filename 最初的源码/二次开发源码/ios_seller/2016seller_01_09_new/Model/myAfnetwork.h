//
//  myAfnetwork.h
//  SellerApp
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "myselfParse.h"

@interface myAfnetwork : NSObject


+(void)url:(NSString *)parameter_url verify:(NSString *)verify getChat:(void(^)(myselfParse * myParse))success failure:(void(^)())failure ;

+(void)netWorkingURL:(NSString *)parameterURL parameters:(NSDictionary *)dic andWay:(NSString *)way getParseSuccess:(void(^)(myselfParse * parse))success getParsefailure:(void(^)())failure;

@end
