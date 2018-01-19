//
//  PreviousWinnerRecord.h
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudPurchaseLottery.h"

@interface PreviousWinnerRecord : NSObject

@property (nonatomic, copy)NSString *period;//期号
@property (nonatomic, copy)NSString *addTime;//揭晓时间
@property (nonatomic, copy)NSString *winner;//获奖者
@property (nonatomic, copy)NSString *number;//幸运号码
@property (nonatomic, copy)NSString *totalCount;//本期参与
@property (nonatomic, copy)NSString *avatar;//头像

+(PreviousWinnerRecord *)recordWithLottery:(CloudPurchaseLottery *)lottery;

@end
