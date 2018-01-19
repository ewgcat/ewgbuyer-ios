//
//  PhysicalOrderViewController.h
//  My_App
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface PhysicalOrderViewController2 : UIViewController
<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,UIActionSheetDelegate>{
    
    __weak IBOutlet UITableView *MyTableView;
    NSMutableArray *dataArray;//原来数据
    NSMutableArray *dataArrShangla;//上拉后的数据
    
    __weak IBOutlet UIView *promptView;
    UIScrollView *myScrollView;
    
    
    ASIFormDataRequest *requestPhysicalOrder13;
    ASIFormDataRequest *requestPhysicalOrder1;
    ASIFormDataRequest *requestPhysicalOrder2;
    ASIFormDataRequest *requestPhysicalOrder4;
    ASIFormDataRequest *requestPhysicalOrder5;
    
    NSInteger querenshouhuo;
    
    NSString *PayStr;
    
    NSString *canPaytyppe;
    
    
    BOOL requestBool;
    
    BOOL muchBool;//更多视图bool值
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIView *muchGray;
    
    __weak IBOutlet UIButton *fifthBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
}

- (IBAction)tabbarBtnClicked:(id)sender;
@property (strong, nonatomic) NSString *entries;

@property (assign,nonatomic) BOOL popBool;
@property (strong,nonatomic) NSString *xuanzhongdezhifufangshi;

+(id)sharedUserDefault;;

@end
