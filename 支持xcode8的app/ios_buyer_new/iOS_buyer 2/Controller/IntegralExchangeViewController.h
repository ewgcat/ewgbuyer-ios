//
//  IntegralExchangeViewController.h
//  My_App
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface IntegralExchangeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UIImageView *nothingImage;
    __weak IBOutlet UILabel *nothingLabel;
    __weak IBOutlet UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    
    NSInteger deletTag;
    
    NSString *oid;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    BOOL muchBool;
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIImageView *grayMuchImage;
    //跳转按钮
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *fifthBtn;
}


- (IBAction)tabbarBtnClicked:(id)sender;


@end
