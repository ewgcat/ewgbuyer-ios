//
//  FilterConditionsCell.h
//  My_App
//
//  Created by shiyuwudi on 16/3/4.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterConditionsCell;

@protocol FilterConditionsCellDelegate <NSObject>

-(void)filterButtonClicked:(FilterConditionsCell *)cell;

@end

@interface FilterConditionsCell : UITableViewCell

@property (nonatomic, strong)NSMutableDictionary *dict;
@property (nonatomic, weak)id<FilterConditionsCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
