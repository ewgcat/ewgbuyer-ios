//
//  ChatCell.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChatCell.h"
#import "Chat.h"
#import "ChatFrame.h"

@interface ChatCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
}

@end

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#pragma - warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
    }
    return self;
}

- (void)setChatFrame:(ChatFrame *)chatFrame{
    
    _chatFrame = chatFrame;
    Chat *chat = _chatFrame.chat;
    
    // 1、设置时间
    [_timeBtn setTitle:chat.addTime forState:UIControlStateNormal];
    
    _timeBtn.frame = _chatFrame.timeF;
    
    // 2、设置头像  chat.icon
    
//    [_iconView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",chat.icon]] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    if ([chatFrame.chat.send_from isEqualToString:@"user"]) {
        //TODO:显示用户头像
        [_iconView setImage:[UIImage imageNamed:@"loading"]];
    }else {
        //TODO:显示自己店铺头像
        [_iconView setImage:[UIImage imageNamed:@"phoneServer"]];
    }
    _iconView.frame = _chatFrame.iconF;
    
    // 3、设置内容
    [_contentBtn setTitle:chat.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _chatFrame.contentF;
    //旧的:chat.type == ChatTypeMe
    if (![chat.send_from isEqualToString:@"user"]) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal , *focused;
    if (![chat.send_from isEqualToString:@"user"]) {
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

@end
