//
//  writeViewController.h
//  My_App
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdViewController.h"
#import "ASIFormDataRequest.h"





@interface writeViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,WDAlertViewDatasource,WDAlertViewDelegate>{
    NSMutableArray *dataArray;
    NSMutableArray *billdataArray;
    ThirdViewController *third;
    BOOL mybool;
    NSMutableArray *alertListArray;
    WDAlertView *alertList;
    
    //开始加在

    __weak IBOutlet UILabel *labelTi;
}

@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UILabel *realPrice;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;







- (IBAction)btnClicked:(id)sender;

@end
