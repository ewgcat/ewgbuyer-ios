//
//  buyer_returnViewController.h
//  My_App
//
//  Created by apple on 15-1-22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface buyer_returnViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    
    BOOL muchBool;//更多视图bool值
    UIView *muchView;
}

@end
