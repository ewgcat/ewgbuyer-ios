//
//  SYOrderDetailsCell1.h
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYOrderDetailsModel;
@class SYOrderDetailsCell1;

@protocol SYOrderDetailsCell1Delegate <NSObject>

-(void)shouldDisplayCancelOrderBarButtonItem:(SYOrderDetailsCell1 *)cell1;

@end

@interface SYOrderDetailsCell1 : UITableViewCell

@property (nonatomic,strong)SYOrderDetailsModel *model;
@property (nonatomic,weak)id<SYOrderDetailsCell1Delegate> delegate;

+(instancetype)cell1WithTableView:(UITableView *)tableView;

@end
