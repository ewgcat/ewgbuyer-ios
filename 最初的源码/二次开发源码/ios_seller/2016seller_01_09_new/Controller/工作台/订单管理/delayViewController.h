//
//  delayViewController.h
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface delayViewController : BaseViewControllerNoTabbar<UITextFieldDelegate>
{
    UITextField *delayTime;
    UIView *loadingV;
    UILabel *label_prompt;
    UILabel *lbl_ordernum2;//订单号
}
@end
