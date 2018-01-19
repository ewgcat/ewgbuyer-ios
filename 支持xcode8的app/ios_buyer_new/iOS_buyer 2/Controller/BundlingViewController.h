//
//  BundlingViewController.h
//  My_App
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

typedef enum {
    BUNDLINGVC_ENTER_TYPE_NORMAL,
    BUNDLINGVC_ENTER_TYPE_FROM_PAY_SELECT
}BUNDLINGVC_ENTER_TYPE;

@interface BundlingViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>{
    
       
}



@property (weak, nonatomic) IBOutlet UIButton *btnTakeCode;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@property (weak, nonatomic) IBOutlet UITextField *phoneCodeField;

@property (weak, nonatomic) IBOutlet UIButton *btnBungling;

@property (assign, nonatomic)BUNDLINGVC_ENTER_TYPE enterType;

@end
