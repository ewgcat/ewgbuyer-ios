//
//  IntegralCell.h
//  My_App
//
//  Created by apple on 15-1-13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralCell : UICollectionViewCell
@property (strong,nonatomic)UIImageView *levelImage;
@property (strong,nonatomic)UILabel *IntegralLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntegral;
@property (weak, nonatomic) IBOutlet UILabel *UserLevel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;

-(void)setData:(Model *)shjm;
@end
