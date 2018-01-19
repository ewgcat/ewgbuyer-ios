//
//  myAfnetwork.m
//  SellerApp
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "myAfnetwork.h"

@implementation myAfnetwork

+(void)url:(NSString *)parameter_url verify:(NSString *)verify getChat:(void(^)(myselfParse * myParse))success failure:(void(^)())failure {
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:verify forHTTPHeaderField:VERIFY];
    [manager POST:parameter_url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        success([myselfParse parse:dicBig]);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error: %@", error);
        failure();
    }];
}

+(void)netWorkingURL:(NSString *)parameterURL parameters:(NSDictionary *)dic andWay:(NSString *)way getParseSuccess:(void(^)(myselfParse * parse))success getParsefailure:(void(^)())failure
{
    if ([way isEqualToString:@"get"]) {
        AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:[self currentVerify] forHTTPHeaderField:@"verify"];
        [manager GET:parameterURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            success([myselfParse parse:dicBig]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
            NSLog(@"Error: %@", error);
        }];
    }else if ([way isEqualToString:@"post"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
        [manager.requestSerializer setValue:[self currentVerify] forHTTPHeaderField:@"verify"];
        //发送请求
        [manager POST:parameterURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            success([myselfParse parse:dicBig]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
            NSLog(@"Error: %@", error);
        }];
        
    }else if ([way isEqualToString:@"upLoad"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
        [manager.requestSerializer setValue:[self currentVerify] forHTTPHeaderField:@"verify"];
        //发送请求
        [manager POST:parameterURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
           success([myselfParse parse:dicBig]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
            NSLog(@"Error: %@", error);
        }];
        
    }
    
}
+(NSString *)currentVerify{
   
    NSArray *fileContent=[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"user_information.txt"]];
    return [fileContent objectAtIndex:3];
    
}

@end
