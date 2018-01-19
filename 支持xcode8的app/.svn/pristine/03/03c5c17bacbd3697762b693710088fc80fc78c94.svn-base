//
//  PreviousWinnerRecord.m
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "PreviousWinnerRecord.h"

@implementation PreviousWinnerRecord

+(PreviousWinnerRecord *)recordWithLottery:(CloudPurchaseLottery *)lottery{
    PreviousWinnerRecord *r1 = [PreviousWinnerRecord new];
    r1.period = lottery.period;
    r1.addTime = lottery.announced_date;
    r1.winner = lottery.lucky_username;
    r1.number = lottery.lucky_code;
    r1.totalCount = lottery.lucky_usertimes;
    r1.avatar = lottery.lucky_userphoto;//urlStr
    return r1;
}

@end
