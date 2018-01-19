//
//  TreeViewNode.h
//  The Projects
//
//  Created by Ahmed Karim on 1/12/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger class_id;
@property (nonatomic, strong) NSMutableArray *nodeChildren;

@end
