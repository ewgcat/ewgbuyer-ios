//
//  ChatViewController.h
//  My_App
//
//  Created by apple on 15-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@class SRWebSocket;

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ASIHTTPRequestDelegate>{
    // 文本框容器
    UIImageView *imgBG;
    // 数据源，包含了chat数据模型和动态位置计算
    NSMutableArray  *_allChatFrame;
    NSTimer *myTimer;
    // 未知标记 0表示数据上传
    NSInteger TTType;
    // 信息提示lable
    UILabel *labelTi;
    
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request3;
    SRWebSocket *socket;
}
@property (strong, nonatomic) UITextField *chatTextField;
@property (strong, nonatomic) UITableView *myTableView;

@end
