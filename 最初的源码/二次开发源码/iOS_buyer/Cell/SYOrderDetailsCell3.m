//
//  SYOrderDetailsCell3.m
//  My_App
//
//  Created by shiyuwudi on 15/12/3.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell3.h"
#import "SYOrderDetailsModel.h"

@interface SYOrderDetailsCell3 ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *mobile;

@end

@implementation SYOrderDetailsCell3

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(SYOrderDetailsModel *)model{
    _model = model;
    
    _userName.text = model.order_username;
    _address.text = model.order_address;
    _mobile.text = model.order_mobile;
}

+(instancetype)cell3WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell3";
    SYOrderDetailsCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
