//
//  SYOrderDetailsCell44.h
//  My_App
//
//  Created by shiyuwudi on 15/12/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;
@class SYOrderDetailsCell44;

@protocol SYOrderDetailsCell44Delegate <NSObject>

-(void)shouldReloadTableView:(SYOrderDetailsCell44 *)cell44;
-(void)orderDetailsCell44ActivityButtonClick:(SYOrderDetailsModel *)model;
-(void)tapSYOrderDetailsCell4Click:(SYOrderDetailsModel *)model;

@end

@interface SYOrderDetailsCell44 : UITableViewCell

@property(nonatomic, strong)OrderListModel *model;
@property(nonatomic, weak)UITableView *tableView;

@property (nonatomic, assign, getter=isOpen)BOOL open;
@property (nonatomic, weak)id<SYOrderDetailsCell44Delegate> delegate;

+(instancetype)cell44;
+(CGFloat)cellHeightWithModel:(OrderListModel *)model;
+(void)reset;

@end
