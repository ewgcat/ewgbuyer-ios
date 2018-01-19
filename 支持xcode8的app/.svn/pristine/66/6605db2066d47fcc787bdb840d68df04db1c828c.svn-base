//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "loginFastViewController.h"
@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //分享返回结果
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = nil;
        if (resp.errCode==-2) {
            strMsg = @"用户取消分享!";
        }else if(resp.errCode==0){
            strMsg = @"分享成功!";
        }
        [SYObject failedPrompt:[NSString stringWithFormat:@"%@",strMsg]];
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        //登录请求在此回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidGetBackType:backType:)]) {
        SendAuthResp *result = (SendAuthResp *)resp;
        NSLog(@"huidiao:%@", result.code);
        self.codestring = result.code;
        [self.delegate managerDidGetBackType:self backType:backTypeAuth];
    }

    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        
    }else if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
//                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidGetBackType:backType:)]) {
                    [self.delegate managerDidGetBackType:self backType:backTypePaySuccess];
                }
                break;
            }
            default:{
//                strMsg = @"支付结果：用户取消！";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidGetBackType:backType:)]) {
                    [self.delegate managerDidGetBackType:self backType:self.backType];
                }
                break;
            }
        }

    }

}

@end
