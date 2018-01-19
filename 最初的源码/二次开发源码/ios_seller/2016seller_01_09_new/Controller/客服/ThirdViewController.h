//
//  ThirdViewController.h
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <sqlite3.h>
#import "sqlService.h"
#import "BaseViewControllerNoTabbar.h"

@class ThirdViewController;
@class SRWebSocket;
@class Chat;

@protocol ThirdViewControllerDelegate <NSObject>

-(void)thirdViewController:(ThirdViewController *)thirdVC didReceivedMessage:(Chat *)message;
-(void)thirdViewController:(ThirdViewController *)thirdVC didReceivedSellerMessage:(Chat *)message;

@end

@interface ThirdViewController : BaseViewControllerNoTabbar<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *unreadCountArray;
    NSMutableArray *dataArray;
    
    __weak IBOutlet UIView *loadingV;
    __weak IBOutlet UIView *viewP;
    __weak IBOutlet UITableView *chatTableView;
    
    @public SRWebSocket *socket;
}

@property (nonatomic, assign)BOOL online;
@property (retain,nonatomic) NSString *chatIndex;
@property (retain,nonatomic) NSString *chatPhoto;
@property (weak, nonatomic)id<ThirdViewControllerDelegate> delegate;

//单例构造方法
+(id)sharedUserDefault;

//消息页要用到的数据库操作方法
-(void)insertIntoHistory:(Chat *)chatModel;
-(NSArray *)getHistoryByUserID:(NSNumber *)userID serviceID:(NSString *)serviceID;
- (void)send:(id)data;
-(void)link:(Chat *)user;

@end
