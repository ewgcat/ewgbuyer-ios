//
//  OnlinePayTypeSelectViewController.h
//  My_App
//
//  Created by apple on 15-2-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"


@protocol sendMsgToWeChatViewDelegate <NSObject>
//- (void) changeScene:(NSInteger)scene;
//- (void) sendTextContent;
//- (void) sendImageContent;
//- (void) sendPay;
//- (void) sendPay_demo;
@end

@interface OnlinePayTypeSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    //开始加在
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    
    NSString *PartnerID;
    NSString *SellerID;
    NSString *PartnerPrivKey;
    NSString *AlipayPubKey;
    NSString *MD5_KEY;
    NSMutableArray *arrayPay;
    
    
//    UIWebView *myWebView;
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (assign,nonatomic) BOOL MyBool;
@property (assign,nonatomic) BOOL group;
@property (assign,nonatomic) BOOL groupCenter;
//订单类型
@property (nonatomic,strong) NSString *order_type;

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;
//+(id)sharedUserDefault;


@end
