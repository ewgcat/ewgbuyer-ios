//
//  GoodsCell.m
//  SellerApp
//
//  Created by apple on 15/5/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsCell.h"
#import "GoodsViewController.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 98)];
    _view.backgroundColor = [UIColor whiteColor];
    [self addSubview:_view];
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 19, 60, 60)];
    
    [_view addSubview:_image];
    _orderid_label=[[UILabel alloc]initWithFrame:CGRectMake(80, 5, ScreenFrame.size.width-90, 45)];
    
    _orderid_label.numberOfLines = 2;
    _orderid_label.textColor=[UIColor blackColor];
    _orderid_label.font=[UIFont systemFontOfSize:17];
    [_view addSubview:_orderid_label];
    _timeadd_label=[[UILabel alloc]initWithFrame:CGRectMake(80, 70, ScreenFrame.size.width-90, 20)];
    
    _timeadd_label.textColor=[UIColor redColor];
    _timeadd_label.font=[UIFont boldSystemFontOfSize:17];
    [_view addSubview:_timeadd_label];
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    imageLine.backgroundColor = LINE_COLOR;
    [_view addSubview:imageLine];
    _selectview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 98)];
    [self addSubview:_selectview];
    _imagek = [[UIImageView alloc]initWithFrame:CGRectMake(20, 78/2, 20, 20)];
    _imagek.backgroundColor = [UIColor whiteColor];
    [_imagek.layer setMasksToBounds:YES];
    [_imagek.layer setCornerRadius:4.0f];
    _imagek.layer.borderWidth = 0.5;
    _imagek.layer.borderColor = [[UIColor grayColor] CGColor];
    [_selectview addSubview:_imagek];
    _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonSelect.frame = CGRectMake(0, 0, 44, 98);
    [_selectview addSubview:_buttonSelect];
    
    _buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonEdit.frame = CGRectMake(ScreenFrame.size.width-80, 54, 60, 30);
    [_buttonEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [self addSubview:_buttonEdit];
    _buttonEdit.layer.borderColor = [[UIColor redColor] CGColor];
    _buttonEdit.layer.borderWidth = 0.5;
    [_buttonEdit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];;
    [_buttonEdit.layer setMasksToBounds:YES];
    [_buttonEdit.layer setCornerRadius:4];
}
-(void)my_cell:(Model *)mm  goodid_Str:(NSString *)goodid_Str{
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",mm.goods_main_photo]] placeholderImage:[UIImage imageNamed:@"loading"]];
    _orderid_label.text=mm.goods_name;
    _timeadd_label.text=[NSString stringWithFormat:@"￥%@",mm.goods_price];
    
    if (goodid_Str.length == 0) {//说明没有元素啊
        _imagek.image = [UIImage imageNamed:@""];
    }else{
        NSMutableArray *arr = (NSMutableArray *)[goodid_Str componentsSeparatedByString:@","];
        if (arr.count == 1) {
            if ([mm.goods_id intValue] == [goodid_Str intValue]) {
                _imagek.image = [UIImage imageNamed:@"yes"];
            }else{
                _imagek.image = [UIImage imageNamed:@""];
            }
        }else{
            BOOL myBool = NO;
            for(int i=0;i<arr.count;i++){
                if ([mm.goods_id intValue] == [[arr objectAtIndex:i] intValue]) {
                    myBool = YES;
                }
            }
            if (myBool == YES) {
                _imagek.image = [UIImage imageNamed:@"yes"];
            }else{
                _imagek.image = [UIImage imageNamed:@""];
            }
        }
    }
    
    GoodsViewController *goods = [GoodsViewController sharedUserDefault];
    if ([goods.button_edit.title isEqualToString:@"完成"]) {
        _view.frame = CGRectMake(44, 0, ScreenFrame.size.width, 98);
    }else{
        _view.frame = CGRectMake(0, 0, ScreenFrame.size.width, 98);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
