//
//  ChatViewController.h
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Chat;

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *chatTableView;//客服信息
    UIImageView *imgBG;//聊天框
    
    NSMutableArray  *allChatFrame;//存放聊天数据的数组
    NSMutableArray *dataArray;
    NSInteger TTType;//判断是用户还是自己
    
    NSString *photoImage;
    
    UILabel *label_prompt;//提示label
    UIView *loadingV;//正在加载视图
    
    NSTimer *myTimer;//5秒一次的
}

@property (retain, nonatomic) UITextField* chatField;//聊天框
//初始化需要的数据
@property (nonatomic, strong) Chat* chatInfo;//当前正在聊天的用户信息
@property (nonatomic, strong)NSArray *history;//历史消息

@end
