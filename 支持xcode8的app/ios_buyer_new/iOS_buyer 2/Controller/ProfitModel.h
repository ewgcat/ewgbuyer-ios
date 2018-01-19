//
//  ProfitModel.h
//  My_App
//
//  Created by 邱炯辉 on 16/5/27.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfitModel : NSObject
@property (nonatomic,copy)NSString *addTime;
@property (nonatomic,assign)float commission_amount;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *user_relation;
@property (nonatomic,assign)int commission_status;
@property (nonatomic,copy)NSString *photo;

@end
