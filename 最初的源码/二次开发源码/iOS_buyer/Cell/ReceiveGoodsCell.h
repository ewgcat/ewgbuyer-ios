//
//  ReceiveGoodsCell.h
//  My_App
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;
@property (weak, nonatomic) IBOutlet UIView *ReceiveGoods_LeftView;
@property (weak, nonatomic) IBOutlet UIView *ReceiveGoods_RightView;
@property (weak, nonatomic) IBOutlet UIImageView *ReceiveGoods_LeftImage;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveGoods_LeftName;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveGoods_LeftPrice;
@property (weak, nonatomic) IBOutlet UIImageView *ReceiveGoods_RightImage;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveGoods_RightName;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveGoods_RightPrice;
-(void)setData:(ClassifyModel *)modelLeft rightData:(ClassifyModel *)modelRight;
@end
