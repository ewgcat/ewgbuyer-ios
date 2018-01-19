//
//  CommonLogisticsViewController.h
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonLogisticsViewController : BaseViewControllerNoTabbar<UITableViewDelegate,UITableViewDataSource>{
    UITableView *LogisticsTableView;//物流
    NSMutableArray *logisticsArr;
    
    NSMutableArray *defaultArray;
    NSMutableArray *noDefaultArray;
    
    __weak IBOutlet UIBarButtonItem *btnEdit;
    UIButton *btnFinish;
    UIButton *btnSubmit;
    NSString *cancelId;
    BOOL myBool;
    BOOL editBool;
    BOOL syBool;
}
- (IBAction)backBtnClicked:(id)sender;

@property (retain, nonatomic) UILabel *labelYimoren;
@property(nonatomic,strong)NSIndexPath *lastPath;
- (IBAction)editBtnClicked:(id)sender;

@end
