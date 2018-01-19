//
//  SYShopAccessTool.h
//  My_App
//  网络请求封装类
//  Created by shiyuwudi on 15/11/11.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@class PayReq;
@class UserInfoModel;
@class SYOrderDetailsModel;
@class SYShopAccessTool;
@class CloudPurchaseLottery;

typedef enum{
    SY_SHOP_EVALUATE_TYPE_WELL,
    SY_SHOP_EVALUATE_TYPE_MIDDLE,
    SY_SHOP_EVALUATE_TYPE_BAD,
    SY_SHOP_EVALUATE_TYPE_ALL
}SY_SHOP_EVALUATE_TYPE;//评价类型

typedef NS_ENUM(NSUInteger, shareScene) {
    shareSceneFriends,
    shareSceneTimeline,
};

@interface SYShopAccessTool : NSObject

#pragma mark - 云购
+(void)cloudGoodsDetailWithLotteryID:(NSString *)lottery_id result:(void (^)(CloudPurchaseLottery *))result;//商品详情
+(void)getLatest50WithLotteryID:(NSString *)lottery_id result:(void(^)(NSArray *))result;//全站最近50条
+(void)resultHistoryByLotteryID:(NSString *)lottery_id beginCount:(NSString *)begin_count selectCount:(NSString *)select_count result:(void(^)(NSArray *))result;//往期揭晓
+(void)cartDelByID:(NSString *)cartID result:(void(^)(BOOL success))result;//删除购物车
+(void)modifyCartWithCartID:(NSString *)cartID toCount:(NSString *)count result:(void(^)(BOOL success))result;//修改购物车
+(void)checkCart:(void(^)(NSArray *items))success;//查询购物车
+(void)addToCartWithLotteryID:(NSString *)lotteryID count:(NSString *)count;//添加购物车

#pragma mark - 评价
+(void)getEvaluateNumUseGoodsID:(NSInteger)goodsID success:(void(^)(NSDictionary *dict))s fail:(void(^)(NSString *errStr))f;//查询评价数量
+(void)getEvaArrUseDetailID:(NSString *)ID type:(SY_SHOP_EVALUATE_TYPE)type s:(void(^)(NSArray *))success f:(void(^)(NSString *errStr))fail;//根据ID和评价类型，获得具体评价信息数组

#pragma mark - 订单
+(void)refundByOrderID:(NSString *)orderID success:(void(^)(BOOL success))success;
+(void)cancelOrderByOrderID:(NSString *)orderID success:(void(^)(NSDictionary *dict))success;//取消订单
+(void)confirmReceiptByOrderID:(NSString *)orderID success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSString *errStr))failure;//确认收货
+(void)checkPswdNMobile:(void(^)(BOOL has))success failure:(void(^)(NSString *errStr))failure;//判断是否设置密码
+(void)currentUserDetails:(void(^)(UserInfoModel *model))success failure:(void(^)(NSString *errStr))failure;//获取当前用户头像，等级，预存款，优惠券数量，积分

+(void)payAfterWithOrderID:(NSString *)orderID message:(NSString *)msg s:(void(^)(BOOL success))ret failure:(void(^)(NSString *errStr))failure;//货到付款支付，填写备注
+(void)orderDetailsByOrderID:(NSString *)orderID s:(void(^)(SYOrderDetailsModel *model))ret failure:(void(^)(NSString *errStr))failure;//商品订单详情
+(void)groupDetailsByGroupOrderID:(NSString *)orderID s:(void(^)(NSDictionary *dict))ret failure:(void(^)(NSString *errStr))failure;//团购订单详情
+(void)lifeSaveOrderWithGroupItemID:(NSString *)groupID orderCount:(NSString *)orderCount payMethod:(NSString *)payMethod s:(void(^)(BOOL success))ret failure:(void(^)(NSString *errStr))failure;//团购(又名生活购)"保存"订单
+(void)applyForReturnWithOid:(NSString *)oid goodsId:(NSString *)goodsId goodsGspIads:(NSString *)gsp success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSString *errStr))failure;

#pragma mark - 支付

+(void)clearTouchIDInfo;
+(NSString *)localPassword;

///内部支付统一接口(没有的参数传nil)//普通商品
+(void)payWithOrderID:(NSString *)orderID password:(NSString *)password message:(NSString *)msg s:(void(^)(BOOL success))ret failure:(void(^)(NSString *errStr))failure;


#pragma mark - 预存款支付1
+(void)checkPassword:(NSString *)password orderID:(NSString *)orderID  andOtherPar:(NSDictionary *)dic ofBalancePay:(void(^)(BOOL valid))success failure:(void(^)(NSString *errStr))failure;//订单预存款支付\支付密码验证
///云购预存款支付
#pragma mark - 预存款支付1

+(void)cloudPurchase:(NSString *)password orderID:(NSString *)orderID andOtherPar:(NSDictionary *)dic ofBalancePay:(void (^)(BOOL))success failure:(void (^)(NSString *))failure;
//积分商品
#pragma mark - 预存款支付1

+(void)checkIntegral:(NSString *)password orderID:(NSString *)orderID  andOtherPar:(NSDictionary *)dic ofBalancePay:(void (^)(BOOL))success failure:(void (^)(NSString *))failure;
///外部支付-支付宝
+(void)aliPayWithOrderID:(NSString *)orderID orderType:(NSString *)orderType;

+(NSString *)codeDescByCodeNumber:(NSString *)code;//错误码判断
+(BOOL)reallySuccess:(NSString *)longText;//支付成功判断

///外部支付-微信统一接口
+(void)wechatPayWithID:(NSString *)orderID type:(NSString *)typeString;//typeString传订单类型:积分为integral  商品为 goods  生活团购为group  不可传递null 充值预存款 predeposit

#pragma mark - 推送
///绑定
+(void)pushBind;

#pragma mark - 分享
///微信分享商品
+(void)sharetoWechatWithTitle:(NSString *)title goodsID:(NSString *)goodsID scene:(shareScene)scene smallPic:(NSString *)smallPic;
///QQ好友分享商品
+(void)sharetoQQWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic;
///QQ空间分享商品
+(void)sharetoQQTimelineWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic;
///微博分享商品
+(void)sharetoWeiboWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic;
#pragma mark -购物车数量提示
+(void)getItemBadgeValue;

#pragma mark -验证预售商品订单是否可支付
+(void)ToTestWhetherOpenToBookingCommodityOrderCanPay:(NSString *)orderId success:(void (^)(NSInteger code))success failure:(void (^)(NSString *errstr))failure;
@end
