//
//  ReceiveCouponsViewController.h
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveCouponsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    //优惠券信息
    __weak IBOutlet UIImageView *coupons_Image;
    __weak IBOutlet UILabel *coupons_Price;
    __weak IBOutlet UILabel *coupons_Info;
    __weak IBOutlet UILabel *coupons_Name;
    __weak IBOutlet UILabel *coupons_Time;
    
    __weak IBOutlet UIButton *codeRefreshBtm;
    //验证码
    __weak IBOutlet UITextField *CodeTextField;
    __weak IBOutlet UIImageView *CodeBgImage;
    __weak IBOutlet UIImageView *CodeImage;
    
    //登录按钮
    __weak IBOutlet UIButton *ReceiveBtn;
    
    //数组
    NSMutableArray *dataArray;
    
    //正在加载
//    __weak IBOutlet UIView *LoadingView;
//    __weak IBOutlet UIView *LoadingGrayView;
//    __weak IBOutlet UILabel *PromptLabel;
    
    //tableview
    __weak IBOutlet UITableView *ReceiveSuccessTableView;
    
    NSString *codeStr;
}

//登录按钮事件
- (IBAction)ReceiveBtnAction:(id)sender;

@end
