//
//  ThirdlistCell.h
//  SellerApp
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlService.h"
#import "Chat.h"

@interface ThirdlistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;
-(void)setData:(sqlTestList *)sqlList;
@property (nonatomic, strong)Chat *model;
@end
