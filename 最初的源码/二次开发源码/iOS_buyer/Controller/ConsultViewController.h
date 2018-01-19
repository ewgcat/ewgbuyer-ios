//
//  ConsultViewController.h
//  My_App
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface ConsultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    NSMutableArray *dataArray;//数组
    
    NSMutableArray *dataArrShangla;//上拉刷新请求结果的保存数组
    
//    __weak IBOutlet UIView *loadingV;
    BOOL requestBool;
    BOOL btnClickedBool;
    
//    __weak IBOutlet UIView *grayView;
    NSInteger selectBtnTag;//选中按钮tag值
    
//    __weak IBOutlet UILabel *labelTi;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    ASIFormDataRequest *request_10;
    ASIFormDataRequest *request_11;
    ASIFormDataRequest *request_12;
    ASIFormDataRequest *request_13;
    ASIFormDataRequest *request_14;
    ASIFormDataRequest *request_15;
    ASIFormDataRequest *request_16;
    ASIFormDataRequest *request_17;
    ASIFormDataRequest *request_18;
}
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

//@property (nonatomic, strong) PullToRefreshTableView * MyTableView;//评价列表
- (IBAction)segControlAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *MysegControl;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;

//- (IBAction)btnClicked:(id)sender;




@end
