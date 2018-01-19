//
//  MyTSCell.h
//  My_App
//
//  Created by barney on 15/11/26.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
