//
//  FootprintTableViewCell.h
//  
//
//  Created by apple on 15/10/20.
//
//

#import <UIKit/UIKit.h>
#import "Model.h"
@interface FootprintTableViewCell : UITableViewCell

@property(nonatomic,strong)Model *model;

@property(nonatomic,strong)UIButton *attractButton;
@property(nonatomic,strong)UIButton *shoppingCartButton;

@end
