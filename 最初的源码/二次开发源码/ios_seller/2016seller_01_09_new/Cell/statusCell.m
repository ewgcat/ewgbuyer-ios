//
//  statusCell.m
//  SellerApp
//
//  Created by barney on 16/1/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "statusCell.h"
#import "UIImageView+WebCache.h"
@implementation statusCell
-(void)setModel:(StatusModel *)model{
    _model=model;
    self.title.text=[NSString stringWithFormat:@"  %@",model.statusName];
    [self.img setImage:[UIImage imageNamed:model.img]];
    
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor clearColor];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
   

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
