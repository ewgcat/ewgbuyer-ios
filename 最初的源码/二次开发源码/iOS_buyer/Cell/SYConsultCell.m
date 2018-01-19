//
//  SYConsultCell.m
//  My_App
//
//  Created by shiyuwudi on 15/11/27.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYConsultCell.h"
#import "ConsultFrameModel.h"
#import "ConsultModel.h"

@interface SYConsultCell ()

@property (nonatomic, weak)UIImageView *goodsImg;
@property (nonatomic, weak)UILabel *goodsNameLabel;
@property (nonatomic, weak)UILabel *goodsPriceLabel;

@property (nonatomic, weak)UILabel *userNameLabel;
@property (nonatomic, weak)UILabel *addTimeLabel;
@property (nonatomic, weak)UIImageView *questionImageView;
@property (nonatomic, weak)UILabel *consultLabel;
@property (nonatomic, weak)UILabel *consultContentLabel;

@property (nonatomic, weak)UILabel *replyNameLabel;
@property (nonatomic, weak)UILabel *replyTimeLabel;
@property (nonatomic, weak)UIImageView *exclamationImageView;
@property (nonatomic, weak)UILabel *replyLabel;
@property (nonatomic, weak)UILabel *replyContentLabel;

@property (nonatomic, weak)UIView *line1;
@property (nonatomic, weak)UIView *line2;

@property (nonatomic, weak)UIView *grayView;

@end

@implementation SYConsultCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)consultCellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"SYConsultCell";
    SYConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SYConsultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
