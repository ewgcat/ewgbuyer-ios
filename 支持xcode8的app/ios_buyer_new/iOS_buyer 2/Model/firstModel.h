//
//  firstModel.h
//  My_App
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface firstModel : NSObject<NSCoding>

//index广告
@property (strong,nonatomic)NSString *click_url;
@property (strong,nonatomic)NSString *index_id;
@property (strong,nonatomic)NSString *img_url;

//floor
@property (assign,nonatomic)NSInteger sequence;
@property (assign,nonatomic)NSInteger line_type;
@property (strong,nonatomic)NSArray *line_info;
@property (strong,nonatomic)NSString *title;

@end
