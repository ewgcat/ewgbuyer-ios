//
//  WriteAddressCell.h
//  My_App
//
//  Created by shiyuwudi on 15/12/10.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectAddress;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *nothingView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;

@end
