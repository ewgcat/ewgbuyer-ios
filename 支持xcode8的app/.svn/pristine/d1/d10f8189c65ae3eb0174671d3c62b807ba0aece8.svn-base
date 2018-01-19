//
//  UseEvaluationCell.m
//  My_App
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UseEvaluationCell.h"

@implementation UseEvaluationCell

-(void)setModel:(ClassifyModel *)model{
    _model=model;
    [_iconImage sd_setImageWithURL:(NSURL*)model.ping_user_photo placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    _nameLabel.text=[NSString stringWithFormat:@"%@",model.ping_user];
    _numberLabel.text=[NSString stringWithFormat:@"%@",model.ping_addTime];
    _evaluationLabel.text=[NSString stringWithFormat:@"%@",model.ping_content];
    _evaluationLabel.numberOfLines = 0;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"UseEvaluationCell";
    UseEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UseEvaluationCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 4;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.borderWidth = 0.5;
    _iconImage.layer.borderColor = [UIColorFromRGB(0Xd7d7d7) CGColor];
    
    UIImageView *imageView = [[UIImageView alloc ] init];
    imageView.frame=CGRectMake(0, 5, 15, 15);
    imageView.image = [UIImage imageNamed:@"time.png"];
    [_berView addSubview:imageView];
    
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0,_berView.bounds.size.width-30 , 25)];
    _numberLabel.textColor=UIColorFromRGB(0X999999);
    _numberLabel.font=[UIFont systemFontOfSize:13];
    [_berView addSubview:_numberLabel];
    
}
+(CGFloat)cellHeightWithModel:(ClassifyModel *)model{
    NSString *text=[NSString stringWithFormat:@"%@",model.ping_content];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGRect requiredCGrect = [text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-80, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat rectHeight=requiredCGrect.size.height;
    CGFloat height=rectHeight>0?(rectHeight+10+25+7):0;
    
    return  height<70?70:height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
