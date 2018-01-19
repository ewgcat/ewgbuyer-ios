//
//  ProvinceModel.h
//  My_App
//
//  Created by shiyuwudi on 15/11/19.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (nonatomic,copy)NSString *pName;
@property (nonatomic,copy)NSString *pID;
@property (nonatomic,strong)NSMutableArray *cityArray;

@end
