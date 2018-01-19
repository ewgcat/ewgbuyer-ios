//
//  ConsultFrameModel.m
//  My_App
//
//  Created by shiyuwudi on 15/11/26.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "ConsultFrameModel.h"
#import "ConsultModel.h"

#define SY_CONSULT_CONTENT_FONT [UIFont systemFontOfSize:13.f]

@interface ConsultFrameModel ()

@end

@implementation ConsultFrameModel

-(void)setDataAndCalcFrame:(ConsultModel *)model{
    _dataModel = model;
    [self calculateFrame];
}
-(void)calculateFrame{
    CGFloat space = 10;
    //总宽度
    CGFloat w = ScreenFrame.size.width;
    //灰色视图
    _grayF = CGRectMake(0, 0, ScreenFrame.size.width, space);
    //产品图片
    CGFloat imgX = space;
    CGFloat imgY = space;
    CGFloat imgW = 64;
    CGFloat imgH = 64;
    _imageF = CGRectMake(imgX, imgY, imgW, imgH);
    //产品名称
    CGFloat gnX = imgX + imgW + space;
    CGFloat gnY = imgY;
    CGFloat gnW = w - gnX -space;
    CGFloat gnH = 0.33 * imgH;
    _goodsNameF = CGRectMake(gnX, gnY, gnW, gnH);
    //产品价钱
    CGFloat pX = gnX;
    CGFloat pY = space + 0.66 * imgH;
    CGFloat pW = gnW;
    CGFloat pH = 0.33 * imgH;
    _goodsPriceF = CGRectMake(pX, pY, pW, pH);
    //line1
    _line1F = CGRectMake(space, pY + pH + space, w - space, 0.5);
    //用户名
    CGFloat unX = space;
    CGFloat unY = CGRectGetMaxY(_imageF) + space;
    CGFloat unW = 0.5 * (w - 3 * space);
    CGFloat unH = pH;
    _userNameF = CGRectMake(unX, unY, unW, unH);
    //添加时间
    CGFloat atX = space * 2 + unW;
    CGFloat atY = unY;
    CGFloat atW = unW;
    CGFloat atH = pH;
    _addTimeF = CGRectMake(atX, atY, atW, atH);
    //问号小图片 16 * 14
    CGFloat qX = space;
    CGFloat qY = CGRectGetMaxY(_userNameF) + space;
    CGFloat qW = 16;
    CGFloat qH = 14;
    _questionF = CGRectMake(qX, qY, qW, qH);
    //用户咨询
    CGFloat zxX = qX + qW + 5;
    CGFloat zxY = qY - 5;
    CGFloat zxW = 100;
    CGFloat zxH = pH;
    _consultF = CGRectMake(zxX, zxY, zxW, zxH);
    zxY += 5;
    //咨询内容,高度可变，一定存在
    CGFloat zcX = space;
    CGFloat zcY = zxY + zxH;
    CGFloat zcW = w - 2 * space;
    CGSize zcSize = CGSizeMake(zcW, CGFLOAT_MAX);
    NSString *zcStr = _dataModel.content;
    NSDictionary *zcDict = @{NSFontAttributeName:SY_CONSULT_CONTENT_FONT};
    CGFloat zcH = [zcStr boundingRectWithSize:zcSize options:NSStringDrawingUsesLineFragmentOrigin attributes:zcDict context:nil].size.height;
    _consultContentF = CGRectMake(zcX, zcY, zcW, zcH);
    //回复控件，高度可变，可能不存在
    if (_dataModel.reply_content) {
        //line2
        _line2F = CGRectMake(space, zcY + zcH + space, w - space, 0.5);
        //回复用户名
        CGFloat rnX = space;
        CGFloat rnY = CGRectGetMaxY(_consultContentF) + space;
        CGFloat rnW = 0.5 * (w - 3 * space);
        CGFloat rnH = pH;
        _replyUsernameF = CGRectMake(rnX, rnY, rnW, rnH);
        //回复添加时间
        CGFloat rtX = space * 2 + rnW;
        CGFloat rtY = rnY;
        CGFloat rtW = rnW;
        CGFloat rtH = pH;
        _replyAddtimeF = CGRectMake(rtX, rtY, rtW, rtH);
        //感叹号小图片 16 * 14
        CGFloat eX = space;
        CGFloat eY = CGRectGetMaxY(_replyAddtimeF) + space;
        CGFloat eW = 16;
        CGFloat eH = 14;
        _exclamationF = CGRectMake(eX, eY, eW, eH);
        //商家回复
        CGFloat rpX = eX + eW + 5;
        CGFloat rpY = eY-5;
        CGFloat rpW = 100;
        CGFloat rpH = pH;
        _replyF = CGRectMake(rpX, rpY, rpW, rpH);
        rpY += 5;
        //回复内容,高度可变
        CGFloat rcX = space;
        CGFloat rcY = rpY + rpH;
        CGFloat rcW = w - 2 * space;
        CGSize rcSize = CGSizeMake(rcW, CGFLOAT_MAX);
        NSString *rcStr = _dataModel.reply_content;
        NSDictionary *rcDict = @{NSFontAttributeName:SY_CONSULT_CONTENT_FONT};
        CGFloat rcH = [rcStr boundingRectWithSize:rcSize options:NSStringDrawingUsesLineFragmentOrigin attributes:rcDict context:nil].size.height;
        _replyContentF = CGRectMake(rcX, rcY, rcW, rcH);
        //计算总高度
        _cellHeight = CGRectGetMaxY(_replyContentF) + space;
    }
    else{
        //计算总高度
        _cellHeight = CGRectGetMaxY(_consultContentF) + space;
    }
}
@end
