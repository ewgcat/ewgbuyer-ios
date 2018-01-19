//
//  rechargeRecordViewController.h
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *MyTableView;
}

@end
