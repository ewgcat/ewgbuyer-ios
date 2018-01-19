//
//  My_AppTests.m
//  My_AppTests
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "SYObject.h"

@interface My_AppTests : XCTestCase

{
    SYObject *obj;
}

@property (nonatomic, strong)UIViewController *testVC;

@end

@implementation My_AppTests

- (void)setUp
{
    [super setUp];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *keyWindow = [app keyWindow];
    UITabBarController *tabBar = (UITabBarController *)[keyWindow rootViewController];
    UIViewController *testVC = [UIViewController new];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:testVC];
    tabBar.viewControllers = @[navi];
    self.testVC = testVC;

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    obj = [[SYObject alloc]init];
    NSArray *titleArr = @[@"test1",@"test2"];
    [obj sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:self.testVC.view headerHeight:44.f topMargin:0.f testColor:NO normalFontSize:15.f selectedFontSize:15.f];
    
}

@end
