//
//  lifeGroupOrderDetailViewController.h
//  My_App
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface lifeGroupOrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    UIButton *buttonCancel;
    ASIFormDataRequest *requestlifeGroupOrderDetail1;
    ASIFormDataRequest *requestlifeGroupOrderDetail2;
    ASIFormDataRequest *requestlifeGroupOrderDetail3;
}
@end
