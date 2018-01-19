 //
//  main.m
//  My_App
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime startTime;

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            startTime = CFAbsoluteTimeGetCurrent();
            NSLog(@"%@",NSHomeDirectory());
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@ %@",exception.callStackSymbols,exception.callStackReturnAddresses);
        }
        @finally {
        }
    }
}
