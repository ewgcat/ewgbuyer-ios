//
//  SettingViewController.h
//  SellerApp
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    __weak IBOutlet UILabel *label_prompt;
    __weak IBOutlet UIButton *signOutBtn;
}
- (IBAction)cleanImageBtnClicked:(id)sender;
- (IBAction)cleanChatBtnClicked:(id)sender;

- (IBAction)signOutBtnClicked:(id)sender;

@end
