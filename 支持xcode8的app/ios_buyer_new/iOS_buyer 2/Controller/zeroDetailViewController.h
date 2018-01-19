//
//  zeroDetailViewController.h
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface zeroDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,EGORefreshTableHeaderDelegate>
{
    
    UIWebView *myWebView;
    UITableView *MyTableView;
    __weak IBOutlet UILabel *labelTi;
    __weak IBOutlet UIView *grayView;
    __weak IBOutlet UIView *loadingV;
    
    __weak IBOutlet UIButton *freeBtn;
    BOOL requestBool;
    NSMutableArray *dataArray;
    BOOL scrollBool;//mytableview滑动到底部的
    
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
    
}

@end
