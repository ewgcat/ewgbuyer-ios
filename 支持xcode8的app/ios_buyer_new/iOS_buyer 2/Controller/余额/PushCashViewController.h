//
//  PushCashViewController.h
//  My_App
//
//  Created by barney on 15/12/14.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>

@end

@interface PushCashViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (assign,nonatomic) BOOL MyBool;

@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *order_cash;
@property (nonatomic,copy) NSString *order_id;   //传值

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;

+(id)sharedUserDefault;

@end
