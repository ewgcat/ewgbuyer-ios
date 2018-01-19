//
//  SignViewController.h
//  My_App
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignViewController : UIViewController{
    
    __weak IBOutlet UIButton *SignBtn;
//    __weak IBOutlet UIView *LoadingView;
//    __weak IBOutlet UIView *LoadingGrayView;
//    __weak IBOutlet UILabel *PromptLabel;
    __weak IBOutlet UILabel *todayLabel;
}
- (IBAction)SignAction:(id)sender;

@end
