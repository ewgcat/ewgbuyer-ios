//
//  UPPayManager.m
//  My_App
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UPPayManager.h"
#import "UPPaymentControl.h"

#define kMode_Development             @"01"
@implementation UPPayManager
+(UPPayManager *)sharedManager{
    static UPPayManager *manager=nil;
    if (manager ==nil) {
        manager =[[UPPayManager alloc]init];
    }
    return manager;
}
+(void)unionpayManagerStartPay:(NSString *)orderID andOrderType:(NSString *)orderType viewController:(UIViewController*)viewController{
    //UNION_PAY_URL
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,UNION_PAY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_id":orderID,
                          @"order_type":orderType
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger code = [dict[@"code"] integerValue];
        if (code==100) {
            //union pay
            NSString *tn=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tn"]];
            if (tn != nil && tn.length > 0){
                [[UPPaymentControl defaultControl] startPay:tn fromScheme:UPSchemes mode:kMode_Development
                 viewController:viewController];
            }
          
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

@end
