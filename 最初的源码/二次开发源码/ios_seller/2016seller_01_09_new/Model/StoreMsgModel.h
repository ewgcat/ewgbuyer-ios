//
//  StoreMsgModel.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreMsgModel : NSObject

@property (nonatomic, copy)NSNumber *addTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *fromUser;

+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
