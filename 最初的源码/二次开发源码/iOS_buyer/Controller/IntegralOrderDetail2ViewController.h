//
//  IntegralOrderDetail2ViewController.h
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface IntegralOrderDetail2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *nothingView;
    
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    
    
    UIButton *buttonCancel;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_1;
}

@end
