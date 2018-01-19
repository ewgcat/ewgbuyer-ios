//
//  sqlService.m
//  数据库
//
//  Created by apple on 15-4-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "sqlService.h"


@implementation sqlService

@synthesize _database;

- (id)init
{
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

//获取document目录并返回数据库目录
- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];//这里很神奇，可以定义成任何类型的文件，也可以不定义成.db文件，任何格式都行，定义成.sb文件都行，达到了很好的数据隐秘性
    
}

//创建，打开数据库
- (BOOL)openDB {
    
    //获取数据库路径
    NSString *path = [self dataFilePath];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断数据库是否存在
    BOOL find = [fileManager fileExistsAtPath:path];
    
    //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
    if (find) {
        if(sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
            //如果打开数据库失败则关闭数据库
            sqlite3_close(self._database);
            NSLog(@"Error: open database file.");
            return NO;
        }
        
        //创建一个新表
        [self createTestList:self._database];
        
        return YES;
    }
    //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
    if(sqlite3_open([path UTF8String], &_database) == SQLITE_OK) {
        //创建一个新表
        [self createTestList:self._database];
        return YES;
    } else {
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(self._database);
        NSLog(@"Error: open database file.");
        return NO;
    }
    return NO;
}

//创建表
- (BOOL) createTestList:(sqlite3*)db {
    //这句是大家熟悉的SQL语句
    char *sql = "create table if not exists testTable(user_id varchar(20) PRIMARY KEY , testID int,testValue text,testName text,testImage text,testContent text,testTime text)";
    
    sqlite3_stmt *statement;
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
    
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create test table");
        return NO;
    }
    
    //执行SQL语句
    int success = sqlite3_step(statement);
    //释放sqlite3_stmt
    sqlite3_finalize(statement);
    
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table test");
        return NO;
    }
    return YES;
}

