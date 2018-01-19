//
//  Requester.m
//  My_App
//
//  Created by shiyuwudi on 16/2/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "Requester.h"

@implementation Requester

+(NSMutableDictionary *)userDictWithIDAndToken{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[SYObject currentUserID] forKey:@"user_id"];
    [dict setObject:[SYObject currentToken] forKey:@"token"];
    return dict;
}

+(AFHTTPRequestOperationManager *)manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"text/xml",@"text/json",@"application/json"]];
    return manager;
}

+(AFHTTPRequestOperationManager *)managerWithHeader{
    AFHTTPRequestOperationManager *manager = [self manager];
    [manager.requestSerializer setValue:[SYObject currentVerify] forHTTPHeaderField:@"verify"];
    return manager;
}

+(NSURLRequest *)requestByBaldURLString:(NSString *)str{
    NSString *urlStr = nil;
    if (![str hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"http://%@",str];
    } else {
        urlStr = str;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

+(BOOL)isNetworkOK{
    NSString *domain = FIRST_URL;
    NSURLResponse *resp = [NSURLResponse new];
    NSURL *url = [NSURL URLWithString:domain];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:0.1];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:NULL];
    BOOL networkIsOK = data != nil;
    return networkIsOK;
}

+(void)loginPostWithLastURL:(NSString *)lastURL par:(NSDictionary *)par description:(NSString *)description success:(void(^)(NSDictionary *dict))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,lastURL];
    NSMutableDictionary *par1 = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken]}];
    if (par) {
        [par1 addEntriesFromDictionary:par];
    }
    [[Requester managerWithHeader]POST:urlStr parameters:par1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nURL: %@ \n参数: %@ \n%@: \n%@",urlStr, par1, description, responseObject);
        NSDictionary *dict = responseObject;
        success(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:error.localizedDescription];
    }];
}

+(void)postWithLastURL:(NSString *)lastURL par:(NSDictionary *)par description:(NSString *)description success:(void(^)(NSDictionary *dict))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,lastURL];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nURL: %@ \n参数: %@ \n%@: \n%@",urlStr, par, description, responseObject);
        NSDictionary *dict = responseObject;
        success(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:error.localizedDescription];
    }];
}

@end
