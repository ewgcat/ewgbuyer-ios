//
//  SpecDetailCell.h
//  2016seller_01_09_new
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpecDetailCellDelegate <NSObject>

-(void)getSpecDetailCell;
@end



@interface SpecDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topline;
@property (weak, nonatomic) IBOutlet UILabel *nameLabell;
@property(nonatomic,strong)UITextField *priceTextField;
@property(nonatomic,strong)UITextField *countTextField;

@property(nonatomic,assign)id<SpecDetailCellDelegate>delegate;

@end
