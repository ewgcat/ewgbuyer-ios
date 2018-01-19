//
//  NewLoginViewController.h
//  My_App
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UMSocial.h"
#import "WXApi.h"
@interface NewLoginViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate,UMSocialUIDelegate,WXApiDelegate,WXApiManagerDelegate,WBApiManagerDetegate>{
    __weak IBOutlet UIButton *fastregesterBtn;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UIView *topView;
    
    ASIFormDataRequest *request101;
    ASIFormDataRequest *request102;
  @public  BOOL tabbarshouldShow;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;
@property (weak, nonatomic) IBOutlet UIView *sinaView;
@property (weak, nonatomic) IBOutlet UIView *QQView;
@property (weak, nonatomic) IBOutlet UIView *WCView;

- (IBAction)forgetBtnClicked:(id)sender;
- (IBAction)QQBtnClicked:(id)sender;
- (IBAction)WXBtnClicked:(id)sender;
- (IBAction)sinaBtnClicked:(id)sender;

@end
