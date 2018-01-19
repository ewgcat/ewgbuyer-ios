//
//  MyNetTool.m
//  SellerApp
//
//  Created by shiyuwudi on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//
#import "RefundModel.h"
#import "ReturnModel.h"
#import "MyNetTool.h"
#import "StoreMsgModel.h"
#import "StockWarningModel.h"

@implementation MyNetTool
+(NSString *)serviceID {
    NSString *key = @"chat_need_service_id";
    NSNumber *service_id1 = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSString *service_id = [NSString stringWithFormat:@"%@",service_id1];
    return service_id;
}
+(void)requestForReturnStatusBegin:(NSString *)begin select:(NSString *)select success:(void (^)(NSMutableArray *))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_URL];
    
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"status":@"1",
                          @"begin_count":begin,
                          @"select_count":select
                          };
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s,%@",__func__,responseObject);
        NSDictionary *dict = responseObject;
        BOOL login = [self checkLogin:dict];
        if (!login) return;
        NSArray *arr = dict[@"returnGoodsLog"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict1 in arr) {
            ReturnModel *model = [ReturnModel modelWithDict:dict1];
            [tempArr addObject:model];
        }
        success(tempArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}
+(void)requestForRefundStatusBegin:(NSString *)begin select:(NSString *)select success:(void (^)(NSMutableArray *))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_URL];
    
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"status":@"0",
                          @"begin_count":begin,
                          @"select_count":select
                          };
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s,%@",__func__,responseObject);
        NSDictionary *dict = responseObject;
        BOOL login = [self checkLogin:dict];
        if (!login) return;
        NSArray *arr = dict[@"refundApplyForm"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict1 in arr) {
            RefundModel *model = [RefundModel modelWithDict:dict1];
            [tempArr addObject:model];
        }
        success(tempArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}
+(void)requestForStockWarningSuccess:(void (^)(NSMutableArray *))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STOCK_WARNING_URL];
    
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          };
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        BOOL login = [self checkLogin:dict];
        if (!login) return;
        NSArray *earlyWarning = dict[@"earlyWarning"];
        NSLog(@"%@",earlyWarning);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in earlyWarning) {
            StockWarningModel *model = [StockWarningModel modelWithDict:dict];
            [arr addObject:model];
        }
        success(arr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}
+(void)requestForMessageSelectCount:(NSString *)selectCount success:(void (^)(NSMutableArray *))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STORE_MSG_URL];
    
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":selectCount
                          };
    
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        BOOL login = [self checkLogin:dict];
        if (!login) return;
        NSArray *messages = dict[@"message"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in messages) {
            StoreMsgModel *model = [StoreMsgModel modelWithDict:dict];
            [arr addObject:model];
        }
        success(arr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];

}
+(void)pushBind{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,PUSH_URL];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [def objectForKey:@"deviceToken"];
    if(deviceToken == nil){
        NSLog(@"推送绑定失败:模拟器登录或者第一次登录");
        return;
    }
    
    NSString *userId = nil;
    if ([self currentUserID] == nil) {
        userId = @"";
    }else{
        userId = [self currentUserID];
    }
    
    NSDictionary *par = @{
                          @"app_role":@"SELLER",
                          @"user_id":userId,
                          @"app_id":deviceToken,
                          @"app_type":@"iOS"
                          };
    
    [[self managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"推送绑定成功!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"推送绑定失败:%@",[error localizedDescription]);
    }];
}
+(AFHTTPRequestOperationManager *)manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"text/xml",@"text/json",@"application/json"]];
    return manager;
}
+(AFHTTPRequestOperationManager *)managerWithVerify{
    AFHTTPRequestOperationManager *manager = [self manager];
    [manager.requestSerializer setValue:[self currentVerify] forHTTPHeaderField:@"verify"];
    return manager;
}
+(NSString *)currentUserName{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *uName = arr[1];
        return uName;
    }
    return nil;
}
+(NSString *)currentUserID{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *uID = arr[2];
        return uID;
    }
    return nil;
}
+(NSString *)currentToken{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *token = arr[0];
        return token;
    }
    return nil;
}
+(NSString *)currentVerify{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *verify = arr[3];
        return verify;
    }
    return nil;
}
+(NSArray *)hasUserLogedIn:(BOOL *)flag{
    NSString *filepath=[NSHomeDirectory() stringByAppendingString:@"/Documents/user_information.txt"];
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath]==NO){
        //文件不存在
        *flag = NO;
        return [NSArray array];
    }else{
        *flag = YES;
        NSArray *fileArray = [NSArray arrayWithContentsOfFile:filepath];
        return fileArray;
    }
}
+(BOOL)checkLogin:(NSDictionary *)dict{
//    if (dict && [[dict objectForKey:VERIFY] isEqualToString:@"false"]) {
//        NSLog(@"问题字典%@",dict);
//        [MyObject failedPrompt:@"登录超时,请重新登录!" complete:^{
//            [self logout];
//        }];
//        return NO;
//    }else{
//        return YES;
//    }
    return YES;
}
+(void)logout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    [keyWindow bringSubviewToFront:app.log_View];
}
@end
