//
//  zeroApplyAddressViewController.h
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zeroApplyAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    //开始加在
//    UIView *loadingV;
    UITableView * MyTableView;
    UITextView *myTextView;
    
    
    NSMutableArray *dataArray;
    UILabel *laLiuyan;
    NSString *liuyanStr;
    
//    UILabel *labelTi;//提示
    
    UIView *topWhiteTi;
}

@end
