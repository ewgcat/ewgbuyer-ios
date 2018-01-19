//
//  FavoriteGoodsTableViewCell.h
//  
//
//  Created by apple on 15/10/19.
//
//

#import <UIKit/UIKit.h>
#import "Model.h"
@interface FavoriteGoodsTableViewCell : UITableViewCell

@property(nonatomic,strong)Model *model;

@property(nonatomic,strong)UIButton *attractButton;
@property(nonatomic,strong)UIButton *shoppingCartButton;

@end
