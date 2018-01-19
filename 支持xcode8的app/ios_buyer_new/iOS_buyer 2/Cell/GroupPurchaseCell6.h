//
//  GroupPurchaseCell6.h
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPurcheaseDetailModel.h"
@interface GroupPurchaseCell6 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bottom;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (nonatomic,strong)GroupPurcheaseDetailModel *model;
+(instancetype)cell6WithTableView:(UITableView *)tableView;


@end
