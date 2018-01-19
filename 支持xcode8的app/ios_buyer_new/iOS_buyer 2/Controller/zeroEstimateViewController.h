//
//  zeroEstimateViewController.h
//  My_App
//
//  Created by apple on 15-1-19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zeroEstimateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
//    UIView *loadingV;
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
}
@end
