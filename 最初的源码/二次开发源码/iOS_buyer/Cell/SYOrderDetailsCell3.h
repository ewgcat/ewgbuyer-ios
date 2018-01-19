//
//  SYOrderDetailsCell3.h
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYOrderDetailsModel;

@interface SYOrderDetailsCell3 : UITableViewCell

@property (nonatomic,strong)SYOrderDetailsModel *model;
+(instancetype)cell3WithTableView:(UITableView *)tableView;

@end
