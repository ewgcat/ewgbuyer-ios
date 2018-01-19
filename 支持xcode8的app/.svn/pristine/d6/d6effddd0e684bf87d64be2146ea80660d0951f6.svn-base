//
//  Seconde_sub2ViewController.h
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface Seconde_sub2ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIImageView *priceImage;
    __weak IBOutlet UIButton *FilterSecondBackBtn;
    __weak IBOutlet UIView *FilterSecondView;
    __weak IBOutlet UILabel *FilterSecondTitle;
    __weak IBOutlet UITableView *FilterTwoTableView;
    __weak IBOutlet UIImageView *FilterBgImage;
    __weak IBOutlet UIView *FilterView;
    __weak IBOutlet UIButton *PopularityBtn;
    
    __weak IBOutlet UITableView *FilterTableView;
    __weak IBOutlet UIButton *NewGoodsBtn;
    __weak IBOutlet UIButton *PriceBtn;
    __weak IBOutlet UIButton *SalesBtn;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UIButton *filterBtn;
    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UIButton *ClearFilterBtn;
    __weak IBOutlet UILabel *searchBg;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UILabel *labelTi;

    __weak IBOutlet UIView *nothingView;
    __weak IBOutlet UITableView *MyTableView;
    
    __weak IBOutlet UIView *titleView;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    NSMutableArray *FilterDataArray;
    BOOL shanglaBool;
    BOOL requestBool;
    UIImageView *imageNothing;//什么都没有图片
    NSString *select_attribute;//用来判断是哪个上啦刷新
    BOOL priceBool;
    
    CGFloat lastContentOffset;
    
    NSInteger FilterFirstIndex;
    BOOL btnClickedBool;
    
    NSMutableDictionary *filterConditions;
}

- (IBAction)filterAction:(id)sender;
- (IBAction)gotoTopAction:(id)sender;


@end
