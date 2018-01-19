//
//  ConsultFrameModel.h
//  My_App
//
//  Created by shiyuwudi on 15/11/26.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConsultModel;

@interface ConsultFrameModel : NSObject

@property (nonatomic,strong,readonly)ConsultModel *dataModel;

@property (nonatomic,assign,readonly)CGRect grayF;
@property (nonatomic,assign,readonly)CGRect imageF;
@property (nonatomic,assign,readonly)CGRect goodsNameF;
@property (nonatomic,assign,readonly)CGRect goodsPriceF;
@property (nonatomic,assign,readonly)CGRect userNameF;
@property (nonatomic,assign,readonly)CGRect addTimeF;
@property (nonatomic,assign,readonly)CGRect questionF;
@property (nonatomic,assign,readonly)CGRect consultF;
@property (nonatomic,assign,readonly)CGRect consultContentF;
@property (nonatomic,assign,readonly)CGRect replyUsernameF;
@property (nonatomic,assign,readonly)CGRect replyAddtimeF;
@property (nonatomic,assign,readonly)CGRect exclamationF;
@property (nonatomic,assign,readonly)CGRect replyF;
@property (nonatomic,assign,readonly)CGRect replyContentF;
@property (nonatomic,assign,readonly)CGRect line1F;
@property (nonatomic,assign,readonly)CGRect line2F;

@property (nonatomic,readonly,assign)CGFloat cellHeight;

-(void)setDataAndCalcFrame:(ConsultModel *)model;

@end
