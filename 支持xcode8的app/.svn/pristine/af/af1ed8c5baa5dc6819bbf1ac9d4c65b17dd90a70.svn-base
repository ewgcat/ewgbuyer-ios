//
//  GroupDetailViewController.h
//  My_App
//
//  Created by apple on 15-1-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"



@interface GroupDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate,UIWebViewDelegate,UIAlertViewDelegate>{
    UITableView *shjTableView;
    
    BOOL scrollBool;
    UIWebView *myWebView;
    ASIFormDataRequest *request101;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (strong, nonatomic) UIImageView *imgLog;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblPresentPrice;
@property (strong, nonatomic) UILabel *lblOriginalPrice;
@property (strong, nonatomic) UILabel *lblSave;
@property (strong, nonatomic) UILabel *lblCutOffTime;
@property (strong, nonatomic) UILabel *lblYishouchu;



@end
