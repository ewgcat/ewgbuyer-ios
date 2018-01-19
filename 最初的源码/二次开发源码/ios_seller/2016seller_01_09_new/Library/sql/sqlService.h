//
//  sqlService.h
//  数据库
//
//  Created by apple on 15-4-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kFilename  @"data.db"
#define chatFilename  @"chatdata.db"

@class sqlTestList;
@interface sqlService : NSObject {
    sqlite3 *_database;
    
}

@property (nonatomic) sqlite3 *_database;
-(BOOL) createTestList:(sqlite3 *)db;//创建数据库
-(BOOL) insertTestList:(sqlTestList *)insertList;//插入数据
-(BOOL) updateTestList:(sqlTestList *)updateList;//更新数据
-(BOOL) updateTestList_unreadcount:(sqlTestList *)updateList;//更新数据
-(NSMutableArray*)getTestList;//获取全部数据
- (BOOL) deleteTestList;//删除数据：
- (NSMutableArray*)searchTestList:(NSString*)searchString;//查询数据库，searchID为要查询数据的ID，返回数据为查询到的数据

-(BOOL) createChatList:(sqlite3 *)db;//创建数据库
-(BOOL) insertChatList:(sqlTestList *)insertList;//插入数据
-(BOOL) updateChatList:(sqlTestList *)updateList;//更新数据
-(NSMutableArray*)getChatList;//获取全部数据
- (BOOL) deleteChatList;//删除数据：
- (NSMutableArray*)searchChatList:(NSString*)searchString;//查询数据库，searchID为要查询数据的ID，返回数据为查询到的数据
@end

@interface sqlTestList : NSObject//重新定义了一个类，专门用于存储数据
{
    int sqlID;//user_id
    NSString *sqlCount;//unread_count
    NSString *sqlname;//user_name
    NSString *sqlImage;//user_img
    NSString *sqlLastContent;
    NSString *sqlLastTime;
    
    //chat
    int chatID;//序列号
    int StoreID;//店铺id
    
}

@property (nonatomic) int sqlID;
@property (nonatomic, retain) NSString *sqlCount;
@property (nonatomic, retain) NSString *sqlname;
@property (nonatomic, retain) NSString *sqlImage;
@property (nonatomic, retain) NSString *sqlLastContent;
@property (nonatomic, retain) NSString *sqlLastTime;

//chat
@property (nonatomic) int chatID;
@property (nonatomic) int StoreID;

@end
