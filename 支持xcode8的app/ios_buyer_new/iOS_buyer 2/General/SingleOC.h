//
//  SingleOC.h
//  My_App
//
//  Created by barney on 15/11/26.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleOC : NSObject
@property(nonatomic,copy)NSString *topic;
@property(nonatomic,copy)NSString *topicID;
@property(nonatomic,copy)NSString *TS;
+(SingleOC *)share;
@end
