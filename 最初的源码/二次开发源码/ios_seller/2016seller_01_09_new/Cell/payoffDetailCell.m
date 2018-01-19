//
//  payoffDetailCell.m
//  SellerApp
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "payoffDetailCell.h"
#import "MyOrderViewController.h"

@implementation payoffDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)my_cell:(Model *)mm{
    MyOrderViewController *order = [MyOrderViewController sharedUserDefault];
    UIView *view = [LJControl viewFrame:CGRectMake(0, 20, ScreenFrame.size.width, 0) backgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    UIImageView *imageLine = [LJControl imageViewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:imageLine];
    
    if (order.payoffTag == 0 || order.payoffTag == 1) {
        view.frame = CGRectMake(0, 20, ScreenFrame.size.width, 44*7);
        NSArray *arr = [NSArray arrayWithObjects:@"流水号",@"入账时间",@"描述",@"状态",@"总价格",@"总佣金",@"应结算", nil];
        NSString *status = @"";
        if ([mm.payoff_type intValue] == 0) {
            status = @"未结算";
        }else if ([mm.payoff_type intValue] == 1) {
            status = @"可结算";
        }
        NSArray *arr2 = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",mm.pl_sn],[NSString stringWithFormat:@"%@",mm.addTime],[NSString stringWithFormat:@"%@",mm.pl_info],status,[NSString stringWithFormat:@"%@",mm.order_total_price],[NSString stringWithFormat:@"%@",mm.commission_amount],[NSString stringWithFormat:@"%@",mm.total_amount], nil];
        
        for(int i=0;i<7;i++){
            UILabel *label = [LJControl labelFrame:CGRectMake(15, 0+44*i, ScreenFrame.size.width, 44) setText:@"流水号" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
            label.text = [arr objectAtIndex:i];
            [view addSubview:label];
            UILabel *label2 = [LJControl labelFrame:CGRectMake(110, 0+44*i, ScreenFrame.size.width-120, 44) setText:@"流水号流水号流水号流水号流水号流水号" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
            label2.text = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:i]];
            if (i == 3) {
                label2.textColor = [UIColor redColor];
            }else{
                label2.textColor = [UIColor blackColor];
            }
            [view addSubview:label2];
            UIImageView *imageLine2 = [LJControl imageViewFrame:CGRectMake(15, 43.5+44*i, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:GRAY_COLOR];
            [view addSubview:imageLine2];
        }
    }else if (order.payoffTag == 3){
        NSArray *arr = [NSArray arrayWithObjects:@"流水号",@"入账时间",@"申请时间",@"描述",@"状态",@"总价格",@"总佣金",@"应结算", nil];
        view.frame = CGRectMake(0, 20, ScreenFrame.size.width, 44*8);
        NSArray *arr2 = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",mm.pl_sn],[NSString stringWithFormat:@"%@",mm.addTime],[NSString stringWithFormat:@"%@",mm.apply_time],[NSString stringWithFormat:@"%@",mm.pl_info],@"结算中",[NSString stringWithFormat:@"%@",mm.order_total_price],[NSString stringWithFormat:@"%@",mm.commission_amount],[NSString stringWithFormat:@"%@",mm.total_amount], nil];
        for(int i=0;i<8;i++){
            UILabel *label = [LJControl labelFrame:CGRectMake(15, 0+44*i, ScreenFrame.size.width, 44) setText:@"流水号" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
            label.text = [arr objectAtIndex:i];
            [view addSubview:label];
            UILabel *label2 = [LJControl labelFrame:CGRectMake(110, 0+44*i, ScreenFrame.size.width-120, 44) setText:@"流水号流水号流水号流水号流水号流水号" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
            label2.text = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:i]];
            if (i == 4) {
                label2.textColor = [UIColor redColor];
            }else{
                label2.textColor = [UIColor blackColor];
            }
            [view addSubview:label2];
            UIImageView *imageLine2 = [LJControl imageViewFrame:CGRectMake(15, 43.5+44*i, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:GRAY_COLOR];
            [view addSubview:imageLine2];
        }
    }else{
        NSArray *arr = [NSArray arrayWithObjects:@"流水号",@"入账时间",@"申请时间",@"完成时间",@"描述",@"状态",@"总价格",@"总佣金",@"应结算",@"实际结算",@"结算备注", nil];
        view.frame = CGRectMake(0, 20, ScreenFrame.size.width, 44*11);
        NSArray *arr2 = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",mm.pl_sn],[NSString stringWithFormat:@"%@",mm.addTime],[NSString stringWithFormat:@"%@",mm.apply_time],[NSString stringWithFormat:@"%@",mm.complete_time],[NSString stringWithFormat:@"%@",mm.pl_info],@"已完成",[NSString stringWithFormat:@"%@",mm.order_total_price],[NSString stringWithFormat:@"%@",mm.commission_amount],[NSString stringWithFormat:@"%@",mm.total_amount],[NSString stringWithFormat:@"%@",mm.reality_amount],[NSString stringWithFormat:@"%@",mm.payoff_remark], nil];
        for(int i=0;i<11;i++){
            UILabel *label = [LJControl labelFrame:CGRectMake(15, 0+44*i, ScreenFrame.size.width, 44) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
            label.text = [arr objectAtIndex:i];
            [view addSubview:label];
            UILabel *label2 = [LJControl labelFrame:CGRectMake(110, 0+44*i, ScreenFrame.size.width-120, 44) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
            label2.text = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:i]];
            if (i == 4) {
                label2.textColor = [UIColor redColor];
            }else{
                label2.textColor = [UIColor blackColor];
            }
            [view addSubview:label2];
            UIImageView *imageLine2 = [LJControl imageViewFrame:CGRectMake(15, 43.5+44*i, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:GRAY_COLOR];
            [view addSubview:imageLine2];
        }
    }
    UIImageView *imageLine2 = [LJControl imageViewFrame:CGRectMake(0, view.frame.size.height-0.5, ScreenFrame.size.width, 0.5) setImage:@"" setbackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:imageLine2];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
