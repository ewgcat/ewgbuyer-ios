//
//  SearchViewController.h
//  My_App
//
//  Created by apple on 15-4-1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    __weak IBOutlet UITextField *_MyTextField;
    __weak IBOutlet UILabel *bottomLabel;
    __weak IBOutlet UIButton *searchBtn;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UIButton *clearHistoryBtn;
//    __weak IBOutlet UILabel *labelTi;
    
    __weak IBOutlet UITableView *MyTableView;
    __weak IBOutlet UIView *nothingView;
}

@property (strong, nonatomic)  NSString *selectLabel;//选中的那个lable


@end
