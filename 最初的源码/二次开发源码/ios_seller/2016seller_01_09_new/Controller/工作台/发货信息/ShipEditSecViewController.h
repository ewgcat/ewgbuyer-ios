//
//  ShipEditSecViewController.h
//  SellerApp
//
//  Created by apple on 15-4-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipEditSecViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *cityTableView;
    UIView *regionView;
    UILabel *label_prompt;
    
    NSMutableArray *regionArray;
    NSString *regionID;
    NSString *regionStr;
    NSString *My_id;
    UILabel *labelCity;
    UIView *loadingV;
}


@property (retain, nonatomic) UITextField *consigneeField;      //联系人
@property (retain, nonatomic) UITextField *shipAddrField;     //地址名称
@property (retain, nonatomic) UITextField *addrNumField;         //地址序号
@property (retain, nonatomic) UITextField *shipTelField;        //联系电话
@property (retain, nonatomic) UITextField *shipCompanyField;       //发货公司
@property (retain, nonatomic) UITextField *shipAreaCodeField;        //发货区号
@property (retain, nonatomic) UITextView *shipStreetAddrField;      //街道地址
@property (retain, nonatomic) UITextField *shipZipField;

@property (retain, nonatomic) UILabel *lblTVTishi;   //textView提示

@property (retain, nonatomic) UILabel *lblCity; // 显示城市

@end
