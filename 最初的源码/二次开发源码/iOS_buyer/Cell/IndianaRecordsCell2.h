//
//  IndianaRecordsCell2.h
//  My_App
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudCart.h"
#import "CloudPurchaseLottery.h"
#import "CloudPurchaseGoods.h"

@protocol DetailsButtonCLickDelegate <NSObject>

-(void)detailsButtonCLick:(CloudCart *)model;
-(void)addressSelectionButtonCLick:(CloudCart *)model;
-(void)confirmReceiptButtonCLick:(CloudCart *)model;
@end

@interface IndianaRecordsCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;
@property (weak, nonatomic) IBOutlet UILabel *participateLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;
@property (strong, nonatomic) UILabel *functionLabel;

@property(nonatomic,strong)CloudCart *model;

@property(nonatomic,assign)id<DetailsButtonCLickDelegate>delegate;

@end
