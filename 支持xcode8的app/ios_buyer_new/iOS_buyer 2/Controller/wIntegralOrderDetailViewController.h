//
//  wIntegralOrderDetailViewController.h
//  My_App
//
//  Created by apple on 15-2-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wIntegralOrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *nothingView;
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    
    UIButton *buttonCancel;
    
}

@end
