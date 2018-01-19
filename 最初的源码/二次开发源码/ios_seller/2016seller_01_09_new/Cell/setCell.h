//
//  setCell.h
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *InBtn;
@end
