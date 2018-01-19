//
//  PublishViewController.h
//  My_App
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *MyTableView;
    UIView *categoryView;
    __weak IBOutlet UILabel *categoryLabel;
    __weak IBOutlet UIButton *categoryBtn;
    NSArray *CategoryArray;
}
//@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;//输入框
@property (weak, nonatomic) IBOutlet UIButton *upBtn;//提交按钮
- (IBAction)btnClicked:(id)sender;

@end
