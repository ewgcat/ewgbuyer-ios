//
//  Requester.h
//  My_App
//
//  Created by shiyuwudi on 16/2/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Requester : NSObject

+(NSMutableDictionary *)userDictWithIDAndToken;
+(AFHTTPRequestOperationManager *)manager;
+(AFHTTPRequestOperationManager *)managerWithHeader;
+(NSURLRequest *)requestByBaldURLString:(NSString *)str;//添加http://，转成请求格式
+(BOOL)isNetworkOK;
+(void)loginPostWithLastURL:(NSString *)lastURL par:(NSDictionary *)par description:(NSString *)description success:(void(^)(NSDictionary *dict))success;
+(void)postWithLastURL:(NSString *)lastURL par:(NSDictionary *)par description:(NSString *)description success:(void(^)(NSDictionary *dict))success;

@end
