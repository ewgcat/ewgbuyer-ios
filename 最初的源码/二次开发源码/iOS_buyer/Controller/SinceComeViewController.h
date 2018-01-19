//
//  SinceComeViewController.h
//  My_App
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinceComeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataArray;
    __weak IBOutlet UITableView *MyTableview;
}

@end
