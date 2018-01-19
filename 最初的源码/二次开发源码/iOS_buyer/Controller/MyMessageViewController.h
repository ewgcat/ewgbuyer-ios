//
//  MyMessageViewController.h
//  My_App
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "ThreeDotView.h"
@interface MyMessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>
{
    NSMutableArray *dataArr;
    NSMutableArray *dataArrShangla;
    NSArray *arr2;
    NSMutableArray *arrDic;
    NSMutableArray *arrTitle;
    
    ASIFormDataRequest *requestMessage1;
    ASIFormDataRequest *requestMessage2;
    
    BOOL requestBool;
    BOOL muchBool;//更多视图bool值

    //跳转按钮
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *fifthBtn;
    __weak IBOutlet UITableView *shjTableView;
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIImageView *grayMuchImage;
    __weak IBOutlet UIView *promptView;
}

@property(strong, nonatomic) NSArray *arr;
@property(nonatomic) BOOL refreshing;
@property(assign, nonatomic) NSInteger page;
@property (nonatomic, weak)ThreeDotView *tdv;

- (IBAction)tabbarBtnClicked:(id)sender;

@end
