//
//  myzeroViewController.h
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myzeroViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *nothingView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    __weak IBOutlet UITableView *MyTableView;
    BOOL muchBool;//更多视图bool值
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIView *muchGray;
    
    __weak IBOutlet UIButton *fifthBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
}
- (IBAction)tabbarBtnClicked:(id)sender;

@end
