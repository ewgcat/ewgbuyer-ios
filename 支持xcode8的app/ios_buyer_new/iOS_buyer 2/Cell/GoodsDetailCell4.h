//
//  GoodsDetailCell4.h
//  My_App
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailCell4 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *areaSelectionButton;
@property (weak, nonatomic) IBOutlet UILabel *cargoVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;


@property(nonatomic,strong)NSString *areaSelectionString;
@property(nonatomic,strong)UILabel *areaSelectionLabel;





@end
