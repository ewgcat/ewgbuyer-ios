//
//  ThirdlistCell.m
//  SellerApp
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThirdlistCell.h"

@implementation ThirdlistCell

-(void)setModel:(Chat *)model{
    _model = model;
    
    [_photoImage setImage:[UIImage imageNamed:@"loading"]];
    [_photoImage.layer setMasksToBounds:YES];
    [_photoImage.layer setCornerRadius:20.0f];
    
    _name.text = model.user_name;
    
    NSDate *now = [NSDate date];
    NSString *timeStr = [NSString stringWithFormat:@"%@",now];
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    NSArray *arr2 = [model.addTime componentsSeparatedByString:@" "];
    if ([[arr objectAtIndex:0] isEqualToString:[arr2 objectAtIndex:0]]) {
        //说明是今天的内容
        NSString *time = [arr2 objectAtIndex:1];
        NSArray *arr3 = [time componentsSeparatedByString:@":"];
        if ([[arr3 objectAtIndex:0] intValue]>=12) {
            _time.text = [NSString stringWithFormat:@"下午%@:%@",[arr3 objectAtIndex:0],[arr3 objectAtIndex:1]];
        }else{
            _time.text = [NSString stringWithFormat:@"上午%@:%@",[arr3 objectAtIndex:0],[arr3 objectAtIndex:1]];
        }
    }else{
        _time.text = [arr2 objectAtIndex:0];
    }
    
    _content.text = model.content;
    
    NSString *key = [NSString stringWithFormat:@"unreadChatsFor%@",model.user_id];
    NSNumber *unread = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (!unread || unread.integerValue == 0) {
        _count.hidden = YES;
    }else if (unread.integerValue >= 100){
        _count.hidden = NO;
        _count.text = @"99+";
    }else {
        _count.hidden = NO;
        _count.text = unread.stringValue;
    }
    [_count.layer setMasksToBounds:YES];
    [_count.layer setCornerRadius:14];
}
-(void)setData:(sqlTestList *)sqlList{
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",sqlList.sqlImage]] placeholderImage:[UIImage imageNamed:@"loading"]];
    [_photoImage.layer setMasksToBounds:YES];
    [_photoImage.layer setCornerRadius:20.0f];
    _name.text = sqlList.sqlname;
    
    NSDate *now = [NSDate date];
    NSString *timeStr = [NSString stringWithFormat:@"%@",now];
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    NSArray *arr2 = [sqlList.sqlLastTime componentsSeparatedByString:@" "];
    if ([[arr objectAtIndex:0] isEqualToString:[arr2 objectAtIndex:0]]) {
        //说明是今天的内容
        NSString *time = [arr2 objectAtIndex:1];
        NSArray *arr3 = [time componentsSeparatedByString:@":"];
        if ([[arr3 objectAtIndex:0] intValue]>=12) {
            _time.text = [NSString stringWithFormat:@"下午%@:%@",[arr3 objectAtIndex:0],[arr3 objectAtIndex:1]];
        }else{
            _time.text = [NSString stringWithFormat:@"上午%@:%@",[arr3 objectAtIndex:0],[arr3 objectAtIndex:1]];
        }
    }else{
        _time.text = [arr2 objectAtIndex:0];
    }
    _content.text = sqlList.sqlLastContent;
    
    _count.text = sqlList.sqlCount;
    if ([sqlList.sqlCount intValue] >=100) {
        _count.text = @"99+";
    }else if ([sqlList.sqlCount intValue] == 0){
        _count.hidden = YES;
    }else{
        _count.hidden =NO;
    }
    [_count.layer setMasksToBounds:YES];
    [_count.layer setCornerRadius:14];
}

@end
