//
//  MyOrderViewController.h
//  SellerApp
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableView.h"
#import "_015b2b2cseller-Swift.h"

@interface MyOrderViewController : BaseViewControllerNoTabbar<UITableViewDelegate,UITableViewDataSource,MultiSelectBarDelegate>{
    UILabel *lblWeijiesuan;
    UILabel *lblKejiesuan;
    UILabel *lblJiesuanzhong;
    UILabel *lblYijiesuan;
    
    UITableView *myOrderTableView;
    BOOL requestBool;//请求bool
    BOOL btnClickedBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataPullArray;
    
    UIView *faildV;//加载失败视图
    
}
@property (strong,nonatomic)NSString *order_id;
@property (assign,nonatomic)NSInteger payoffTag;
@property (weak, nonatomic)MultiSelectBar *multiSelectBar;
@property (weak, nonatomic)UISegmentedControl *segmentControl;
+(id)sharedUserDefault;
@end
