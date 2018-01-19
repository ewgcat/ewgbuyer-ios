//
//  GoodsGroupDetailViewController.h
//  My_App
//
//  Created by apple on 15-1-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface GoodsGroupDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate,UIWebViewDelegate>{
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
@property (strong, nonatomic) UILabel *lblEvalcount;
@property (strong, nonatomic) UILabel *lblWellEval;
@property (strong, nonatomic) NSString *gg_goods_id;


@end
