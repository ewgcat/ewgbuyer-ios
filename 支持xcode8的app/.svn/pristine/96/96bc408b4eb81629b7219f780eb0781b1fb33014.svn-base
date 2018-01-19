//
//  CloudCart.m
//  My_App
//
//  Created by shiyuwudi on 16/2/19.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "CloudCart.h"

@implementation CloudCart

-(NSString *)totalQty{
    return self.cloudPurchaseLottery.cloudPurchaseGoods.goods_price;
}
-(NSString *)balanceQty{
    int buyed = self.cloudPurchaseLottery.purchased_times.intValue;
    int total = [self totalQty].intValue;
    int balance = total - buyed;
    return [SYObject toStr:balance];
}
-(NSString *)userBuyedQty{
    return self.purchased_times;
}
-(NSString *)lotteryID{
    return self.cloudPurchaseLottery.id;
}

@end
