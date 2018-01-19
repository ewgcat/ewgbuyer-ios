//
//  IntegralOrderDetailViewController.h
//  My_App
//
//  Created by apple on 15-1-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface IntegralOrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *nothingView;
    
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    
    UIButton *buttonCancel;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
}

@end
