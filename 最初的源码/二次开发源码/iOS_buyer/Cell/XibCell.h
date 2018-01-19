//
//  XibCell.h
//  My_App
//
//  Created by barney on 15/12/9.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPurcheaseDetailModel.h"

@interface XibCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (nonatomic,strong)GroupPurcheaseDetailModel *model;
+(instancetype)xibcellWithTableView:(UITableView *)tableView;

@end
