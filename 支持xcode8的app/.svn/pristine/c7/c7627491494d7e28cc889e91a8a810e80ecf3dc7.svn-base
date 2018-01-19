//
//  onlinePayTypesIntegralViewController.h
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"


@protocol sendMsgToWeChatViewDelegate <NSObject>

@end


@interface onlinePayTypesIntegralViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
   
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    UIWebView *myWebView;
    NSString *PartnerID;
    NSString *SellerID;
    NSString *PartnerPrivKey;
    NSString *AlipayPubKey;
    NSString *MD5_KEY;
    NSMutableArray *arrayPay;
    NSInteger tagZHI;
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (assign,nonatomic) BOOL MyBool;
@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;
-(void)webVIewRefresh;
+(id)sharedUserDefault;
-(void)wxPayFaild;
-(void)wxPayCancel;

@end
