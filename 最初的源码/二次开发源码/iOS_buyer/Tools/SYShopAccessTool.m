//
//  SYShopAccessTool.m
//  My_App
//
//  Created by shiyuwudi on 15/11/11.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "WXApi.h"
#import "EvaModel.h"
#import "UserInfoModel.h"
#import "AFNetworkTool.h"
#import "PaySettingViewController.h"
#import "FirstViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ThirdViewController.h"
#import "SYOrderDetailsModel.h"
#import <AlipaySDK/APayAuthInfo.h>
#import "CloudCart.h"
#import "CloudPurchaseLottery.h"
#import "CloudPurchaseGoods.h"
#import "Parser.h"


@interface SYShopAccessTool ()<WXApiDelegate>

@end

@implementation SYShopAccessTool

+(void)cloudGoodsDetailWithLotteryID:(NSString *)lottery_id result:(void (^)(CloudPurchaseLottery *))result {
    [Requester postWithLastURL:CLOUDPURCHASE_GOODSDETAIL_URL par:NSDictionaryOfVariableBindings(lottery_id) description:@"商品详情" success:^(NSDictionary *dict) {
        CloudPurchaseLottery *l = [Parser parseArray:dict model:@"CloudPurchaseLottery"][0];
        result(l);
    }];
}

+(void)getLatest50WithLotteryID:(NSString *)lottery_id result:(void (^)(NSArray *))result{
    [Requester postWithLastURL:CLOUDPURCHASE_LATEST_50_URL par:NSDictionaryOfVariableBindings(lottery_id) description:@"最近50条" success:^(NSDictionary *dict) {
        result([Parser parseArray:dict model:@"CloudWinnerRecord"]);
    }];
}

+(void)resultHistoryByLotteryID:(NSString *)lottery_id beginCount:(NSString *)begin_count selectCount:(NSString *)select_count result:(void(^)(NSArray *))result {
    [Requester postWithLastURL:CLOUDPURCHASE_WINNER_HISTORY_URL par:NSDictionaryOfVariableBindings(lottery_id,begin_count,select_count) description:@"往期揭晓" success:^(NSDictionary * dict) {
        NSArray *arr = [Parser parseArray:dict model:@"CloudPurchaseLottery"];
        result(arr);
    }];
}

+(void)cartDelByID:(NSString *)cartID result:(void (^)(BOOL))result{
    [Requester loginPostWithLastURL:CLOUDPURCHASE_CART_DEL_URL par:@{@"cart_ids":cartID} description:@"购物车删除结果" success:^(NSDictionary *dict) {
        result([Parser parseBool:dict]);
    }];
}

+(void)modifyCartWithCartID:(NSString *)cartID toCount:(NSString *)count result:(void (^)(BOOL))result{
    [Requester loginPostWithLastURL:CLOUDPURCHASE_CART_MODIFY_URL par:@{@"cart_id":cartID,@"count":count} description:@"购物车数量调整结果" success:^(NSDictionary *dict) {
        result([Parser parseBool:dict]);
    }];
}

+(void)checkCart:(void (^)(NSArray *))success{
    [Requester loginPostWithLastURL:CLOUDPURCHASE_CHECK_CART_URL par:nil description:@"购物车内容" success:^(NSDictionary *dict) {
        success([Parser parseArray:dict model:@"CloudCart"]);
    }];
}

+(void)addToCartWithLotteryID:(NSString *)lotteryID count:(NSString *)count{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_ADD_CART_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"lottery_id":lotteryID,
                          @"count":count
                          };
    [SYObject startLoading];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"添加购物车%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"data"][@"status"];
        if (status.integerValue == 1) {
            //添加成功
            [SYObject failedPrompt:@"添加成功"];
            
        }else {
            [SYObject failedPrompt:[NSString stringWithFormat:@"添加失败,库存:%@",dict[@"data"][@"inventory"]]];
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:error.localizedDescription];
        [SYObject endLoading];
    }];
}

