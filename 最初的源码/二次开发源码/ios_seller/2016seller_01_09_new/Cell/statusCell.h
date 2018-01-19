//
//  statusCell.h
//  SellerApp
//
//  Created by barney on 16/1/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusModel.h"
@interface statusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)StatusModel *model;

@end
