//
//  CloudCartCell.m
//  My_App
//
//  Created by shiyuwudi on 16/2/16.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "CloudCartCell.h"
#import "SYStepper.h"

static CGFloat warnFont = 10.f;
static NSString *warnText = @"参与人次需是10的倍数";

@interface CloudCartCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *attendCount;
@property (weak, nonatomic) SYStepper *stepper;
@property (weak, nonatomic) IBOutlet UIImageView *ten;
@property (weak, nonatomic) UILabel *warnLabel;

@end

@implementation CloudCartCell
-(void)setStepperHidden:(BOOL)hidden{
    self.stepper.hidden = hidden;
}
-(void)setPurchasedNumber{
    [self setStepperHidden:YES];
    self.attendCount.text = [[self.attendCount.text stringByAppendingString:[_model userBuyedQty]]stringByAppendingString:@"人"];
}
+(instancetype)cell{
    CloudCartCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CloudCartCell" owner:nil options:nil]lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)addStepperAndWarning{
    CGFloat h = 25;
    CGFloat w = 100;
    CGFloat y = self.attendCount.center.y - h / 2;
    CGRect stepperFrame = CGRectMake(self.attendCount.right + 8, y + 8, w, h);
    SYStepper *stepper =[[SYStepper alloc]initWithFrame:stepperFrame max:11 min:1 step:1 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:self];
    _stepper = stepper;
    [self.contentView addSubview:stepper];
    
    
    
    UIFont *font = [UIFont systemFontOfSize:warnFont];
    CGSize size = [warnText sizeWithAttributes:@{NSFontAttributeName: font}];
    UILabel *warnLabel = [LJControl labelFrame:CGRectMake(stepper.left, stepper.bottom + 5, size.width, size.height) setText:warnText setTitleFont:warnFont setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft];
    _warnLabel = warnLabel;
    _warnLabel.hidden = true;
    [self.contentView addSubview:warnLabel];
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:stepper attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.attendCount attribute:NSLayoutAttributeTrailing multiplier:1 constant:8];
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:stepper attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.attendCount attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:warnLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:stepper attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:warnLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:stepper attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self.contentView addConstraints:@[c1,c2,c3,c4]];
    
    self.goodsName.numberOfLines = 2;
    self.status.numberOfLines = 2;
}
-(void)setModel:(CloudCart *)model{
    _model = model;
    
    [self addStepperAndWarning];
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.cloudPurchaseLottery.cloudPurchaseGoods.primary_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    
    self.goodsName.text = model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name;
    
    NSString *text = [NSString stringWithFormat:@"总需 %@ 人次，剩余 %@ 人次", [model totalQty], [model balanceQty]];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"剩余 %@",[model balanceQty]]];
    NSRange range1 = NSMakeRange(range.location + 3, range.length - 3);
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc]initWithString:text];
    [statusText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range1];
    self.status.attributedText = statusText;
    
    self.stepper.max = [model balanceQty].integerValue;
    
    BOOL tenHide = model.cloudPurchaseLottery.cloudPurchaseGoods.least_rmb.integerValue == 10 ?  false : true;
    self.ten.hidden = tenHide;
    self.warnLabel.hidden = tenHide;
    
    self.stepper.min = tenHide ? 1 : 10;
    self.stepper.step = self.stepper.min;
    self.stepper.num = [model userBuyedQty].integerValue;

    
}
+(CGFloat)cellHeight{
    return 146.f;
}
@end
