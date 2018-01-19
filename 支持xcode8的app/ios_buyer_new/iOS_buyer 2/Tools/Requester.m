//
//  Requester.m
//  My_App
//
//  Created by shiyuwudi on 16/2/27.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"ewgvip1"

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
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }

    
    return manager;
}
#pragma mark - https
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
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
