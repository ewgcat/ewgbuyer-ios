//
//  ReturnRefundNewCell.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/16.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ReturnRefundNewCell.h"

@implementation ReturnRefundNewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)my_cell:(ReturnModel *)mymodel{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 178.5+44*2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [whiteView addSubview:imageLine];
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height-0.5, ScreenFrame.size.width, 0.5)];
    imageLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteView addSubview:imageLine2];
    
    UILabel *orderid_label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenFrame.size.width, 44)];
    orderid_label.text=[NSString stringWithFormat:@"订单号:%@",mymodel.order_id];
    [whiteView addSubview:orderid_label];
    UILabel *time_label=[[UILabel alloc]initWithFrame:CGRectMake(15, 34, ScreenFrame.size.width, 44)];
    time_label.text=[NSString stringWithFormat:@"下单时间:%@",mymodel.addTime];
    time_label.textColor=[UIColor darkGrayColor];
    time_label.font=[UIFont systemFontOfSize:15];
    [whiteView addSubview:time_label];
   
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 88+6+5, 90, 90)];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SELLER_URL,mymodel.goods_mainphoto_path]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [self addSubview:image];
        UILabel *time_labelN=[[UILabel alloc]initWithFrame:CGRectMake(125, 88+5, ScreenFrame.size.width-140, 100)];
        time_labelN.text=[NSString stringWithFormat:@"%@",mymodel.goods_name];
        time_labelN.numberOfLines = 0;
        time_labelN.textColor=[UIColor darkGrayColor];
        time_labelN.font=[UIFont systemFontOfSize:16];
        [self addSubview:time_labelN];
  
    UIImageView *bottomView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 88, ScreenFrame.size.width-15, 0.5)];
    bottomView2.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView2];
    UIImageView *bottomView3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 198, ScreenFrame.size.width-20, 0.5)];
    bottomView3.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView3];
    
    UILabel *money_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 198.5, ScreenFrame.size.width-15, 44)];
    money_label.text=[NSString stringWithFormat:@"买家名: %@",mymodel.user_name];
    money_label.textAlignment = NSTextAlignmentRight;
    [self addSubview:money_label];
    UIImageView *bottomView4 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 198.5+44, ScreenFrame.size.width-15, 0.5)];
    bottomView4.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView4];
    
    if ([mymodel.goods_return_status intValue] == 6||[mymodel.goods_return_status intValue] == 7){
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"确认收货";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
        
    }else if ([mymodel.goods_return_status intValue] == -2){//已过期
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"已过期";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentRight;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        //btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        
        [self addSubview:btnbtn];
        
    }else if ([mymodel.goods_return_status intValue] == 1||[mymodel.goods_return_status intValue] == 5){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"审核通过";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
        
        UILabel *btnPrice=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118-130, 198.5+44+6, 120, 32)];
        btnPrice.text=@"审核拒绝";
        btnPrice.textColor=UIColorFromRGB(0x2196f3);
        btnPrice.textAlignment = NSTextAlignmentCenter;
        [btnPrice.layer setMasksToBounds:YES];
        [btnPrice.layer setCornerRadius:6];
        btnPrice.layer.borderWidth = 1;
        btnPrice.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnPrice];
        
    }else if ([mymodel.goods_return_status intValue] == -1){// 已拒绝
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+5, 100, 34)];
        btnbtn.text=@"已拒绝";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentRight;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
       // btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
    }else if ([mymodel.goods_return_status intValue] == 11){// 已完成
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+5, 100, 34)];
        btnbtn.text=@"已完成";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentRight;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        //btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
    }else if([mymodel.goods_return_status intValue] == 10){
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(15, 198.5+44, ScreenFrame.size.width-30, 44)];
        btnbtn.text=@"等待退款";
        btnbtn.textColor=[UIColor blackColor];
        [self addSubview:btnbtn];
    }else if (!(mymodel.goods_return_status))
    {
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+5, 100, 34)];
        btnbtn.text=@"无操作";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentRight;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        // btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
    
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
