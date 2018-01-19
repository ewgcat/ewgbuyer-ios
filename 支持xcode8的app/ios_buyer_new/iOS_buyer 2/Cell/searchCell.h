//
//  searchCell.h
//  My_App
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
-(void)setData:(NSString *)text;
@end
