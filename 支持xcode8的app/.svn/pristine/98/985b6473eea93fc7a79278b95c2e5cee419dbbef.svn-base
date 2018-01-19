//
//  FilterConditionsCell.m
//  My_App
//
//  Created by shiyuwudi on 16/3/4.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "FilterConditionsCell.h"

@implementation FilterConditionsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    
    UIColor *color = [UIColor blackColor];
    UIColor *color1 = [UIColor redColor];
    CGFloat wSpace = 10;
    CGFloat hSpace = 10;
    CGFloat w = (self.contentView.width - 40 - 4 * wSpace) / 3;
    NSInteger lineCount = (dict.allKeys.count - 1) / 3 + 1;
    CGFloat h = (self.contentView.height - (lineCount + 1) * hSpace) / lineCount;
    for (int i=0; i<dict.allKeys.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = true;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGFloat x = wSpace + (w + wSpace) * (i % 3);
        CGFloat y = hSpace + (h + hSpace) * (i / 3);
        btn.frame = CGRectMake(x, y, w, h);
        NSString *tit = dict.allKeys[i];
        [btn setTitle:tit forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSString *key = dict.allKeys[i];
        NSString *value = dict[key];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *img1 = [UIImage imageWithData:data scale:2];
        if (value.intValue == 0) {
            [btn setImage:nil forState:UIControlStateNormal];
            btn.layer.borderColor = color.CGColor;
            [btn setTitleColor:color forState:UIControlStateNormal];
        } else {
            [btn setImage:img1 forState:UIControlStateNormal];
            btn.layer.borderColor = color1.CGColor;
            [btn setTitleColor:color1 forState:UIControlStateNormal];
        }
    }
}
-(void)btnClicked:(UIButton *)btn {
    NSString *key = [btn titleForState:UIControlStateNormal];
//    key = [key stringByReplacingOccurrencesOfString:@"√" withString:@""];
    NSString *oldValue = [_dict valueForKey:key];
    NSString *newValue = [oldValue isEqualToString:@"0"] ? @"1" : @"0";
    [_dict setValue:newValue forKey:key];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterButtonClicked:)]) {
        [self.delegate filterButtonClicked:self];
    }
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *reuseID = @"FilterConditionsCell";
    FilterConditionsCell * cell = [[FilterConditionsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
