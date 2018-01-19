//
//  SHJAddManageViewController.h
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface SHJAddManageViewController2 : UIViewController<UITextFieldDelegate,UITextViewDelegate,ASIHTTPRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *regionArray;
    UIImageView *regionView;
    UILabel *selectRegion;
    NSString *regionStr;
    NSString *regionID;
    UITableView *RegoinTableView;
    
    NSString *My_id;
    
    ASIFormDataRequest *requestAddManage1;
    ASIFormDataRequest *requestAddManage3;
}

@property (strong, nonatomic)  UITextField *tureNameField;
@property (strong, nonatomic)  UITextField *mobileField;
@property (strong, nonatomic)  UITextField *zipField;
@property (strong, nonatomic)  UITextView *addInfoText;
@property (strong, nonatomic)  UILabel *lblPrompt;
@property (strong, nonatomic)  UILabel *regionMyLable;



- (IBAction)btnprovince:(id)sender;
- (IBAction)btnCity:(id)sender;
- (IBAction)btnTown:(id)sender;

@property (strong, nonatomic)  UILabel *lblProvince;
@property (strong, nonatomic)  UILabel *lblCity;
@property (strong, nonatomic)  UILabel *lblTown;
@property (nonatomic, copy)NSString *xiu_area;


@end
