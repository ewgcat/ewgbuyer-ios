//
//  ChatViewController.m
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatFrame.h"
#import "Chat.h"
#import "ChatCell.h"
#import "ThirdViewController.h"
#import <CoreData/CoreData.h>
#import "CDChatList.h"

static NSString *entityName = @"CDChatMessages";

@interface ChatViewController ()<ThirdViewControllerDelegate>

@property (nonatomic, copy) NSString *lastMsg;

@end

@implementation ChatViewController

#pragma mark - 收到消息更新界面的代理方法
//来自买家
-(void)thirdViewController:(ThirdViewController *)thirdVC didReceivedMessage:(Chat *)message{
    //在这里拦截信息
    for (Chat * oldChat in self.history) {
        //如果消息ID和数据库中的重复，则不做操作
        if (oldChat.ID.integerValue == message.ID.integerValue) {
            return;
        }
        //如果发信人不是当前连接的用户，则不显示
        if (message.user_id.integerValue != self.chatInfo.user_id.integerValue){
            return;
        }
    }
    
    ChatFrame *mf = [[ChatFrame alloc] init];
    mf.chat = message;
    [allChatFrame addObject:mf];
    
    //按时间排序!!
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"chat.addTime" ascending:YES];
    allChatFrame = [[allChatFrame sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    
    [chatTableView reloadData];
    NSInteger rowCount = [chatTableView numberOfRowsInSection:0];
    [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
//来自卖家
-(void)thirdViewController:(ThirdViewController *)thirdVC didReceivedSellerMessage:(Chat *)message{
    if([message.content isEqualToString:self.lastMsg]){
        NSLog(@"收到卖家消息!");
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        [th insertIntoHistory:message];
        self.history = [th getHistoryByUserID:self.chatInfo.user_id serviceID:[MyNetTool serviceID]];
        [self showHistory];
        [self scrollToBottom];
    }
}
#pragma mark - 生命周期方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self scrollToBottom];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.online = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.chatInfo.user_name;
    self.view.backgroundColor = [UIColor whiteColor];
    allChatFrame = [[NSMutableArray alloc]init];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.delegate = self;
    [th link:self.chatInfo];
    //**********************聊天信息************************//
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-69-49) style:UITableViewStylePlain];
    }else{
        chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-69-49) style:UITableViewStylePlain];
    }
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.allowsSelection = NO;
    chatTableView.showsVerticalScrollIndicator= NO;
    chatTableView.showsHorizontalScrollIndicator = NO;
    chatTableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:chatTableView];
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [chatTableView addGestureRecognizer:singleTapGestureRecognizer3];

    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [chatTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    UIImageView *imgBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64-49)];
    imgBackView.image = [UIImage imageNamed:@"blueSky"];
    [self.view addSubview:imgBackView];
    
    //聊天框
    imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height - 49, ScreenFrame.size.width, 49)];
    imgBG.backgroundColor = [UIColor whiteColor];
    imgBG.userInteractionEnabled = YES;
    [self.view addSubview:imgBG];
    
    self.chatField = [LJControl textFieldFrame:CGRectMake(15, 2, ScreenFrame.size.width - 94, 40) text:@"" placeText:@" 请输入聊天信息" setfont:16 textColor:[UIColor blackColor] keyboard:UIKeyboardTypeDefault];
    self.chatField.delegate = self;
    self.chatField.layer.borderWidth = 2;
    self.chatField.layer.borderColor = [NAV_COLOR CGColor];
    [self.chatField.layer setMasksToBounds:YES];
    [self.chatField.layer setCornerRadius:4];
    self.chatField.returnKeyType = UIReturnKeyDone;
    [imgBG addSubview:self.chatField];
    
    UIButton *btnSendOut = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width - 69, 3, 54, 38) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"发送" setTitleFont:17 setbackgroundColor:NAV_COLOR];
    CALayer *lay2 = btnSendOut.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:5.0f];
    btnSendOut.tag = 101;
    [btnSendOut addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgBG addSubview:btnSendOut];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self createBackBtn];
    [self showHistory];
}
#pragma mark - tableView数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (allChatFrame.count != 0) {
        return [allChatFrame[indexPath.row] cellHeight];
    }
    return [allChatFrame[indexPath.row] cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (allChatFrame.count != 0) {
        return allChatFrame.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }else{
        
    }
    if (allChatFrame.count != 0){
        cell.chatFrame = allChatFrame[indexPath.row];
    }
    
    return cell;
}
#pragma mark - 键盘以及滚动控制
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        imgBG.transform = CGAffineTransformMakeTranslation(0, ty);
        chatTableView.frame = CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-69-49+ty);
        [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height -chatTableView.bounds.size.height) animated:NO];
    }];
}
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        imgBG.transform = CGAffineTransformIdentity;
        chatTableView.frame = CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-69-49);
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)disappear{
    [_chatField resignFirstResponder];
}
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    UIButton *btn = [UIButton new];
    btn.tag = 101;
    [self btnClicked:btn];
    return NO;
}
-(void)scrollToBottom {
    if (allChatFrame.count >=1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:allChatFrame.count - 1 inSection:0];
        [chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark - 显示历史数据
-(void)showHistory {
    [allChatFrame removeAllObjects];
    for (int i=0; i<self.history.count; i++) {
        Chat *chat = self.history[i];
        ChatFrame *mf = [[ChatFrame alloc] init];
        mf.chat = chat;
        [allChatFrame addObject:mf];
    }
    [chatTableView reloadData];
}
#pragma mark - 给客户发送信息
-(void) btnClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        //发起请求
        if(self.chatField.text.length == 0){
            [MyObject failedPrompt:@"消息内容不能为空"];
        }else{
            NSString *service_id = [MyNetTool serviceID];
            if (!service_id) {
                NSString *errStr = @"没有service_id";
                [MyObject failedPrompt:errStr];
                return;
            }
            NSDictionary *dict = @{
                                   @"type":@"service",//固定
                                   @"service_id":service_id,//商家ID
                                   @"content":self.chatField.text,//聊天信息
                                   @"user_id":self.chatInfo.user_id.stringValue//客户ID
                                   };
            //转json,发送验证信息给服务器
            NSError *err;
            NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
            NSString *jsonString = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            if (err) {
                NSLog(@"发送参数出错:%@",[err localizedDescription]);
                return;
            }
            if (!json) {
                NSLog(@"json转换失败");
                return;
            }
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            [th send:jsonString];

            self.lastMsg = self.chatField.text;
            [th link:self.chatInfo];
            self.chatField.text = @"";
            
        }
    }
}
#pragma mark - 初始化视图
-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
