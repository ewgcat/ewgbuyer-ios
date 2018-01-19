//
//  SingleOC.m
//  My_App
//
//  Created by barney on 15/11/26.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "SingleOC.h"
static SingleOC *single;
@implementation SingleOC
+(SingleOC *)share
{
    if (single==nil) {
        single=[[SingleOC alloc]init];
    }

    return single;
}
@end
