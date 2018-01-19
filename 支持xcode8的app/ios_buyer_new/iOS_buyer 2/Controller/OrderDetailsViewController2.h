//
//  OrderDetailsViewController2.h
//  My_App
//
//  Created by apple on 14-10-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface OrderDetailsViewController2 : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    NSMutableArray *dataArray;
    __weak IBOutlet UITableView *MyTableView;
    
    ASIFormDataRequest *requestOrderDetails1;
    ASIFormDataRequest *requestOrderDetails2;
    ASIFormDataRequest *requestOrderDetails3;
    ASIFormDataRequest *requestOrderDetails4;
    ASIFormDataRequest *requestOrderDetails12;
    
    UIButton *buttonquxiao;
    NSString *PayStr;
    NSString *canPaytyppe;
}


@property (nonatomic, strong) UILabel *lblGoodsName2;
@property (nonatomic, strong) UILabel *lblGoodsPrice2;
@property (nonatomic, strong) UILabel *lblGoodsNum2;

-(void)wlBtnClicked;

@end

