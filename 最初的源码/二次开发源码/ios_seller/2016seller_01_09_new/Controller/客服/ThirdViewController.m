//
//  ThirdViewController.m
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThirdViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Model.h"
#import "myAfnetwork.h"
#import "myselfParse.h"
#import "sqlService.h"
#import "ThirdlistCell.h"
#import "SRWebSocket.h"
#import "Chat.h"
#import "ChatFrame.h"
#import <CoreData/CoreData.h>
#import "CDChatList.h"
#import "Entity.h"

static NSString *chatHistory = @"CDMessage";

@interface ThirdViewController ()<SRWebSocketDelegate>

@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic, assign) NSInteger oldServiceID;


@end

static ThirdViewController *singleInstance=nil;

@implementation ThirdViewController
#pragma mark -数据库上下文懒加载
- (NSManagedObjectContext *)context
{
    NSInteger newServiceID = [MyNetTool serviceID].integerValue;
    if ( !_context ||_oldServiceID != newServiceID) {
        NSManagedObjectModel * moModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator * psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:moModel];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@/Documents/chatList_%@.data", NSHomeDirectory(),[MyNetTool currentUserID]]];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:NULL];
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        _oldServiceID = newServiceID;
    }
    return _context;
}
#pragma mark - 消息增删改查
//增
-(void)insertIntoHistory:(Chat *)chatModel {
    //core data没有主键，要判断ID不重复才插入
    NSArray *history = [self getHistoryByUserID:chatModel.user_id serviceID:[MyNetTool serviceID]];
    for (Chat *oldChat in history) {
        if (oldChat.ID.integerValue == chatModel.ID.integerValue) {
            return;
        }
    }
    //所有历史信息
    Entity *message = [NSEntityDescription insertNewObjectForEntityForName:chatHistory inManagedObjectContext:self.context];
    message.user_id = chatModel.user_id;
    message.user_name = chatModel.user_name;
    message.content = chatModel.content;
    message.addTime = chatModel.addTime;
    message.iid = (NSNumber *)chatModel.ID;
    message.send_from = chatModel.send_from;
    message.service_id = (NSNumber *)chatModel.service_id;
    message.service_name = chatModel.service_name;
    NSError * err;
    if ( ![self.context save:&err] ) {
        NSLog(@"插入数据失败:%@", err.localizedDescription);
    }
}
//查，某个商家和某个人的消息记录
-(NSArray *)getHistoryByUserID:(NSNumber *)userID serviceID:(NSString *)serviceID{
    NSFetchRequest * fr = [NSFetchRequest fetchRequestWithEntityName:chatHistory];
    NSMutableArray * arr = [NSMutableArray array];
    fr.predicate = [NSPredicate
                    predicateWithFormat:@"user_id == %@ AND service_id == %@",userID,serviceID];
    
    //按照时间戳排序消息
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"addTime" ascending:YES];
    fr.sortDescriptors = @[sort];
    
    NSError * err;
    NSArray * cdArray = [self.context executeFetchRequest:fr error:&err];
    if ( cdArray == nil ) {
        NSLog(@"查询数据失败:%@", err.localizedDescription);
        return arr;
    }
    
    for ( Entity * cdModel in cdArray ) {
        Chat *chat = [[Chat alloc]init];
        chat.user_id = cdModel.user_id;
        chat.user_name = cdModel.user_name;
        chat.content = cdModel.content;
        chat.addTime = cdModel.addTime;
        chat.ID = (NSString *)cdModel.iid;
        chat.send_from = cdModel.send_from;
        chat.service_id = (NSString *)cdModel.service_id;
        chat.service_name = cdModel.service_name;
        [arr addObject:chat];
    }
    return arr;
}
#pragma mark - 列表增删改查
//增
- (void) insertIntoChatList:(Chat *) chatModel
{
    //最后一条的信息
    CDChatList *cdChatListModel = [NSEntityDescription insertNewObjectForEntityForName:@"CDChatList" inManagedObjectContext:self.context];
    cdChatListModel.user_id = chatModel.user_id;
    cdChatListModel.user_name = chatModel.user_name;
    cdChatListModel.last_message = chatModel.content;
    cdChatListModel.last_time = chatModel.addTime;
    //更新未读数量
    [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:[NSString stringWithFormat:@"unreadChatsFor%@",chatModel.user_id]];
    
    NSError * err;
    if ( ![self.context save:&err] ) {
        NSLog(@"插入数据失败:%@", err.localizedDescription);
    }
}
//查列表
- (NSArray*) getAll
{
    NSFetchRequest * fr = [NSFetchRequest fetchRequestWithEntityName:@"CDChatList"];
    NSMutableArray * arr = [NSMutableArray array];
    
    NSError * err;
    NSArray * cdArray = [self.context executeFetchRequest:fr error:&err];
    if ( cdArray == nil ) {
        NSLog(@"查询数据失败:%@", err.localizedDescription);
        return arr;
    }
    
    for ( CDChatList * cdModel in cdArray ) {
        Chat *chat = [[Chat alloc]init];
        chat.user_id = cdModel.user_id;
        chat.user_name = cdModel.user_name;
        chat.content = cdModel.last_message;
        chat.addTime = cdModel.last_time;
        [arr addObject:chat];
    }
    return arr;
}
//查一条
- (BOOL ) dataExist:(NSNumber *)userID {
    NSFetchRequest * fr = [NSFetchRequest fetchRequestWithEntityName:@"CDChatList"];
    fr.predicate = [NSPredicate
                    predicateWithFormat:@"user_id == %@",userID];
    NSError * err;
    NSArray * cdArray = [self.context executeFetchRequest:fr error:&err];
    if ( cdArray == nil || cdArray.count == 0) {
        return NO;
    }
    return YES;
}
//改
-(void)modifyToNewData:(Chat *)chatModel{
    NSManagedObjectContext *context = self.context;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"user_id == %@",chatModel.user_id];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDChatList" inManagedObjectContext:context]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    
    //更新数据
    for (CDChatList *cdChatList in result) {
        cdChatList.user_name = chatModel.user_name;
        cdChatList.last_message = chatModel.content;
        cdChatList.last_time = chatModel.addTime;
    }
    
    //更新未读数量
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
    UINavigationController *navi = tabBar.selectedViewController;
    UIViewController *curVC = navi.topViewController;
    
    if ([curVC isKindOfClass:[ThirdViewController class]]) {
        NSString *key = [NSString stringWithFormat:@"unreadChatsFor%@",chatModel.user_id];
        NSNumber *old = [[NSUserDefaults standardUserDefaults]objectForKey:key];
        NSNumber *new = @(old.integerValue + 1);
        [[NSUserDefaults standardUserDefaults]setObject:new forKey:key];
    }
    
    //保存
    if (![context save:&error]) {
        //更新成功
        NSLog(@"更新数据库失败!");
    }
}

