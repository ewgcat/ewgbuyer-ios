//
//  firstModel.m
//  My_App
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "firstModel.h"

@implementation firstModel

//广告
@synthesize click_url,index_id,img_url;
@synthesize sequence,line_info,line_type,title;

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:click_url forKey:@"click_url"];
    [aCoder encodeObject:index_id forKey:@"index_id"];
    [aCoder encodeObject:img_url forKey:@"img_url"];
    
    [aCoder encodeInteger:sequence forKey:@"sequence"];
    [aCoder encodeInteger:line_type forKey:@"line_type"];
    [aCoder encodeObject:line_info forKey:@"line_info"];
    [aCoder encodeObject:title forKey:@"title"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.click_url = [aDecoder decodeObjectForKey:@"click_url"];
        self.index_id = [aDecoder decodeObjectForKey:@"index_id"];
        self.img_url = [aDecoder decodeObjectForKey:@"img_url"];
        self.line_info = [aDecoder decodeObjectForKey:@"line_info"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.sequence = [aDecoder decodeIntegerForKey:@"sequence"];
        self.line_type = [aDecoder decodeIntegerForKey:@"line_type"];
    }
    return self;
}

@end
