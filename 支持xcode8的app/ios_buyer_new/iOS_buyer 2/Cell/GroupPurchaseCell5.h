//
//  GroupPurchaseCell5.h
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPurcheaseDetailModel.h"
@interface GroupPurchaseCell5 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *conclude;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UILabel *rule;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (weak, nonatomic) IBOutlet UIButton *toBtn;

@property (nonatomic,strong)GroupPurcheaseDetailModel *model;
+(instancetype)cell5WithTableView:(UITableView *)tableView;
@end
