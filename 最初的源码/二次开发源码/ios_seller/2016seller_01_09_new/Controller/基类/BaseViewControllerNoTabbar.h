//
//  BaseViewControllerNoTabbar.h
//  SellerApp
//
//  Created by shiyuwudi on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewControllerNoTabbar : UIViewController

-(void)setRightBtnWithTitle:(NSString *)title normalImg:(NSString *)normalImg highlightImg:(NSString *)highlightImg target:(id)target action:(SEL)action;
-(void)backAction;

@end
