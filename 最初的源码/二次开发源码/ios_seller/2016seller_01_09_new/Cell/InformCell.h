//
//  InformCell.h
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *redView;

@end
