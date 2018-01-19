//
//  SYOrderDetailsCell4.h
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYOrderDetailsModel;

@protocol SYOrderDetailsCell4Delegate <NSObject>

-(void)activityButtonClick:(SYOrderDetailsModel *)model;
-(void)tapSYOrderDetailsCell4:(SYOrderDetailsModel *)model;


@end


@interface SYOrderDetailsCell4 : UITableViewCell

@property(nonatomic,assign)id<SYOrderDetailsCell4Delegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (nonatomic,strong)SYOrderDetailsModel *model;

+(instancetype)cell4WithTableView:(UITableView *)tableView;

+(CGFloat)getSYOrderDetailsCell4Higtt:(SYOrderDetailsModel *)model;

@end
