//
//  WBApiManager.h
//  My_App
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol WBApiManagerDetegate <NSObject>

-(void)weiBoApiManagerUid:(NSString *)uid andUsername:(NSString *)Username;

@end

@interface WBApiManager : NSObject<WeiboSDKDelegate>

@property(nonatomic,assign)id<WBApiManagerDetegate>detegate;

+(WBApiManager *)sharedManager;

@end
