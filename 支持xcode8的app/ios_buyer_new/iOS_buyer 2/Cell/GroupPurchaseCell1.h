//
//  GroupPurchaseCell1.h
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPurcheaseDetailModel.h"
@interface GroupPurchaseCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *black;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic,strong)GroupPurcheaseDetailModel *model;

+(instancetype)cell1WithTableView:(UITableView *)tableView;

@end
