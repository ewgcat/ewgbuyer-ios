//
//  EnsureestimateViewController.h
//  My_App
//
//  Created by apple on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface EnsureestimateViewController2 : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,UITextViewDelegate>{
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    ASIFormDataRequest *request102;
    ASIFormDataRequest *request101;
    NSInteger xiangfuTag;
    NSInteger taiduTag;
    NSInteger suduTag;
    NSInteger pingjiaZhi;
    NSMutableArray *goodbadArray;
    NSMutableArray *pingjiaArray;
    NSMutableArray *scoreDataArray;
//    BOOL hasPic;
    NSInteger uploadCount;//上传完的图片数量
    NSInteger totalCount;//总共选取的图片数量
//    UIButton *selBtn;
    NSMutableDictionary *resultPicDict;
    NSMutableDictionary *imageIDDict;
    NSMutableDictionary *selBtnDict;
    NSMutableDictionary *btnStatusDict;
}

@property (strong,nonatomic) UITableView *MyTableView;


//+(id)sharedUserDefault;
@end
