//
//  ShippingInfoViewController.h
//  SellerApp
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingInfoViewController : BaseViewControllerNoTabbar<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *shippingInfoTableView;
    UILabel *tishi;
    NSMutableArray *dataArr;
    NSMutableArray *pullDataArr;
    BOOL myBool;
    BOOL requestBool;
    BOOL btnClickedBool;
}

@property (retain, nonatomic) NSString *edit_id;
+(id)sharedUserDefault;
- (IBAction)addBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
