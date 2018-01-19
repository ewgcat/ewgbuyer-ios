//
//  ActivityGoodsCollectionViewCell.h
//  My_App
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *salesCount;
-(void)setData:(ClassifyModel *)classify;
@end