//插入数据
-(BOOL) insertTestList:(sqlTestList *)insertList {
    
    //先判断数据库是否打开
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO testTable(user_id, testValue,testName,testImage,testContent,testTime) VALUES(?, ?, ?,?,?,?)";
        
        int success2 = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to insert:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
        sqlite3_bind_int(statement, 1, insertList.sqlID);
        sqlite3_bind_text(statement, 2, [insertList.sqlCount UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [insertList.sqlname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [insertList.sqlImage UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [insertList.sqlLastContent UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [insertList.sqlLastTime UTF8String], -1, SQLITE_TRANSIENT);
        
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}

//获取数据
- (NSMutableArray*)getTestList{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //判断数据库是否打开
    if ([self openDB]) {
        
        sqlite3_stmt *statement = nil;
        //sql语句
        char *sql = "SELECT user_id, testValue ,testName ,testImage ,testContent,testTime FROM testTable";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement with message:get testValue.");
            return NO;
        }
        else {
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
            while (sqlite3_step(statement) == SQLITE_ROW) {
                sqlTestList* sqlList = [[sqlTestList alloc] init] ;
                sqlList.sqlID    = sqlite3_column_int(statement,0);
                char* strText   = (char*)sqlite3_column_text(statement, 1);
                sqlList.sqlCount = [NSString stringWithUTF8String:strText];
                char *strName = (char*)sqlite3_column_text(statement, 2);
                sqlList.sqlname = [NSString stringWithUTF8String:strName];
                char *strImage = (char*)sqlite3_column_text(statement, 3);
                sqlList.sqlImage = [NSString stringWithUTF8String:strImage];
                char *strContent = (char*)sqlite3_column_text(statement, 4);
                sqlList.sqlLastContent = [NSString stringWithUTF8String:strContent];
                
                char *strTime = (char*)sqlite3_column_text(statement, 5);
                sqlList.sqlLastTime = [NSString stringWithUTF8String:strTime];
                
                [array addObject:sqlList];
                [sqlList release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return [array retain];//定义了自动释放的NSArray，这样不是个好办法，会造成内存泄露，建议大家定义局部的数组，再赋给属性变量。
}

//更新数据
-(BOOL) updateTestList_unreadcount:(sqlTestList *)updateList{
    if ([self openDB]) {
        sqlite3_stmt *statement;//这相当一个容器，放转化OK的sql语句
        //组织SQL语句
        char *sql = "update testTable set testValue = ? WHERE user_id = ?";
        
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        sqlite3_bind_text(statement, 1, [updateList.sqlCount UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, updateList.sqlID);
        
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to update the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }else{
            NSLog(@"unread_success");
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
-(BOOL) updateTestList:(sqlTestList *)updateList{
    if ([self openDB]) {
        sqlite3_stmt *statement;//这相当一个容器，放转化OK的sql语句
        //组织SQL语句
        char *sql = "update testTable set testContent = ? WHERE user_id = ?";
        
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        sqlite3_bind_text(statement, 1, [updateList.sqlLastContent UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, updateList.sqlID);
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        
        char *sql2 = "update testTable set testImage = ? WHERE user_id = ?";
        int success2 = sqlite3_prepare_v2(_database, sql2, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        sqlite3_bind_text(statement, 1, [updateList.sqlImage UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, updateList.sqlID);
        sqlite3_step(statement);
        
        char *sql3 = "update testTable set testValue = ? WHERE user_id = ?";
        int success3 = sqlite3_prepare_v2(_database, sql3, -1, &statement, NULL);
        if (success3 != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        sqlite3_bind_text(statement, 1, [updateList.sqlCount UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, updateList.sqlID);
        sqlite3_step(statement);
        
        char *sql4 = "update testTable set testTime = ? WHERE user_id = ?";
        int success4 = sqlite3_prepare_v2(_database, sql4, -1, &statement, NULL);
        if (success4 != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        sqlite3_bind_text(statement, 1, [updateList.sqlLastTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, updateList.sqlID);
        sqlite3_step(statement);
        
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to update the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }else{
            NSLog(@"success");
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
//删除数据
- (BOOL) deleteTestList{
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        //组织SQL语句
        static char *sql = "delete from testTable";
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to delete:testTable");
            sqlite3_close(_database);
            return NO;
        }
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to delete the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
    
}
//查询数据
- (NSMutableArray*)searchTestList:(NSString*)searchString{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
    //判断数据库是否打开
    if ([self openDB]) {
        sqlite3_stmt *statement = nil;
        //sql语句
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from testTable where user_id like \"%@\"",searchString];
        const char *sql = [querySQL UTF8String];
        //        char *sql = "SELECT * FROM testTable WHERE testName like ?";//这里用like代替=可以执行模糊查找，原来是"SELECT * FROM testTable WHERE testName = ?"
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement with message:search testValue.");
            return NO;
        } else {
            sqlTestList *searchList = [[sqlTestList alloc]init];
            sqlite3_bind_text(statement, 3, [searchString UTF8String], -1, SQLITE_TRANSIENT);
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
            while (sqlite3_step(statement) == SQLITE_ROW) {
                sqlTestList* sqlList = [[sqlTestList alloc] init] ;
                sqlList.sqlID   = sqlite3_column_int(statement,1);
                char* strText   = (char*)sqlite3_column_text(statement, 2);
                sqlList.sqlCount = [NSString stringWithUTF8String:strText];
                char *strName = (char*)sqlite3_column_text(statement, 3);
                sqlList.sqlname = [NSString stringWithUTF8String:strName];
                char *strImage = (char*)sqlite3_column_text(statement, 4);
                sqlList.sqlImage = [NSString stringWithUTF8String:strImage];
                char *strContent = (char*)sqlite3_column_text(statement, 5);
                sqlList.sqlLastContent = [NSString stringWithUTF8String:strContent];
                char *strTime = (char*)sqlite3_column_text(statement, 6);
                sqlList.sqlLastTime = [NSString stringWithUTF8String:strTime];
                [array addObject:sqlList];
                [sqlList release];
            }
            [searchList release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return [array retain];
}

#pragma mark - Chat
- (NSString *)chatdataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:chatFilename];//这里很神奇，可以定义成任何类型的文件，也可以不定义成.db文件，任何格式都行，定义成.sb文件都行，达到了很好的数据隐秘性
    
}
- (BOOL)openChatDB {
    //获取数据库路径
    NSString *path = [self chatdataFilePath];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断数据库是否存在
    BOOL find = [fileManager fileExistsAtPath:path];
    
    //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
    if (find) {
        //打开数据库，这里的[path UTF8String]是将NSString转换为C字符串，因为SQLite3是采用可移植的C(而不是
        //Objective-C)编写的，它不知道什么是NSString.
        if(sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
            //如果打开数据库失败则关闭数据库
            sqlite3_close(self._database);
            NSLog(@"Error: open database file.");
            return NO;
        }
        
        //创建一个新表
        [self createChatList:self._database];
        
        return YES;
    }
    //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
    if(sqlite3_open([path UTF8String], &_database) == SQLITE_OK) {
        
        //创建一个新表
        [self createChatList:self._database];
        return YES;
    } else {
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(self._database);
        NSLog(@"Error: open database file.");
        return NO;
    }
    return NO;
}
- (BOOL) createChatList:(sqlite3*)db{
    char *sql = "create table if not exists chatTable(ID varchar(20) PRIMARY KEY, chatID int,chatUser_id int,chatStore_id int,chatContent text,chatAddtime text)";
    
    sqlite3_stmt *statement;
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
    
    //如果SQL语句解析出错的话程序返回
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create test table");
        return NO;
    }
    
    //执行SQL语句
    int success = sqlite3_step(statement);
    //释放sqlite3_stmt
    sqlite3_finalize(statement);
    
    //执行SQL语句失败
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table test");
        return NO;
    }
    NSLog(@"Create table 'ChatTable' successed.");
    return YES;
    
}
-(BOOL) insertChatList:(sqlTestList *)insertList {
    
    //先判断数据库是否打开
    if ([self openChatDB]) {
        
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO chatTable(ID,chatUser_id,chatStore_id,chatContent,chatAddtime) VALUES(?, ?, ?,?,?)";
        
        int success2 = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to insert:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
        sqlite3_bind_int(statement, 1, insertList.chatID );
        sqlite3_bind_int(statement, 2, insertList.sqlID);
        sqlite3_bind_int(statement, 3, insertList.StoreID);
        sqlite3_bind_text(statement, 4, [insertList.sqlname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [insertList.sqlImage UTF8String], -1, SQLITE_TRANSIENT);
        
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
- (NSMutableArray*)getChatList{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //判断数据库是否打开
    if ([self openChatDB]) {
        sqlite3_stmt *statement = nil;
        //sql语句
        char *sql = "SELECT ID, chatUser_id ,chatStore_id ,chatContent ,chatAddtime FROM chatTable order by chatAddtime asc ";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement with message:get testValue.");
            return NO;
        }
        else {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                sqlTestList* sqlList = [[sqlTestList alloc] init] ;
                sqlList.chatID    = sqlite3_column_int(statement,0);
                sqlList.sqlID    = sqlite3_column_int(statement,1);
                sqlList.StoreID    = sqlite3_column_int(statement,2);
                char* strText   = (char*)sqlite3_column_text(statement, 3);
                sqlList.sqlname = [NSString stringWithUTF8String:strText];
                char *strName = (char*)sqlite3_column_text(statement, 4);
                sqlList.sqlImage = [NSString stringWithUTF8String:strName];
                
                [array addObject:sqlList];
                [sqlList release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return [array retain];//定义了自动释放的NSArray，这样不是个好办法，会造成内存泄露，建议大家定义局部的数组，再赋给属性变量。
}
-(BOOL) updateChatList:(sqlTestList *)updateList{
    
    if ([self openChatDB]) {
        sqlite3_stmt *statement;//这相当一个容器，放转化OK的sql语句
        //组织SQL语句
        char *sql = "update chatTable set chatAddtime = ? and chatContent = ? and chatStore_id = ? and chatUser_id = ? WHERE ID = ?";
        
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        //绑定text类型的数据库数据
        sqlite3_bind_text(statement, 1, [updateList.sqlImage UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [updateList.sqlname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, updateList.StoreID);
        sqlite3_bind_int(statement, 4, updateList.sqlID);
        sqlite3_bind_int(statement, 5, updateList.chatID);
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to update the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
- (BOOL) deleteChatList{
    if ([self openChatDB]) {
        
        sqlite3_stmt *statement;
        //组织SQL语句
        static char *sql = "delete from chatTable";
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to delete:testTable");
            sqlite3_close(_database);
            return NO;
        }
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to delete the database with message.");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
    
}



- (NSMutableArray*)searchChatList:(NSString*)searchString{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //判断数据库是否打开
    if ([self openChatDB]) {
        sqlite3_stmt *statement = nil;
        //sql语句
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from chatTable where chatUser_id like \"%@\" order by chatAddtime asc ",searchString];
        const char *sql = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"出错: failed to prepare statement with message:search testValue.");
            return NO;
        } else {
            sqlTestList *searchList = [[sqlTestList alloc]init];
            //            sqlite3_bind_int(statement, 1, searchID);
            sqlite3_bind_text(statement, 3, [searchString UTF8String], -1, SQLITE_TRANSIENT);
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
            while (sqlite3_step(statement) == SQLITE_ROW) {
                sqlTestList* sqlList = [[sqlTestList alloc] init] ;
                sqlList.chatID   = sqlite3_column_int(statement,0);
                sqlList.chatID = sqlite3_column_int(statement,1);
                sqlList.sqlID   = sqlite3_column_int(statement,2);
                sqlList.StoreID   = sqlite3_column_int(statement,3);
                char* strText   = (char*)sqlite3_column_text(statement, 4);
                sqlList.sqlname = [NSString stringWithUTF8String:strText];
                char *strName = (char*)sqlite3_column_text(statement, 5);
                sqlList.sqlImage = [NSString stringWithUTF8String:strName];
                [array addObject:sqlList];
                [sqlList release];
            }
            [searchList release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return [array retain];
}

@end


@implementation sqlTestList//刚才.h文件里定义的类在这实现

@synthesize sqlID;
@synthesize sqlCount;
@synthesize sqlname;
@synthesize sqlImage,sqlLastTime,sqlLastContent;

//chat
@synthesize chatID;
@synthesize StoreID;

-(id) init
{
    sqlID = 0;
    sqlCount = @"";
    sqlname = @"";
    sqlImage = @"";
    sqlLastContent = @"";
    sqlLastTime  = @"";
    
    //chat
    StoreID = 0;
    chatID = 0;
    
    return self;
};
-(void) dealloc
{
    if ((sqlCount != nil) && (sqlname != nil)&& (sqlImage != nil)&& (sqlLastContent != nil)&& (sqlLastTime != nil)) {
        [sqlCount release];
        [sqlname release];
        [sqlImage release];
        [sqlLastTime release];
        [sqlLastContent release];
    }
    
    [super dealloc];
}

@end
