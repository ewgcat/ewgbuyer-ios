//
//  OrderCancelViewController.h
//  SellerApp
//
//  Created by apple on 15-4-1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface OrderCancelViewController : BaseViewControllerNoTabbar<UITextViewDelegate>
{
    UIView *loadingV;
    UILabel *label_prompt;
    
    UIImageView *imgeReason;
    UIImageView *imgeReason2;
    UIImageView *imgeReason3;
    UITextView *otherTextView;//其他原因输入框
    UIView *otherView;//其他原因视图
    NSInteger reasonTag;
}
@end
