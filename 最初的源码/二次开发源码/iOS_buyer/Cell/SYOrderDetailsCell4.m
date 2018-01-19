//
//  SYOrderDetailsCell4.m
//  My_App
//
//  Created by shiyuwudi on 15/12/4.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell4.h"
#import "SYOrderDetailsModel.h"

@interface SYOrderDetailsCell4 ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *specTitle;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *ftyLabel;

@end

@implementation SYOrderDetailsCell4

- (void)awakeFromNib {
    // Initialization code
    _activityButton.hidden=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self.contentView addGestureRecognizer:tap];
    
    

}

- (void)setModel:(SYOrderDetailsModel *)model{
    _model = model;
    UIImage *placeHolder = [UIImage imageNamed:@"kong_lj.png"];
    NSURL *url = [NSURL URLWithString:model.order_image];
    [_image sd_setImageWithURL:url placeholderImage:placeHolder];
    _goodsName.text = model.order_goods_name;
    if (model.order_specs&&![model.order_specs isEqualToString:@""]) {
//        _spec.hidden = NO;
        _specTitle.hidden = NO;
//        _spec.text = model.order_specs;
        NSRange range1=NSMakeRange(0, model.order_specs.length);
        NSMutableString *mutableStr=[model.order_specs mutableCopy];
        [mutableStr replaceOccurrencesOfString:@"<br>" withString:@" " options:NSCaseInsensitiveSearch range:range1];
        _specTitle.text=[NSString stringWithFormat:@"规格：%@",mutableStr];
    }else{
//        _spec.hidden = YES;
        _specTitle.hidden = YES;
    }
    if ([model.order_qty integerValue]>0) {
        _count.text = [NSString stringWithFormat:@"x%@",model.order_qty];
    }else{
        _count.text = @"";
    }
    if ([model.order_price integerValue]>0) {
        _ftyLabel.hidden=NO;
    }else{
        _ftyLabel.hidden=YES;
    }
    _price.text = [NSString stringWithFormat:@"%.2f",[[SYObject stringByNumber:model.order_price] floatValue]];
    if ([model.order_goods_type isEqualToString:@"normal"]) {
        _activityButton.hidden=YES;
        _saleLabel.hidden=YES;
    }else if ([model.order_goods_type isEqualToString:@"combin"]){
        _saleLabel.hidden=YES;
        _activityButton.hidden=NO;
        [_activityButton setTitle:@"套装详情" forState:UIControlStateNormal];
    }else if ([model.order_goods_type isEqualToString:@"赠品"]){
        _saleLabel.hidden=YES;
        _activityButton.hidden=NO;
        [_activityButton setTitle:@"赠品详情" forState:UIControlStateNormal];
    }else if ([model.order_goods_type isEqualToString:@"advance"]){
        _activityButton.hidden=YES;
        _saleLabel.hidden=NO;
        _saleLabel.text=[NSString stringWithFormat:@"定金：¥%.2f     尾款：¥%.2f",[model.advance_din floatValue],[model.advance_wei floatValue]];
    }else{
        _saleLabel.hidden=YES;
        _activityButton.hidden=YES;
    }
    
}

+(instancetype)cell4WithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cell4";
    SYOrderDetailsCell4 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SYOrderDetailsCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
+(CGFloat)getSYOrderDetailsCell4Higtt:(SYOrderDetailsModel *)model{
    if ([model.order_goods_type isEqualToString:@"normal"]) {
        return 108;
    }else if ([model.order_goods_type isEqualToString:@"combin"]){
        return 148;
    }else if ([model.order_goods_type isEqualToString:@"赠品"]){
         return 148;
    }else if ([model.order_goods_type isEqualToString:@"advance"]){
        return 148;
    }else{
        return 108;
    }
}
- (IBAction)activityButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityButtonClick:)]) {
        [self.delegate activityButtonClick:_model];
    }

}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSYOrderDetailsCell4:)]) {
        [self.delegate tapSYOrderDetailsCell4:_model];
    }

}

@end
