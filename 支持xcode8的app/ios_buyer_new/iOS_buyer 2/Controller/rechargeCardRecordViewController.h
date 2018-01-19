//
//  rechargeCardRecordViewController.h
//  My_App
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeCardRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UITableView *MyTableView;
    NSMutableArray *dataArray;
}

@end
