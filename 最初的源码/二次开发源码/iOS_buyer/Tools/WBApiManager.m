//
//  WBApiManager.m
//  My_App
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WBApiManager.h"

@implementation WBApiManager

+(WBApiManager *)sharedManager{
    static WBApiManager *manager=nil;
    if (manager ==nil) {
        manager =[[WBApiManager alloc]init];
    }
    return manager;
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        NSString *usid=[response.userInfo objectForKey:@"uid"];
        [self.detegate weiBoApiManagerUid:usid andUsername:@""];
    }
    
}


@end
