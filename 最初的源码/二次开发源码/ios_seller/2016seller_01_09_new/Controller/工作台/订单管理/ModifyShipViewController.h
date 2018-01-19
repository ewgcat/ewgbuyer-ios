//
//  ModifyShipViewController.h
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface ModifyShipViewController : BaseViewControllerNoTabbar<UITextFieldDelegate,UITextViewDelegate>
{
    UITextView *textview_directions;//操作说明
    UITextField *shipnum;//物流单号
    UIView *loadingV;
    UILabel *label_prompt;
    UILabel *lbl_ordernum2;//订单号
}
@end
