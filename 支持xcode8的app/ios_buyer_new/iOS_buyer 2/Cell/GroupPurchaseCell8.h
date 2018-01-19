//
//  GroupPurchaseCell8.h
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPurcheaseDetailModel.h"
@interface GroupPurchaseCell8 : UITableViewCell
@property (nonatomic,strong)GroupPurcheaseDetailModel *model;
+(instancetype)cell8WithTableView:(UITableView *)tableView;

@end
