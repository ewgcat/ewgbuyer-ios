//
//  MapLocation.m
//  My_App
//
//  Created by barney on 15/12/11.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

- (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        self.title2 = title;
        self.subtitle2 = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}

//不写你就死定了 直接崩
- (NSString *)title
{
    return _title2;
}
- (NSString *)subtitle
{
    return _subtitle2;
}
- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

//这个别忘了
- (void)dealloc
{
    self.title2 = nil;
    self.subtitle2 = nil;
}

@end
