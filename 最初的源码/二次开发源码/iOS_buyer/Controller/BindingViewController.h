//
//  BindingViewController.h
//  My_App
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingViewController : UIViewController{
    __weak IBOutlet UIButton *bundingBtn;
}
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)bundingBtnClicked:(id)sender;
@end
