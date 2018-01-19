//
//  LifeGroupViewController.h
//  My_App
//
//  Created by apple on 15-1-23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *MyTableView;
    UILabel *laLiuyan;
    UITextView *myTextView;
    NSInteger tagReason;
    UITextField *textFieldGoodsCount;
}

@end
