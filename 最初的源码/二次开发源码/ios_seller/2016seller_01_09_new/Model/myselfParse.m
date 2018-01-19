//
//  myselfParse.m
//  SellerApp
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "myselfParse.h"

@implementation myselfParse
+(myselfParse *)parse:(NSDictionary *)reponseObj{
    myselfParse *parse = [myselfParse new];
    parse.dicBig = reponseObj;
    return parse;
}
+(myselfParse *)parseFail:(NSDictionary *)reponseObj{
    myselfParse *parse = [myselfParse new];
    parse.dicBig = reponseObj;
    return parse;
}

@end
