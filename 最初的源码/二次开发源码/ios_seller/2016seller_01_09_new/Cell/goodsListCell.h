//
//  goodsListCell.h
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *didSale;
@property (weak, nonatomic) IBOutlet UILabel *kc;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *saleOff;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIButton *del;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (strong, nonatomic)UILabel *saleOffLabel;

@end
