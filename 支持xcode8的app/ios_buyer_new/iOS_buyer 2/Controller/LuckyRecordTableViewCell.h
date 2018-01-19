//
//  LuckyRecordTableViewCell.h
//  LuckyMoney
//
//  Created by 邱炯辉 on 16/7/16.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuckyRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
