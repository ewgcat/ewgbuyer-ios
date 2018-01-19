//
//  LoginViewController.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    AppDelegate *app = [AppDelegate sharedUserDefault];
    [app logView];
}

@end