+(void)refundByOrderID:(NSString *)orderID success:(void (^)(BOOL))success{
    
    [OHAlertView showAlertWithTitle:nil message:@"确定申请退款?" cancelButton:@"确定" otherButtons:@[@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        
        if(buttonIndex == 0){
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,GOODS_ORDER_REFUND_URL];
            NSDictionary *par = @{
                                  @"user_id":[SYObject currentUserID],
                                  @"token":[SYObject currentToken],
                                  @"order_id":orderID
                                  };
            [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = responseObject;
                NSString *code = dict[@"code"];
                if (code.intValue == 100) {
                    success(YES);
                    [SYObject failedPrompt:@"申请退款成功!"];
                }else if (code.intValue == -100){
                    [SYObject failedPrompt:@"申请退款失败!"];
                }else{
                    [SYObject failedPrompt:@"未知错误!"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",[error localizedDescription]);
                NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
            }];
            
        }
        
    }];
}

+(void)applyForReturnWithOid:(NSString *)oid goodsId:(NSString *)goodsId goodsGspIads:(NSString *)gsp success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODSAPPLY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"oid":oid,
                          @"goods_id":goodsId,
                          @"goods_gsp_ids":gsp
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"ret"] isEqualToString:@"true"]) {
            NSLog(@"退货申请成功!");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)sharetoWechatWithTitle:(NSString *)title goodsID:(NSString *)goodsID scene:(shareScene)scene smallPic:(NSString *)smallPic{
    
    SendMessageToWXReq *sm = [[SendMessageToWXReq alloc]init];
    
    //发送多媒体信息
    WXMediaMessage *msg = [WXMediaMessage message];
    
    //标题
    msg.title = title;
    
    //描述
    msg.description = @"我在ISkyShop发现了一个不错的商品，赶快来看看吧。";
    
    //缩略图
    NSURL *url = [NSURL URLWithString:smallPic];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        msg.thumbData = data;
    }
    
    //链接
    WXWebpageObject *web = [WXWebpageObject object];
    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *url1 = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    web.webpageUrl = url1;
    msg.mediaObject = web;
    
    //暂时用不着
    //    msg.mediaTagName = @"我是mediaTagName";
    //    msg.messageExt = @"我是messageExt";
    
    sm.message = msg;
    switch (scene) {
        case shareSceneFriends:{
            sm.scene = WXSceneSession;
            break;
        }
        case shareSceneTimeline:{
            sm.scene = WXSceneTimeline;
            break;
        }
    }
    [WXApi sendReq:sm];
}
+(void)sharetoWeiboWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";

    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *url1 = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    
    
    WBMessageObject *message = [WBMessageObject message];
    message.text=[NSString stringWithFormat:@"%@ %@",@"我在ISkyShop发现了一个不错的商品，赶快来看看吧。",url1];
    
    
    NSURL *url = [NSURL URLWithString:smallPic];
    NSData *data = [NSData dataWithContentsOfURL:url];
    WBImageObject *image = [WBImageObject object];
    if (data) {
        image.imageData = data;
        message.imageObject = image;
    }

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                      
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
 
}
+(void)sharetoQQWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic{
    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *utf8String = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    NSString *description = @"我在ISkyShop发现了一个不错的商品，赶快来看看吧。";
    NSString *previewImageUrl = smallPic;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
 
    
}
+(void)sharetoQQTimelineWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic{
    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *utf8String = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    NSString *description = @"我在ISkyShop发现了一个不错的商品，赶快来看看吧。";
    NSString *previewImageUrl = smallPic;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];

    
}
+(void)handleSendResult:(QQApiSendResultCode)sendResult{
    NSString *message;
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED:
            message=@"该APP未被注册";
            break;
        case EQQAPIMESSAGETYPEINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGECONTENTINVALID:
            message=@"发送参数错误";
            break;
        case EQQAPIQQNOTINSTALLED:
        case EQQAPIQQNOTSUPPORTAPI:
            message=@"未安装QQ客户端";
            [OHAlertView showAlertWithTitle:@"提示" message:@"你还未安装手机qq客户端" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                
            }];
            break;
        case EQQAPISENDFAILD:
            message=@"发送失败";
            break;
        default:
            message=@"未知错误";
            break;
    }
    NSLog(@"%@",message);
}
+(void)pushBind{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,PUSH_URL];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [def objectForKey:@"deviceToken"];
    if(deviceToken == nil){
        NSLog(@"模拟器登录或者第一次登录");
        return;
    }
    NSString *userId = nil;
    if ([SYObject currentUserID] == nil) {
        userId = @"";
    }else{
        userId = [SYObject currentUserID];
    }
    NSDictionary *par = @{
                          @"app_role":@"BUYER",
                          @"user_id":userId,
                          @"app_id":deviceToken,
                          @"app_type":@"iOS"
                          };
    
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"推送绑定成功!:device token:%@",deviceToken);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(BOOL)reallySuccess:(NSString *)longText{
    NSArray *strArr = [longText componentsSeparatedByString:@"&"];
    NSString *successStr = nil;
    for (NSString *str in strArr) {
        if ([str containsString:@"success"]) {
            successStr = str;
        }
    }
    if (successStr||[successStr containsString:@"true"]) {
        return YES;
    }
    return NO;
}
+(NSString *)codeDescByCodeNumber:(NSString *)code{
    if (code.intValue == 9000) {
        return @"订单支付成功!";//不一定成功，还要检查success
    }else if (code.intValue == 8000){
        return @"正在处理中...";
    }else if (code.intValue == 4000){
        return @"订单支付失败!";
    }else if (code.intValue == 6001){
        return @"用户中途取消!";
    }else if (code.intValue == 6002){
        return @"网络连接出错!";
    }else{
        return @"未知的返回码";//查看支付宝API文档是否更新
    }
}
+(void)aliPayWithOrderID:(NSString *)orderID orderType:(NSString *)orderType{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ALIPAY_SIGN_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_id":orderID,
                          @"order_type":orderType
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSNumber *code = dict[@"code"];
        if (code.intValue == 100) {
            NSString *signature = dict[@"orderInfo"];
            AlipaySDK *aliService = [AlipaySDK defaultService];

            [aliService payOrder:signature fromScheme:ALIPAY_SCHEME callback:^(NSDictionary *resultDic) {
                
                NSString *status = resultDic[@"resultStatus"];
                NSString *result = resultDic[@"result"];
                NSDictionary *userInfo = @{
                                           @"result":status,
                                           @"longText":result
                                           };
                NSLog(@"%@",result);
                NSString *fatSign = nil;
                NSString *fatOut = nil;
                NSArray *strArr = [result componentsSeparatedByString:@"&"];
                for (NSString *str in strArr) {
                    if ([str containsString:@"sign="]) {
                        fatSign = str;
                    }
                    if ([str containsString:@"out_trade_no="]) {
                        fatOut = str;
                    }
                }
                if (fatSign&&fatOut) {
                    NSString *thinSign = [self loseWeight:fatSign byKill:@"sign"];
                    NSString *thinOut = [self loseWeight:fatOut byKill:@"out_trade_no"];
                    //内部回调,用来更新订单状态
                    [self  alipayCallBackWithSign:thinSign orderNo:orderID outTradeNo:thinOut orderType:orderType];
                }else{
                    NSLog(@"sign str or out trade No not found in alipay callback!");
                }
                
                //发送通知实现回调
                [[NSNotificationCenter defaultCenter]postNotificationName:ALIPAY_FINISH_NOTIF object:nil userInfo:userInfo];
            }];

        }else{
            [SYObject failedPrompt:[NSString stringWithFormat:@"request failed:code = %@",code]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(NSString *)loseWeight:(NSString *)fat byKill:(NSString *)rubbish{
    NSInteger start = rubbish.length + 2;
    NSString *thinner = [fat substringFromIndex:start];
    NSString *thinnest = [thinner stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return thinnest;
}
//支付宝支付成功后回调给本地服务器,修改订单数据
+(void)alipayCallBackWithSign:(NSString *)sign orderNo:(NSString *)orderNo outTradeNo:(NSString *)outTradeNo orderType:(NSString *)orderType{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,PAYREYURN_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"sign":sign,
                          @"order_no":orderNo,
                          @"out_trade_no":outTradeNo,
                          @"order_type":orderType
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *code = dict[@"code"];
        if (code.intValue == 100) {
            //本地回调成功
            NSLog(@"支付宝支付成功后回调成功!");
        }else{
            //本地回调失败
            NSLog(@"支付宝支付成功后回调失败!");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(void)wechatPayWithID:(NSString *)orderID type:(NSString *)typeString{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,WXPAY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"id":orderID,
                          @"type":typeString
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicBig = responseObject;
        if (dicBig) {
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dicBig objectForKey:@"appId"];
            req.partnerId           = [dicBig objectForKey:@"partnerId"];
            req.prepayId            = [dicBig objectForKey:@"prepayId"];
            req.nonceStr            = [dicBig objectForKey:@"nonceStr"];
            req.timeStamp           = [[dicBig objectForKey:@"timeStamp"] intValue];
            req.package             = [dicBig objectForKey:@"packageValue"];
            req.sign                = [dicBig objectForKey:@"sign"];
            
            [WXApi sendReq:req];
            
            NSLog(@"微信签名:\nappid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [SYObject failedPrompt:@"no response from local server!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)lifeSaveOrderWithGroupItemID:(NSString *)groupID orderCount:(NSString *)orderCount payMethod:(NSString *)payMethod s:(void (^)(BOOL))ret failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPORDERSAVE_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"group_id":groupID,
                          @"order_count":orderCount,
                          @"pay_method":payMethod
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSNumber *code = dict[@"code"];
        if (code.integerValue==100) {
            ThirdViewController *third = [ThirdViewController sharedUserDefault];
            third.ding_order_id = dict[@"order_id"];//测试519
            ret(YES);
        }else{
            failure([NSString stringWithFormat:@"request failed,code = %@",code.stringValue]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(void)payWithOrderID:(NSString *)orderID password:(NSString *)password message:(NSString *)msg s:(void (^)(BOOL))ret failure:(void (^)(NSString *))failure{
    
    if (msg) {
        //货到付款支付
        [self payAfterWithOrderID:orderID message:msg s:^(BOOL success) {
            if (success) {
                ret(YES);
            }
        } failure:^(NSString *errStr) {
            failure(errStr);
            NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
        }];
    }else{
        //积分商品 预存款支付(integral)
        //团购商品 预存款支付(group)
        //商品订单 预存款支付(goods)
        //以上三合一
        [self checkPassword:password orderID:orderID ofBalancePay:^(BOOL valid) {
            if (valid) {
                ret(YES);
            }
        } failure:^(NSString *errStr) {
            failure(errStr);
        }];
    }
}
+(void)groupDetailsByGroupOrderID:(NSString *)orderID s:(void (^)(NSDictionary *))ret failure:(void (^)(NSString *))failure{
    //到手的变量:order_id（团购的）
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERDETAIL_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"oid":orderID
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        ret(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)orderDetailsByOrderID:(NSString *)orderID s:(void (^)(SYOrderDetailsModel *))ret failure:(void (^)(NSString *))failure{
    //到手的变量:order_id
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_id":orderID
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        NSNumber *code = dict[@"code"];
        if (code.integerValue==100) {
            SYOrderDetailsModel *model = [[SYOrderDetailsModel alloc]init];
            
            NSArray *arr1 = dict[@"goods_list"];
            if (arr1==nil||arr1.count==0) {
                
            }else{
                NSDictionary *listDict = arr1[0];
                model.order_image = listDict[@"goods_mainphoto_path"];
                model.order_goods_name = listDict[@"goods_name"];
                model.order_price = listDict[@"goods_price"];
                model.order_specs = listDict[@"goods_gsp_val"];
                model.order_qty = listDict[@"goods_count"];
                model.order_goods_id = listDict[@"goods_id"];
            }
            NSArray *arr2 = dict[@"trans_list"];
            NSDictionary *transDict = arr2[0];
            
            model.order_status = dict[@"order_status"];
            //根据订单种类来显示下面的按钮
            model.order_num = dict[@"order_num"];
            model.order_time = dict[@"addTime"];
            
            model.order_username = dict[@"receiver_Name"];
            model.order_address = [NSString stringWithFormat:@"%@ %@",dict[@"receiver_area"],dict[@"receiver_area_info"]];
            
            if (transDict[@"shipCode"]) {
                model.order_logistic = [NSString stringWithFormat:@"物流单号:%@\n物流公司:%@",transDict[@"shipCode"],transDict[@"express_company"]];
            }
            
            model.order_invoice = dict[@"invoiceType"];
            model.order_price1 = dict[@"goods_price"];
            model.order_price2 = dict[@"ship_price"];
            model.order_price3 = dict[@"coupon_price"];
            model.order_price4 = dict[@"order_total_price"];
            model.order_pay_type = dict[@"payType"];
            model.order_mobile = dict[@"receiver_telephone"];
            
            ret(model);
        }else{
            //0025
//            failure([NSString stringWithFormat:@"net request failed, code=%@",code.stringValue]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(void)payAfterWithOrderID:(NSString *)orderID message:(NSString *)msg s:(void (^)(BOOL))ret failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,PAYAFTER_URL];

    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_id":orderID,
                          @"pay_msg":msg
                          };
    
    AFHTTPRequestOperationManager *manager = [Requester managerWithHeader];
    [manager POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *codeStr = dict[@"code"];
        NSInteger code = codeStr.integerValue;
        if (code==100) {
            ret(YES);
        }else if(code==-100){
            failure(@"用户信息错误");
        }else if(code==-200){
            failure(@"订单信息错误");
        }else if(code==-300){
            failure(@"订单支付方式错误");
        }else if(code==-400){
            failure(@"系统未开启该支付功能，订单不可支付");
        }else{
            failure(@"未知支付错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(NSString *)localPassword {
    return [[NSUserDefaults standardUserDefaults]valueForKey:kTouchIDSavedPasswordKey];
}
+(void)clearTouchIDInfo {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kTouchIDSavedPasswordKey];//缓存的密码
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kTouchIDDefaulskey];//开关状态
}
#pragma mark -预存款支付验证
//云购
+(void)cloudPurchase:(NSString *)password orderID:(NSString *)orderID ofBalancePay:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    AFHTTPRequestOperationManager *manager = [Requester managerWithHeader];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,BALANCEPAY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"password":password,
                          @"pay_msg":@"",
                          @"order_id":orderID,
                          @"type":@"cloudpurchase"
                          };
    
    [manager POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *codeStr = dict[@"code"];
        NSInteger code = codeStr.integerValue;
        if (code==100) {
            success(YES);
        }else if (code==-300){
            failure(@"支付密码错误!");
        }else if (code==-200){
            failure(@"订单信息错误");
        }else if (code==-100){
            failure(@"用户信息错误");
        }else if (code==-400){
            failure(@"预存款余额不足");
        }else if (code==-500){
            failure(@"订单重复支付");
        }else {
            failure(@"未知错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
//普通商品
+(void)checkPassword:(NSString *)password orderID:(NSString *)orderID ofBalancePay:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    AFHTTPRequestOperationManager *manager = [Requester managerWithHeader];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,BALANCEPAY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"password":password,
                          @"pay_msg":@"",
                          @"order_id":orderID,
                          @"type":@"goods"//商品订单
                          };

    [manager POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *codeStr = dict[@"code"];
        NSInteger code = codeStr.integerValue;
        if (code==100) {
            success(YES);
        }else if (code==-300){
            failure(@"支付密码错误!");
        }else if (code==-200){
            failure(@"订单信息错误");
        }else if (code==-100){
            failure(@"用户信息错误");
        }else if (code==-400){
            failure(@"预存款余额不足");
        }else if (code==-500){
            failure(@"订单重复支付");
        }else {
            failure(@"未知错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
//积分
+(void)checkIntegral:(NSString *)password orderID:(NSString *)orderID ofBalancePay:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    AFHTTPRequestOperationManager *manager = [Requester managerWithHeader];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,BALANCEPAY_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"password":password,
                          @"pay_msg":@"",
                          @"order_id":orderID,
                          @"type":@"integral"//商品订单
                          };
    
    [manager POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *codeStr = dict[@"code"];
        NSInteger code = codeStr.integerValue;
        if (code==100) {
            success(YES);
        }else if (code==-300){
            failure(@"支付密码错误!");
        }else if (code==-200){
            failure(@"订单信息错误");
        }else if (code==-100){
            failure(@"用户信息错误");
        }else if (code==-400){
            failure(@"预存款余额不足");
        }else if (code==-500){
            failure(@"订单重复支付");
        }else {
            failure(@"未知错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)logError{
    NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
}
+(void)currentUserDetails:(void (^)(UserInfoModel *))success failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,USER_CENTER_URL];
    NSMutableDictionary *par = [Requester userDictWithIDAndToken];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *ret = dict[@"ret"];
        if (ret.boolValue) {
            UserInfoModel *model = [UserInfoModel yy_modelWithDictionary:dict];
            success(model);
        }else{
            failure([NSString stringWithFormat:@"ret = %@",ret]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //网络请求失败
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(void)checkPassword:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,PAY_PASSWORD_CHECK_URL];
    NSMutableDictionary *par = [Requester userDictWithIDAndToken];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *code = dict[@"code"];
        if (code.integerValue==-300) success(YES);//failure(@"password not set");
        else if (code.integerValue==100) success(YES);
        else failure([NSString stringWithFormat:@"net request failed with code:%@", code]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}
+(void)checkPswdNMobile:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    //检查是否设置支付密码
    [self checkPassword:^(BOOL hasPassword) {
        if (hasPassword) {
            // 判断是否绑定手机
//            NSString *isPhoneBundleUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,HASPHONE_URL];
//            NSMutableDictionary *par = [Requester userDictWithIDAndToken];
//            [[Requester managerWithHeader]POST:isPhoneBundleUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSDictionary *resultDict = responseObject;
//                NSInteger code = [resultDict[@"code"] integerValue];
//                if(code == 100)success(YES);
//                else if (code == -100)success(NO);
//                else failure([NSString stringWithFormat:@"net request failed with code:%ld", (long)code]);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                failure([error localizedDescription]);
//            }];
           success(YES);
           
        }
    } failure:^(NSString *errorStr) {
        [SYObject endLoading];
        [SYObject failedPrompt:@"没有设置支付密码!"];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)confirmReceiptByOrderID:(NSString *)orderID success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL];
    NSMutableDictionary *par = [Requester userDictWithIDAndToken];
    [par setObject:orderID forKey:@"order_id"];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *code = dict[@"code"];
        if (code.integerValue==100) {
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)cancelOrderByOrderID:(NSString *)orderID success:(void (^)(NSDictionary *))success{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERCANCEL_URL];
    NSDictionary *par = @{
                          @"user_id":[USER_INFORMATION objectAtIndex:3],
                          @"token":[USER_INFORMATION objectAtIndex:1],
                          @"order_id":orderID
                          };
    
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *code = dict[@"code"];
        if (code.integerValue==100) {
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"服务器故障"];
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)getEvaluateNumUseGoodsID:(NSInteger)goodsID success:(void (^)(NSDictionary *))s fail:(void (^)(NSString *))f{
    [[Requester managerWithHeader]POST:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] parameters:@{@"id":[NSString stringWithFormat:@"%ld",(long)goodsID]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        s(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        f([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}

+(void)getEvaArrUseDetailID:(NSString *)ID type:(SY_SHOP_EVALUATE_TYPE)type s:(void (^)(NSArray *))success f:(void (^)(NSString *))fail{
    NSDictionary *par;
    if (type==SY_SHOP_EVALUATE_TYPE_ALL) {
        par =@{@"id":ID};
    }else if (type==SY_SHOP_EVALUATE_TYPE_BAD){
        par =@{@"id":ID,@"type":@"-1"};
    }else if (type==SY_SHOP_EVALUATE_TYPE_WELL){
        par =@{@"id":ID,@"type":@"1"};
    }else if (type==SY_SHOP_EVALUATE_TYPE_MIDDLE){
        par =@{@"id":ID,@"type":@"0"};
    }
    
    [[Requester managerWithHeader]GET:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"eva_list"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            EvaModel *model = [EvaModel evaModelWithDict:dict];
            [tempArr addObject:model];
        }
        success(tempArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];
}


#pragma mark -购物车数量提示
+(void)getItemBadgeValue{
    //发起得到购物车数量的请求
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
   NSDictionary *par;
    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
        par = @{
                @"user_id":@"",
                @"token":@""
                };
    }else{
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        par = @{
                @"user_id":[fileContent2 objectAtIndex:3],
                @"token":[fileContent2 objectAtIndex:1]
                };
    }

    [[Requester managerWithHeader]POST:urlstr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicBig = responseObject;
        if (dicBig) {
            FirstViewController *first=[FirstViewController sharedUserDefault];
            UITabBarItem * item=[first.tabBarController.tabBar.items objectAtIndex:2];
            if ([[dicBig objectForKey:@"count"]integerValue] != 0) {
                item.badgeValue = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"count"]];
            }else {
                item.badgeValue = nil;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       [SYObject failedPrompt:@"网络请求失败"];
    }];

}


#pragma mark -验证预售商品订单是否可支付
+(void)ToTestWhetherOpenToBookingCommodityOrderCanPay:(NSString *)orderId success:(void (^)(NSInteger))success failure:(void (^)(NSString *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ADVANCE_ORDER_PAY_VERIFY_URL];
    NSMutableDictionary *par = [Requester userDictWithIDAndToken];
    [par setObject:orderId forKey:@"order_id"];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger code = [dict[@"code"] integerValue];
        success(code);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
    }];



}

@end