#pragma mark - 单例
+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"chatList"];
            }
        }
    }
    return singleInstance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return singleInstance;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服";
    if (!dataArray){
        dataArray = [[NSMutableArray alloc]init];
    }
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    chatTableView.delegate =self;
    chatTableView.dataSource= self;
}
-(void)backAction{
    [super backAction];
    [socket close];
}
//请求离线时期未读的消息
-(void)requestForIndex {
    NSString *url = [NSString stringWithFormat:@"%@%@",SELLER_URL,CHAT_INDEX_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"service_id":[MyNetTool serviceID]
                          };
    [[MyNetTool managerWithVerify]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"<====聊天首页请求返回数据:====>\n%@\n",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *messages = dict[@"user_list"];
        for (NSDictionary *dict1 in messages) {
            NSNumber *user_id = dict1[@"user_id"];
            Chat *chat = [Chat new];
            chat.user_id = user_id;
            chat.user_name = @"未读消息";
            [self link:chat];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",[error localizedDescription]);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.online = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self SRInit];
    [self refresh];
    self.online = YES;
    [self requestForIndex];
}
-(void)doTimer_signout{
   [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
#pragma mark - 初始化
//列表页初始化
-(void)SRInit{
    NSString *token = [MyNetTool currentToken];
    if (token) {
        if (socket != nil) {
            socket.delegate = nil;
            [socket close];
        }
        NSString *str = [SELLER_URL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        NSString *urlStr = [NSString stringWithFormat:@"ws://%@/websocket",str];
        NSURL *url = [NSURL URLWithString:urlStr];
        SRWebSocket *webSocket = [[SRWebSocket alloc]initWithURL:url];
        socket = webSocket;
        webSocket.delegate = self;
        [webSocket open];
    }
}
//聊天信息页初始化
-(void)link:(Chat *)user {
    NSLog(@"尝试连接到用户:%@",user.user_name);
    //取得自己的service_id
    NSString * service_id = [MyNetTool serviceID];
    NSString *lowerToken = [[MyNetTool currentToken]lowercaseString];
    if (!service_id) {
        NSString *errStr = @"没有service_id";
        [MyObject failedPrompt:errStr];
        return;
    }
    NSDictionary *dict = @{
                           @"type":@"service",//固定
                           @"user_id":[NSString stringWithFormat:@"%@",user.user_id],//对方用户的id
                           @"service_id":service_id,//登录账号时服务器返回的
                           @"token":lowerToken//本地token(转换成小写)
                           };
    //转json,发送信息给服务器
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
    if (socket.readyState == SR_OPEN) {
        [socket send:jsonString];
    }else {
        [MyObject failedPrompt:@"请检查网络连接!"];
    }
}
//标记为已读
-(void)markAsReadForChatID:(NSString *)chatID{
    
    NSString * service_id = [MyNetTool serviceID];
    if (!service_id) {
        NSString *errStr = @"没有service_id";
        [MyObject failedPrompt:errStr];
        return;
    }
    NSDictionary *dict = @{
                           @"type":@"service",//固定
                           @"chatlog_id":chatID//单条聊天信息ID
                           };
    //转json,发送信息给服务器
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
    if (socket.readyState == SR_OPEN) {
        [socket send:jsonString];
    }else {
        [MyObject failedPrompt:@"请检查网络连接!"];
    }
}
#pragma mark - Web Socket代理
//成功开启
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Web Socket开启成功!");
    //取得自己的service_id
    NSString *service_id = [MyNetTool serviceID];
    NSString *lowerToken = [[MyNetTool currentToken]lowercaseString];
    if (!service_id) {
        NSString *errStr = @"没有service_id";
        [MyObject failedPrompt:errStr];
        return;
    }
    NSDictionary *dict = @{
                           @"type":@"service",//固定
                           @"service_id":service_id,//登录账号时服务器返回的
                           @"token":lowerToken//本地token(转换成小写)
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
    if (socket.readyState == SR_OPEN) {
        [socket send:jsonString];
    }else {
        [MyObject failedPrompt:@"请检查网络连接!"];
    }
}
//收到消息
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSString *jsonString = message;
    NSData *json = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:NULL];
    Chat *chat = [Chat chatWithDict:dict];
    if (!chat) {
        [MyObject failedPrompt:@"聊天模型创建失败"];
        return;
    }
    
    //更新列表数据库
    if (![self dataExist:chat.user_id]) {
        //则是新的聊天对象,要插入数据
        [self insertIntoChatList:chat];
    }else {
        //则是已存在的聊天对象,要更新数据
        [self modifyToNewData:chat];
    }
    
    //更新消息记录数据库
    [self insertIntoHistory:chat];
    
    //刷新列表界面
    [self refresh];
    
    //消息的分拣分发
    if ([chat.send_from isEqualToString:@"user"]) {
        //如果是客户发来的信息则标记已读
        if (self.online) {
            [self markAsReadForChatID:chat.ID];
        }
        //刷新消息界面
        if (self.delegate && [self.delegate respondsToSelector:@selector(thirdViewController:didReceivedMessage:)]) {
            [self.delegate thirdViewController:self didReceivedMessage:chat];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(thirdViewController:didReceivedSellerMessage:)]) {
            [self.delegate thirdViewController:self didReceivedSellerMessage:chat];
        }
    }
    
}
//出错
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"出错了!错误信息:%@",[error localizedDescription]);
}
//关闭
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    webSocket.delegate = nil;
    NSLog(@"已断开连接");
}
-(void)send:(id)data{
    if (socket.readyState == SR_OPEN) {
        [socket send:data];
    }else {
        [MyObject failedPrompt:@"请检查网络连接!"];
    }
}
-(void)refresh{
    //更新数组
    NSArray *all = [self getAll];
    //按照未读数量排序
    NSArray *sorted = [self sortByUnread:all];
    dataArray = [sorted copy];
    //无数据情况处理
    if (dataArray == nil||dataArray.count == 0) {
        chatTableView.hidden = YES;
    }else {
        chatTableView.hidden = NO;
        //更新显示
        [chatTableView reloadData];
    }
}
-(NSArray *)sortByUnread:(NSArray *)arr{
    NSMutableArray *arr1 = [arr mutableCopy];
    for (int i=0; i<arr.count; i++) {
        for (int j=i+1; j<arr.count; j++) {
            Chat *left = arr1[i];
            Chat *right = arr1[j];
            if ([self getUnread:left]<[self getUnread:right]) {
                Chat *temp = left;
                arr1[i] = arr1[j];
                arr1[j] = temp;
            }
        }
    }
    return [arr1 copy];
}
-(NSInteger)getUnread:(Chat *)chat{
    NSString *key = [NSString stringWithFormat:@"unreadChatsFor%@",chat.user_id];
    NSNumber *unread = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    return unread.integerValue;
}
#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdlistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdlistCell"];
    if (dataArray.count!=0) {
        Chat *chat = [Chat new];
        chat = [dataArray objectAtIndex: indexPath.row];
        cell.model = chat;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (dataArray.count!=0) {
        Chat *chatModel = dataArray[indexPath.row];
        NSString *key = [NSString stringWithFormat:@"unreadChatsFor%@",chatModel.user_id];
        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:key];
        
        //拿到当前用户信息
        Chat *chatInfo  = [dataArray objectAtIndex:indexPath.row];
        ChatViewController *chat = [[ChatViewController alloc]init];
        chat.chatInfo = chatInfo;
        NSArray *history = [self getHistoryByUserID:chatInfo.user_id serviceID:[MyNetTool serviceID]];
        
        chat.history = history;
        //全部标记已读
        for (Chat *chat in history) {
            [self markAsReadForChatID:chat.ID];
        }
        //推入控制器
        [self.navigationController pushViewController:chat animated:YES];
    }
}

@end
