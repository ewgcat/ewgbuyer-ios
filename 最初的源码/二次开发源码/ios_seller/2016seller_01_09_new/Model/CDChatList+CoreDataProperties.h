//
//  CDChatList+CoreDataProperties.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/19.
//  Copyright © 2016年 iskyshop. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDChatList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDChatList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *last_message;
@property (nullable, nonatomic, retain) NSString *last_time;
@property (nullable, nonatomic, retain) NSNumber *user_id;
@property (nullable, nonatomic, retain) NSString *user_name;

@end

NS_ASSUME_NONNULL_END
