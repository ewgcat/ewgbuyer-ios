//
//  GroupBuyViewController.h
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "GroupPurcheaseDetailModel.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>

@end

@interface GroupBuyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    //开始加载
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
   
    
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (assign,nonatomic) BOOL MyBool;
@property(nonatomic,strong) GroupPurcheaseDetailModel *groupModel;
@property (nonatomic, copy)NSString *groupBuy_id;
@property (nonatomic, copy)NSString *mobile;


@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;
+(id)sharedUserDefault;
@end
