//
//  OrderDetailViewController.h
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface OrderDetailViewController : BaseViewControllerNoTabbar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    UILabel *label_prompt;//提示label
    UIView *loadingV;
    
}

@property (nonatomic,copy)NSString *orderID;

@end
