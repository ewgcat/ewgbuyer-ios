//
//  SHJAddManageViewController.h
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface SHJAddManageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,ASIHTTPRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *regionArray;
    UIView *regionView;
    UILabel *selectRegion;
    NSString *regionStr;
    NSString *regionID;
    UITableView *RegoinTableView;
    
    NSString *My_id;
    
    ASIFormDataRequest *requestAddressManagement1;
    ASIFormDataRequest *requestAddressManagement2;
}

@property (retain, nonatomic)  UITextField *tureNameField;
@property (retain, nonatomic)  UITextField *mobileField;
@property (retain, nonatomic)  UITextField *zipField;
@property (retain, nonatomic)  UITextView *addInfoText;
@property (retain, nonatomic)  UILabel *lblPrompt;

@property (retain, nonatomic)  UILabel *regionMyLable;

@property (strong, nonatomic)  UIView *bottomView;


- (IBAction)btnprovince:(id)sender;
- (IBAction)btnCity:(id)sender;



@end
