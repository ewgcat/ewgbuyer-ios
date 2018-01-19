//
//  ContactUsViewController.h
//  My_App
//
//  Created by apple on 14-8-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

//
@interface ContactUsViewController : UIViewController<ASIHTTPRequestDelegate>{
    ASIFormDataRequest *requestContactUs2;
    
    __weak IBOutlet UILabel *lblRegisterName;
    __weak IBOutlet UILabel *lblTelphone;
    
}


@end
