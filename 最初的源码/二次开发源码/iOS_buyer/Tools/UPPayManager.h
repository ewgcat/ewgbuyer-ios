//
//  UPPayManager.h
//  My_App
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPPayManager : NSObject

+(void)unionpayManagerStartPay:(NSString *)orderID andOrderType:(NSString *)orderType viewController:(UIViewController*)viewController;

+(UPPayManager *)sharedManager;

@end
