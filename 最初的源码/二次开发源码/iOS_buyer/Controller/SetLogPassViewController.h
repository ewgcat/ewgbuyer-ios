//
//  SetLogPassViewController.h
//  My_App
//
//  Created by apple on 14-8-12.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetLogPassViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    __weak IBOutlet UIButton *saveBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *certain;


@property (weak, nonatomic) IBOutlet UITextField *oldLoginPassField;
@property (weak, nonatomic) IBOutlet UITextField *setNewLogPassField;
@property (weak, nonatomic) IBOutlet UITextField *setNewLogPassAgainField;

- (IBAction)btnSetUp:(id)sender;


@end