//该方法只调用1次
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置死的内容:字体大小,文字颜色等等,固定的图片设置，固定的label文字
        //控件创建
        UIImageView *goodsImg = [[UIImageView alloc]init];
        UILabel *goodsNameLabel = [[UILabel alloc]init];
        UILabel *goodsPriceLabel = [[UILabel alloc]init];
        UILabel *userNameLabel = [[UILabel alloc]init];
        UILabel *addTimeLabel = [[UILabel alloc]init];
        UIImageView *questionImageView = [[UIImageView alloc]init];
        UILabel *consultLabel = [[UILabel alloc]init];
        UILabel *consultContentLabel = [[UILabel alloc]init];
        UILabel *replyNameLabel = [[UILabel alloc]init];
        UILabel *replyTimeLabel = [[UILabel alloc]init];
        UIImageView *exclamationImageView = [[UIImageView alloc]init];
        UILabel *replyLabel = [[UILabel alloc]init];
        UILabel *replyContentLabel = [[UILabel alloc]init];
        
        UIView *line1 = [[UIView alloc]init];
        UIView *line2 = [[UIView alloc]init];
        UIView *grayView = [[UIView alloc]init];
        //保存成属性
        _goodsImg = goodsImg;
        _goodsNameLabel = goodsNameLabel;
        _goodsPriceLabel = goodsPriceLabel;
        _userNameLabel = userNameLabel;
        _addTimeLabel = addTimeLabel;
        _questionImageView = questionImageView;//不变
        _consultLabel = consultLabel;//不变
        _consultContentLabel = consultContentLabel;
        _replyNameLabel = replyNameLabel;
        _replyTimeLabel = replyTimeLabel;
        _exclamationImageView = exclamationImageView;//不变
        _replyLabel = replyLabel;//不变
        _replyContentLabel = replyContentLabel;
        _line1 = line1;
        _line2 = line2;
        _grayView = grayView;
        //控件添加
        UIView *ancestorView = self.contentView;
        [ancestorView addSubview:_goodsImg];
        [ancestorView addSubview:_goodsNameLabel];
        [ancestorView addSubview:_goodsPriceLabel];
        [ancestorView addSubview:_userNameLabel];
        [ancestorView addSubview:_addTimeLabel];
        [ancestorView addSubview:_questionImageView];
        [ancestorView addSubview:_consultLabel];
        [ancestorView addSubview:_consultContentLabel];
        [ancestorView addSubview:_replyNameLabel];
        [ancestorView addSubview:_replyTimeLabel];
        [ancestorView addSubview:_exclamationImageView];
        [ancestorView addSubview:_replyLabel];
        [ancestorView addSubview:_replyContentLabel];
        [ancestorView addSubview:line1];
        [ancestorView addSubview:line2];
        [ancestorView addSubview:grayView];
        //一次性设置
        _questionImageView.image = [UIImage imageNamed:@"userconsult"];
        _consultLabel.text = @"用户咨询";
        _exclamationImageView.image = [UIImage imageNamed:@"shopreply"];
        _replyLabel.text = @"商家回复";
        _goodsPriceLabel.textColor = UIColorFromRGB(0xf15353);
        _addTimeLabel.textAlignment = NSTextAlignmentRight;
        _replyTimeLabel.textAlignment = NSTextAlignmentRight;
        _consultContentLabel.numberOfLines = 0;
        _replyContentLabel.numberOfLines = 0;
        _addTimeLabel.textColor = UIColorFromRGB(0x7c7c7c);
        _replyTimeLabel.textColor = UIColorFromRGB(0x7c7c7c);
        line1.backgroundColor = UIColorFromRGB(0x7c7c7c);
        line2.backgroundColor = UIColorFromRGB(0x7c7c7c);
        grayView.backgroundColor = BACKGROUNDCOLOR;
        //字体大小
        _addTimeLabel.font = [UIFont systemFontOfSize:13.f];
        _replyTimeLabel.font = [UIFont systemFontOfSize:13.f];
        _replyLabel.font = [UIFont systemFontOfSize:13.f];
        _consultLabel.font = [UIFont systemFontOfSize:13.f];
        _userNameLabel.font = [UIFont systemFontOfSize:13.f];
        _replyNameLabel.font = [UIFont systemFontOfSize:13.f];
        _consultContentLabel.font = [UIFont systemFontOfSize:13.f];
        _replyContentLabel.font = [UIFont systemFontOfSize:13.f];
        _goodsNameLabel.font = [UIFont boldSystemFontOfSize:15.f];
    }
    return self;
}
//该方法调用频率很高
-(void)setFrameModel:(ConsultFrameModel *)frameModel{
    _frameModel = frameModel;
    [self setupData];
    [self setupFrame];
}
-(void)setupData{
    //设置活的内容
    ConsultModel *dataModel = _frameModel.dataModel;
    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FIRST_URL,dataModel.goods_main_photo]];
    [_goodsImg sd_setImageWithURL:imgURL];
    _goodsNameLabel.text = dataModel.goods_name;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataModel.goods_price];
    _userNameLabel.text = [SYObject currentUserName];
    _addTimeLabel.text = dataModel.addTime;
    _consultContentLabel.text = dataModel.content;
    _replyNameLabel.text = dataModel.reply_user;
    _replyTimeLabel.text = dataModel.reply_time;
    _replyContentLabel.text = dataModel.reply_content;
}
-(void)setupFrame{
    _goodsImg.frame = _frameModel.imageF;
    _goodsNameLabel.frame = _frameModel.goodsNameF;
    _goodsPriceLabel.frame = _frameModel.goodsPriceF;
    _userNameLabel.frame = _frameModel.userNameF;
    _addTimeLabel.frame= _frameModel.addTimeF;
    _questionImageView.frame = _frameModel.questionF;
    _consultLabel.frame = _frameModel.consultF;
    _consultContentLabel.frame = _frameModel.consultContentF;
    _replyNameLabel.frame = _frameModel.replyUsernameF;
    _replyTimeLabel.frame = _frameModel.replyAddtimeF;
    _exclamationImageView.frame = _frameModel.exclamationF;
    _replyLabel.frame = _frameModel.replyF;
    _replyContentLabel.frame = _frameModel.replyContentF;
    _line1.frame = _frameModel.line1F;
    _line2.frame = _frameModel.line2F;
    _grayView.frame = _frameModel.grayF;
    
    ConsultModel *dataModel = _frameModel.dataModel;
    if (dataModel.reply_content == nil) {
        _replyNameLabel.hidden = YES;
        _replyTimeLabel.hidden = YES;
        _exclamationImageView.hidden = YES;
        _replyLabel.hidden = YES;
        _replyContentLabel.hidden = YES;
        _line2.hidden = YES;
    }else{
        _replyNameLabel.hidden = NO;
        _replyTimeLabel.hidden = NO;
        _exclamationImageView.hidden = NO;
        _replyLabel.hidden = NO;
        _replyContentLabel.hidden = NO;
        _line2.hidden = NO;
    }
}
@end
