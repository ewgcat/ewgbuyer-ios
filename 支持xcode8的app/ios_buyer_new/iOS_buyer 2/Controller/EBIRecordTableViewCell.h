//
//  EBIRecordTableViewCell.h
//  My_App
//
//  Created by 邱炯辉 on 16/6/24.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBIRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
