//
//  TransCell.h
//  My_App
//
//  Created by barney on 15/12/3.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end
