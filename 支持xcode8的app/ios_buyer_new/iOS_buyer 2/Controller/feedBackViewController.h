//
//  feedBackViewController.h
//  My_App
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedBackViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UIImageView *typeImageView;
    __weak IBOutlet UITableView *typeTableView;
    __weak IBOutlet UIView *typeView;
    __weak IBOutlet UIView *middleView;
}
- (IBAction)feedbackTypeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *feedbackContent;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *submiBtnClicked;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
