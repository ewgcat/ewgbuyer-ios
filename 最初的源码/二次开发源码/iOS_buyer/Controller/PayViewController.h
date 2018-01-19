//
//  PayViewController.h
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface PayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray *arr222;
    NSMutableArray *arr333;
    NSMutableArray *peisongArray;
    NSInteger scrollViewHeight;
    
    NSInteger btnTag;
    
    UILabel *fei;
    
    NSMutableArray *youfei;
    NSMutableArray *value_money;
   
    
    UIImageView *imageG;
    
    NSString *fangshiFirst;
    NSString *payType;
    UITableView  *MyTableView222;
    NSMutableArray *MyDataarray;
    NSMutableArray *zhifufangshiDataarray;
    
    NSMutableArray *arrayShip;
    
    NSInteger paypayTag;
    
    NSMutableArray *NewpeisongArray;
    
    NSInteger timeTag;
    NSString *timeStr;
    UIView *pickerBgView;
    UIPickerView *pickerview;
    NSMutableArray *pickerDataLeft;
    NSMutableArray *pickerDataRight;
    NSString *leftStr;
    NSString *rightStr;
    BOOL sinceComeTag;
}

@property(strong,nonatomic)UITableView *MyTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;

@property (weak, nonatomic) IBOutlet UILabel *payMethod;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *queding;
@property (strong,nonatomic) NSString *addressStr;
@property (strong,nonatomic) NSString *SelfTimeStr;
@property (assign,nonatomic) NSInteger address_id;
- (IBAction)btnClicked:(id)sender;
+(id)sharedUserDefault;

@end
