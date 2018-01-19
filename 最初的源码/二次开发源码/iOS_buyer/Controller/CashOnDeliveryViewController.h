//
//  CashOnDeliveryViewController.h
//  My_App
//
//  Created by apple on 15-2-2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface CashOnDeliveryViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate,UIWebViewDelegate>{
    BOOL myBool;
    UIWebView *myWebView;
    ASIFormDataRequest *request101;
    __weak IBOutlet UIView *bottomView;
}
@property (weak, nonatomic) IBOutlet UITextField *payPassField;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPrice;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic) NSString *moneyType;
@property (assign, nonatomic)  BOOL Mybool;

+(id)sharedUserDefault;
@end
