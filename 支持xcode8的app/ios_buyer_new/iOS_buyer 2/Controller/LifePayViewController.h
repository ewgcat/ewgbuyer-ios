//
//  LifePayViewController.h
//  My_App
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifePayViewController : UIViewController<UITextFieldDelegate,UITextFieldDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger codeZhi;
    UIButton *buttonPass;
    UIWebView *myWebView;
    NSString *pay_password;
    UITableView *MyTableView;
    UILabel *bianhao;
    UILabel *jine;
    UITextField *password;
    UIButton *paymoneyBtn;
}

- (IBAction)btnClicked:(id)sender;
@property (strong, nonatomic)  NSString *moneyType;
@property (strong, nonatomic)  NSString *moneyPaymethod;
@property (assign,nonatomic)BOOL MyBool;
+(id)sharedUserDefault;

@end
