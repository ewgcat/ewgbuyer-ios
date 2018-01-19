//
//  SpecDetailCell.m
//  2016seller_01_09_new
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "SpecDetailCell.h"

@implementation SpecDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *priceView=[LJControl viewFrame:CGRectMake(0,50,ScreenFrame.size.width/3, 50) backgroundColor:[UIColor clearColor]];
    _priceTextField=[LJControl textFieldFrame:CGRectMake(5, 7,ScreenFrame.size.width/3 -10, 30) text:@"" placeText:@"输入价格" setfont:17 textColor:[UIColor lightGrayColor] keyboard:UIKeyboardTypeNumberPad];
    _priceTextField.textAlignment=NSTextAlignmentCenter;
    _priceTextField.backgroundColor=UIColorFromRGB(0Xeeeeee);
    [_priceTextField.layer setMasksToBounds:YES];
    [_priceTextField.layer  setCornerRadius:6.0];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [_priceTextField setInputAccessoryView:topView];
    
    [priceView addSubview:_priceTextField];
    [self.contentView addSubview:priceView];
    
    UIView *countView=[LJControl viewFrame:CGRectMake(ScreenFrame.size.width/3,50,ScreenFrame.size.width/3, 50) backgroundColor:[UIColor clearColor]];
    _countTextField=[LJControl textFieldFrame:CGRectMake(5, 7, ScreenFrame.size.width/3 -10, 30) text:@"" placeText:@"输入库存" setfont:17 textColor:[UIColor lightGrayColor] keyboard:UIKeyboardTypeNumberPad];
    _countTextField.textAlignment=NSTextAlignmentCenter;
    _countTextField.backgroundColor=UIColorFromRGB(0Xeeeeee);
    [_countTextField.layer setMasksToBounds:YES];
    [_countTextField.layer  setCornerRadius:6.0];
    
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
    [topView1 setItems:buttonsArray1];
    [_countTextField setInputAccessoryView:topView1];
    
    [countView addSubview:_countTextField];
    [self.contentView addSubview:countView];
    
    
}
-(void)dismissKeyBoard{
    [self.delegate getSpecDetailCell];
    [UIView animateWithDuration:0.5 animations:^{
        [_priceTextField resignFirstResponder];
        [_countTextField resignFirstResponder];
    }];
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
