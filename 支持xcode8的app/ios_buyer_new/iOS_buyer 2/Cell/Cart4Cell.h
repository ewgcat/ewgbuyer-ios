//
//  Cart4Cell.h
//  My_App
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cart4Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *shadingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@end
