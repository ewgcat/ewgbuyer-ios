//
//  OrderlistCell.m
//  SellerApp
//
//  Created by apple on 15/5/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderlistCell.h"

@implementation OrderlistCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)my_cell:(Model *)mymodel{
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
    orderid_label.text=[NSString stringWithFormat:@"订单号:%@",mymodel.order_num];
    [whiteView addSubview:orderid_label];
    UILabel *time_label=[[UILabel alloc]initWithFrame:CGRectMake(15, 34, ScreenFrame.size.width, 44)];
    time_label.text=[NSString stringWithFormat:@"下单时间:%@",mymodel.addTime];
    time_label.textColor=[UIColor darkGrayColor];
    time_label.font=[UIFont systemFontOfSize:15];
    [whiteView addSubview:time_label];
    NSArray *arr = (NSArray *)mymodel.name_list;
    if (arr.count==1) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 88+6+5, 90, 90)];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mymodel.photo_list objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [self addSubview:image];
        UILabel *time_labelN=[[UILabel alloc]initWithFrame:CGRectMake(125, 88+5, ScreenFrame.size.width-140, 100)];
        time_labelN.text=[NSString stringWithFormat:@"%@",[mymodel.name_list objectAtIndex:0]];
        time_labelN.numberOfLines = 0;
        time_labelN.textColor=[UIColor darkGrayColor];
        time_labelN.font=[UIFont systemFontOfSize:16];
        [self addSubview:time_labelN];
    }else{
        UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 98, ScreenFrame.size.width, 110)];
        myScrollView.tag = 102;
        myScrollView.bounces = YES;
        myScrollView.pagingEnabled = YES;
        myScrollView.userInteractionEnabled = YES;
        myScrollView.showsHorizontalScrollIndicator = NO;
        
        
        myScrollView.contentSize=CGSizeMake(mymodel.photo_list.count * 120,110);
        
        
        [self addSubview:myScrollView];
        for(int i=0;i<mymodel.photo_list.count;i++){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+120*i, 0, 100, 100)];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mymodel.photo_list objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"loading"]];
            [myScrollView addSubview:image];
        }
    }
    
    UIImageView *bottomView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 88, ScreenFrame.size.width-15, 0.5)];
    bottomView2.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView2];
    UIImageView *bottomView3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 198, ScreenFrame.size.width-20, 0.5)];
    bottomView3.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView3];
    
    UILabel *money_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 198.5, ScreenFrame.size.width-15, 44)];
    money_label.text=[NSString stringWithFormat:@"共%lu件商品,订单金额:￥%@",(unsigned long)mymodel.photo_list.count,[NSString stringWithFormat:@"%.2f",mymodel.totalPrice.floatValue]];
    money_label.textAlignment = NSTextAlignmentRight;
    [self addSubview:money_label];
    UIImageView *bottomView4 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 198.5+44, ScreenFrame.size.width-15, 0.5)];
    bottomView4.backgroundColor = LINE_COLOR;
    [self addSubview:bottomView4];
    
    if ([mymodel.order_status intValue] == 10){//代付款
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"取消订单";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
        
        
        UILabel *btnPrice=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118-110, 198.5+44+6, 100, 32)];
        btnPrice.text=@"调整价格";
        btnPrice.textColor=UIColorFromRGB(0x2196f3);
        btnPrice.textAlignment = NSTextAlignmentCenter;
        [btnPrice.layer setMasksToBounds:YES];
        [btnPrice.layer setCornerRadius:6];
        btnPrice.layer.borderWidth = 1;
        btnPrice.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];

        [self addSubview:btnPrice];
        
    }else if ([mymodel.order_status intValue] == 20 ||[mymodel.order_status intValue] == 16){//待发货
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"确认发货";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];

        [self addSubview:btnbtn];
        
    }else if ([mymodel.order_status intValue] == 30){// 已发货
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+6, 100, 32)];
        btnbtn.text=@"修改物流";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
        
        UILabel *btnPrice=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118-130, 198.5+44+6, 120, 32)];
        btnPrice.text=@"延长收货时间";
        btnPrice.textColor=UIColorFromRGB(0x2196f3);
        btnPrice.textAlignment = NSTextAlignmentCenter;
        [btnPrice.layer setMasksToBounds:YES];
        [btnPrice.layer setCornerRadius:6];
        btnPrice.layer.borderWidth = 1;
        btnPrice.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnPrice];
        
    }else if ([mymodel.order_status intValue] == 40){// 已确认收货
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+5, 100, 34)];
        btnbtn.text=@"查看订单";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
    }else if ([mymodel.order_status intValue] == 50){// 已完成
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-118, 198.5+44+5, 100, 34)];
        btnbtn.text=@"查看订单";
        btnbtn.textColor=UIColorFromRGB(0x2196f3);
        btnbtn.textAlignment = NSTextAlignmentCenter;
        [btnbtn.layer setMasksToBounds:YES];
        [btnbtn.layer setCornerRadius:6];
        btnbtn.layer.borderWidth = 1;
        btnbtn.layer.borderColor = [UIColorFromRGB(0x2196f3)CGColor];
        [self addSubview:btnbtn];
    }else{
        UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(15, 198.5+44, ScreenFrame.size.width-30, 44)];
        btnbtn.text=@"订单状态:订单已取消";
        btnbtn.textColor=[UIColor blackColor];
        [self addSubview:btnbtn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
