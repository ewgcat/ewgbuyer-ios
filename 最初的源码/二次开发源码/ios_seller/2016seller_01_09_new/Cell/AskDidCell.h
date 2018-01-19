//
//  AskDidCell.h
//  2016seller_01_09_new
//
//  Created by barney on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskDidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *askClass;
@property (weak, nonatomic) IBOutlet UILabel *replyStatus;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *askContent;
@property (weak, nonatomic) IBOutlet UILabel *replyContent;

@end
