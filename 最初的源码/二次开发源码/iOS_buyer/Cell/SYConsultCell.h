//
//  SYConsultCell.h
//  My_App
//
//  Created by shiyuwudi on 15/11/27.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConsultFrameModel;

@interface SYConsultCell : UITableViewCell

@property (nonatomic, strong)ConsultFrameModel *frameModel;
+(instancetype)consultCellWithTableView:(UITableView *)tableView;

@end
