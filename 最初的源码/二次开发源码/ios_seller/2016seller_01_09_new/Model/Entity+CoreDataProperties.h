//
//  Entity+CoreDataProperties.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/19.
//  Copyright © 2016年 iskyshop. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addTime;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *iid;
@property (nullable, nonatomic, retain) NSString *send_from;
@property (nullable, nonatomic, retain) NSNumber *service_id;
@property (nullable, nonatomic, retain) NSString *service_name;
@property (nullable, nonatomic, retain) NSNumber *user_id;
@property (nullable, nonatomic, retain) NSString *user_name;

@end

NS_ASSUME_NONNULL_END
