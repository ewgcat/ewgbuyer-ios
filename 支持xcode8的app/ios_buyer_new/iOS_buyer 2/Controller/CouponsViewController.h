//
//  CouponsViewController.h
//  My_App
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface CouponsViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    __weak IBOutlet UIImageView *nothingImage;
    __weak IBOutlet UILabel *nothingLabel;
    
    NSMutableArray *dataArray;
    ASIFormDataRequest *request103;
    ASIFormDataRequest *request102;
    ASIFormDataRequest *request_1;
    NSMutableArray *dataArrShangla;
    
    __weak IBOutlet UITableView *ShjTableView;
    BOOL requestBool;
}



@end
