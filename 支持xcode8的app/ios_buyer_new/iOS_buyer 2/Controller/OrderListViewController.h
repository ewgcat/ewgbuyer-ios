//
//  OrderListViewController.h
//  My_App
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    __weak IBOutlet UIScrollView *MyScrollView;
    
    UITableView *ListTableView;
    UITableView *ListTableView2;
    UITableView *ListTableView3;
    UITableView *ListTableView4;
    UITableView *ListTableView5;
    
    UIButton *Top_WaitGoodsReceipt;
    UIButton *Top_WaitMoney;
    UIButton *Top_WaitSend;
    UIButton *Top_AllBtn;
//    UIButton *Top_WaitEvaluation;
    UIButton *Top_FinishedBtn;
    
    NSInteger TopTag;
    
    NSMutableArray *dataArray;
    NSMutableArray *dataArray2;
    NSMutableArray *dataArray3;
    NSMutableArray *dataArray4;
    NSMutableArray *dataArray5;
    
    NSInteger CancelTag;
    NSInteger querenshouhuo;
    
    UIImageView *imageLine;
    
    __weak IBOutlet UIView *TopView;
    
    UIView *nothingView;
    UIView *nothingView2;
    UIView *nothingView3;
    UIView *nothingView4;
    UIView *nothingView5;
    
   @public BOOL tabbarshouldShow;
}
@property(nonatomic,assign) BOOL changeviewFrame;
- (IBAction)TopAction:(id)sender;

@end
