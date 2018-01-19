//
//  CashBalanceViewController.h
//  My_App
//
//  Created by barney on 15/12/14.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashBalanceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ableCash;
@property (weak, nonatomic) IBOutlet UITextField *putCash;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property(nonatomic,weak)UILabel *cashLab;

@end
