//
//  accessCell.h
//  SellerApp
//
//  Created by barney on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface accessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *index;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (weak, nonatomic) IBOutlet UILabel *yesPeople;

@end
