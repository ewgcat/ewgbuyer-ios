//
//  ChatFrame.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChatFrame.h"
#import "Chat.h"

@implementation ChatFrame

- (void)setChat:(Chat *)chat{
    
    _chat = chat;
    
    // 0、获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = kMargin;
        CGSize timeSize = [_chat.time sizeWithAttributes:@{NSFontAttributeName:kTimeFont}];
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    }
    //    // 2、计算头像位置
    
    CGFloat iconX = 10;
    //    // 2.1 如果是自己发得，头像在右边
    if (_chat.type == ChatTypeMe) {
        iconX = screenW - kMargin - kIconWH;
    }
    
    CGFloat iconY = CGRectGetMaxY(_timeF) ;
    _iconF = CGRectMake(iconX, iconY+5, 30, 30);;
    
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) ;
    CGFloat contentY = iconY;
    //内容字体
    NSDictionary *attribute = @{NSFontAttributeName:kContentFont};
    CGSize contentSize = [_chat.content boundingRectWithSize:CGSizeMake(kContentW, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if (_chat.type == ChatTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
    
    // 4、计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
}


@end
