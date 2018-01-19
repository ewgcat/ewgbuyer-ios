//
//  SYOrderDetailsCell2.m
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell2.h"

@implementation SYOrderDetailsCell2

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

+(instancetype)cell2WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell2";
    SYOrderDetailsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
