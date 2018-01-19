//
//  MyNetTool.h
//  SellerApp
//
//  Created by shiyuwudi on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNetTool : NSObject

//通用
+(AFHTTPRequestOperationManager *)manager;
+(AFHTTPRequestOperationManager *)managerWithVerify;
//用户信息
+(NSString *)currentUserName;
+(NSString *)currentUserID;
+(NSString *)currentToken;
+(NSString *)currentVerify;
+(NSArray *)hasUserLogedIn:(BOOL *)flag;
+(NSString *)serviceID;
//检查重复登录
+(BOOL)checkLogin:(NSDictionary *)dict;
//退出登录
+(void)logout;
//推送
+(void)pushBind;
//站内信
+(void)requestForMessageSelectCount:(NSString *)selectCount success:(void(^)(NSMutableArray *modelArray))success;
//库存预警
+(void)requestForStockWarningSuccess:(void(^)(NSMutableArray *modelArray))success;
//退款
+(void)requestForRefundStatusBegin:(NSString *)begin select:(NSString *)select success:(void(^)(NSMutableArray *modelArray))success;
//退货
+(void)requestForReturnStatusBegin:(NSString *)begin select:(NSString *)select success:(void(^)(NSMutableArray *modelArray))success;
@end
