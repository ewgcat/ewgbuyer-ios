//
//  PayofflogCell.m
//  SellerApp
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PayofflogCell.h"

@implementation PayofflogCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)my_cell:(Model *)mm{
    if(mm.order_status.integerValue == 1){
        //可结算单元格特殊样式
        self.model = mm;
        self.backgroundColor = GRAY_COLOR;
        UIView *view =[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 88) backgroundColor:[UIColor whiteColor]];
        [self addSubview:view];
        UIImageView *imageLine = [LJControl imageViewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
        [view addSubview:imageLine];
        UIImageView *imageLineBOTTOM = [LJControl imageViewFrame:CGRectMake(0, view.frame.size.height-0.5, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
        [view addSubview:imageLineBOTTOM];
        CGFloat space = 20;
        UILabel *label = [LJControl labelFrame:CGRectMake(15 + space, 0, ScreenFrame.size.width/2+30, 44) setText:[NSString stringWithFormat:@"流水号:%@",mm.order_num] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
        UILabel *labelTime = [LJControl labelFrame:CGRectMake(15 + space, 44, ScreenFrame.size.width/2+80, 44) setText:@"入账时间" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:labelTime];
        UILabel *labelCate = [LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+30, 44, ScreenFrame.size.width/2-15-30, 44) setText:@"" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
        
        [view addSubview:labelCate];
        UILabel *labelMoney = [LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+30, 0, ScreenFrame.size.width/2-15-30, 44) setText:[NSString stringWithFormat:@"￥ %@",mm.totalPrice] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor redColor] textAlignment:NSTextAlignmentRight];
        [view addSubview:labelMoney];
        if ([mm.invoiceType intValue] == 0) {
            //进账
            labelMoney.textColor = UIColorFromRGB(0x00c800);
        }else if ([mm.invoiceType intValue] == -1){
            //出账
            labelMoney.textColor = [UIColor redColor];
        }
        if ([mm.order_status intValue] == 0) {
            labelTime.text = [NSString stringWithFormat:@"入账时间:%@",mm.addTime];
        }else if ([mm.order_status intValue] == 1){
            labelTime.text = [NSString stringWithFormat:@"入账时间:%@",mm.addTime];
        }else if ([mm.order_status intValue] == 3){
            labelTime.text = [NSString stringWithFormat:@"申请结账时间:%@",mm.addTime];
        }else if ([mm.order_status intValue] == 6){
            labelTime.text = [NSString stringWithFormat:@"结算完成时间:%@",mm.addTime];
        }
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateSelected];
        checkBtn.frame = CGRectMake(0, 0.5 * (view.height - 35), 35, 35);
        [self addSubview:checkBtn];
        _checkBtn = checkBtn;
        
        return;
    }
    self.backgroundColor = GRAY_COLOR;
    UIView *view =[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 88) backgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    UIImageView *imageLine = [LJControl imageViewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:imageLine];
    UIImageView *imageLineBOTTOM = [LJControl imageViewFrame:CGRectMake(0, view.frame.size.height-0.5, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:imageLineBOTTOM];
    UILabel *label = [LJControl labelFrame:CGRectMake(15, 0, ScreenFrame.size.width/2+30, 44) setText:[NSString stringWithFormat:@"流水号:%@",mm.order_num] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    UILabel *labelTime = [LJControl labelFrame:CGRectMake(15, 44, ScreenFrame.size.width/2+80, 44) setText:@"入账时间" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:labelTime];
    UILabel *labelCate = [LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+30, 44, ScreenFrame.size.width/2-15-30, 44) setText:@"" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];

    [view addSubview:labelCate];
    UILabel *labelMoney = [LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2+30, 0, ScreenFrame.size.width/2-15-30, 44) setText:[NSString stringWithFormat:@"￥ %@",mm.totalPrice] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor redColor] textAlignment:NSTextAlignmentRight];
    [view addSubview:labelMoney];
    if ([mm.invoiceType intValue] == 0) {
        //进账
        labelMoney.textColor = UIColorFromRGB(0x00c800);
    }else if ([mm.invoiceType intValue] == -1){
        //出账
        labelMoney.textColor = [UIColor redColor];
    }
    if ([mm.order_status intValue] == 0) {
        labelTime.text = [NSString stringWithFormat:@"入账时间:%@",mm.addTime];
    }else if ([mm.order_status intValue] == 1){
        labelTime.text = [NSString stringWithFormat:@"入账时间:%@",mm.addTime];
    }else if ([mm.order_status intValue] == 3){
        labelTime.text = [NSString stringWithFormat:@"申请结账时间:%@",mm.addTime];
    }else if ([mm.order_status intValue] == 6){
        labelTime.text = [NSString stringWithFormat:@"结算完成时间:%@",mm.addTime];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
