//
//  WritePayCell.h
//  My_App
//
//  Created by shiyuwudi on 15/12/10.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WritePayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *paytype;
@property (weak, nonatomic) IBOutlet UILabel *shipType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;

@end
