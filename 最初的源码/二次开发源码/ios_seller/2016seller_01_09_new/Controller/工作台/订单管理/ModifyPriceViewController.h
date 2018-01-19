//
//  ModifyPriceViewController.h
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface ModifyPriceViewController : BaseViewControllerNoTabbar<UITextFieldDelegate>
{
    UITextField *goodstotalPrice;//总金额
    UITextField *shipPrice;//配送金额
    UIView *loadingV;
    UILabel *label_prompt;
    UILabel *lbl_ordernum2;//买家用户
    UILabel *lbl_shipCom2;//订单号
    UILabel *lbl_ads2;//佣金
    UILabel *lbl_DDPrice;//金额
}
@end
