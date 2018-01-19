//
//  rechargeViewController.h
//  My_App
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeViewController : UIViewController<UITextFieldDelegate>{
    __weak IBOutlet UIButton *selfBtn;
    __weak IBOutlet UIButton *five_hundredBtn;
    __weak IBOutlet UIButton *three_hundredBtn;
    __weak IBOutlet UIButton *two_hundredBtn;
    __weak IBOutlet UIButton *hundredBtn;
    __weak IBOutlet UIButton *fiftyBtn;
    __weak IBOutlet UIButton *thirtyBtn;
    __weak IBOutlet UIButton *twentyBtn;
    __weak IBOutlet UIButton *tenBtn;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIButton *rechargeBtn;
    __weak IBOutlet UILabel *moneyLabel;
    __weak IBOutlet UIButton *contactsBtn;
    __weak IBOutlet UITextField *numberTextField;
    NSMutableArray *addressListArray;
}

@property(strong,nonatomic) NSString *phoneNumber;

+(id)sharedUserDefault;
@end
