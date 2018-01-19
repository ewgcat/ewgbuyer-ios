//
//  addressManagerCell.m
//  My_App
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "addressManagerCell.h"

@interface addressManagerCell ()

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *setDefaultView;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (strong, nonatomic)UISwipeGestureRecognizer * swipeGRLeft;
@property (strong, nonatomic)UISwipeGestureRecognizer * swipeGRRight;

@end

@implementation addressManagerCell
#pragma mark - 初始化
- (void)awakeFromNib {
    [super awakeFromNib];

    //添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setDefaultViewBtnClicked:)];
    [self addGestureRecognizer:tapGR];
    [self setupLeftGesture];
    [self setupRightGesture];
}
#pragma mark - 设置左方向手势
-(void)setupLeftGesture{
    UISwipeGestureRecognizer * swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft:)];
    swipeGR.delegate = self;
    self.swipeGRLeft = swipeGR;
    swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.holderView addGestureRecognizer:swipeGR];
    swipeGR.delegate = self;
}
#pragma mark - 设置右方向手势
-(void)setupRightGesture{
    UISwipeGestureRecognizer * swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight:)];
    swipeGR.delegate = self;
    self.swipeGRRight = swipeGR;
    swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.holderView addGestureRecognizer:swipeGR];
    swipeGR.delegate = self;
}
#pragma mark - 识别手势
-(void)swipedRight:(UISwipeGestureRecognizer *)swipeGR{
    [UIView animateWithDuration:0.5 animations:^{
        self.holderView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
-(void)swipedLeft:(UISwipeGestureRecognizer *)swipeGR{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressManagerCellDidRecognizedLeftGesture:)]) {
        [self.delegate addressManagerCellDidRecognizedLeftGesture:self];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.holderView.transform = CGAffineTransformMakeTranslation(-160, 0);
    }];
}
#pragma mark - 删除动作
- (IBAction)delButtonClicked:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addressManagerCellDeleteBtnClicked:)]) {
        [self.delegate addressManagerCellDeleteBtnClicked:self];
    }
}
#pragma mark - 设为默认地址按钮被点击
-(IBAction)setDefaultViewBtnClicked:(UITapGestureRecognizer*)tapGR{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressManagerCellSetDefaultBtnClicked:)]) {
        [self.delegate addressManagerCellSetDefaultBtnClicked:self];
    }
}
#pragma mark - 设置为默认地址的方法
-(void)setDefault:(BOOL)flag{
    if (flag) {
        self.defaultAddressLabel.hidden = NO;
        self.checkBtn.selected = YES;
        self.locationImageView.hidden=NO;
    }else{
        self.defaultAddressLabel.hidden = YES;
        self.checkBtn.selected = NO;
        self.locationImageView.hidden=YES;

    }
}
#pragma mark - 数据设置方法
-(void)setData:(ClassifyModel *)model{
    _model = model;
    _name.text = [NSString stringWithFormat:@"%@",model.manager_trueName];
    _address.text = [NSString stringWithFormat:@"%@%@",model.manager_area,model.manager_areaInfo];
    if (model.manager_mobile.length == 0) {
        if (model.manager_telephone == 0) {
            _phone.text =[NSString stringWithFormat:@""];
        }else{
            _phone.text =  [NSString stringWithFormat:@"%@",model.manager_telephone];
        }
    }else{
        _phone.text =  [NSString stringWithFormat:@"%@",model.manager_mobile];
    }
    
    //是否隐藏身份证图标
    if(model.card.length>0){
        _validateImageview.hidden=NO;
        _cardNum.hidden=NO;
        _cardNum.text=[NSString stringWithFormat:@"xxxx%@",[model.card substringFromIndex:14]];
        
    }else{
        _validateImageview.hidden=YES;
        _cardNum.hidden=YES;

    
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
