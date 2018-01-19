//
//  PreviousRecordCell.h
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviousWinnerRecord.h"

@interface PreviousRecordCell : UITableViewCell

@property (nonatomic, strong)PreviousWinnerRecord *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
+(CGFloat)cellHeight;

@end
