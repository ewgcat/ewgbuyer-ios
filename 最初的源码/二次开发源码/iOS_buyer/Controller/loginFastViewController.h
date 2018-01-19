//
//  loginFastViewController.h
//  My_App
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface loginFastViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>{
    BOOL btnBool;
    BOOL btnBool2;
    BOOL myBool;
    
    UIView *view1;
    UIView *view2;
}

@property (strong, nonatomic) UITextField *registerNameField;
@property (retain, nonatomic) UITextField *registerPasswordField;
@property (retain, nonatomic) UITextField *registerPasswordAgainField;

@property (retain, nonatomic) UIButton *btnRegister1;
@property (retain, nonatomic) UIButton *btnRegisterTextBox;
@property (retain, nonatomic) UIButton *btnRegisterTextBox2;
@property (retain, nonatomic) UIButton *btnRegisterAgreement;

@property (retain, nonatomic) UITextField *registerPhoneNum;
@property (retain, nonatomic) UITextField *registerPhonePassField;
@property (retain, nonatomic) UITextField *registerPhonePassAgainField;
@property (retain, nonatomic) UITextField *codeField;

@property (retain, nonatomic) UIButton *btnRegisterRelex;
@property (retain, nonatomic) UIButton *btnTime;
@property (retain, nonatomic) NSString *type;

//三方登录
@property(nonatomic,strong)NSString *third_username;
@property(nonatomic,strong)NSString *third_type;
@property(nonatomic,strong)NSString *third_info;

@end
