//
//  EstimateViewController.h
//  My_App
//
//  Created by apple on 14-7-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface EstimateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    NSMutableArray *dataArray;
    NSMutableArray *dataArrShangla;
    
    __weak IBOutlet UITableView *MyTableView;
    BOOL requestBool;
    
    //开始加在
//    IBOutlet UIView *loadingV;
    
    IBOutlet UIImageView *imageZanwu;
    IBOutlet UILabel *la;
    
    __weak IBOutlet UIView *grayView;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
}


@end
