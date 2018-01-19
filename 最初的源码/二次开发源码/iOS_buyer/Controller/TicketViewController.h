//
//  TicketViewController.h
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketViewController : UIViewController<UITextFieldDelegate>{
    NSInteger btnTag;
}
@property (weak, nonatomic) IBOutlet UIButton *puBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeng;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;
@property (weak, nonatomic) IBOutlet UITextField *taitou;
- (IBAction)btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *detail;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@end
