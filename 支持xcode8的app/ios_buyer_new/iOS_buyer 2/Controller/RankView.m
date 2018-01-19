//
//  RankView.m
//  Demo
//
//  Created by 邱炯辉 on 16/5/25.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "RankView.h"

@interface RankView ()
{
    CGRect _frame;
}
@end

@implementation RankView
-(instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    
    if (self) {
        _frame=frame;
        self.userInteractionEnabled = YES;
        self.imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
        
        
        self.imageView.layer.borderWidth=0.3;
        self.imageView.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
        
        self.imageView.layer.cornerRadius=5;
        self.imageView.layer.masksToBounds=YES;
      
        
#if 0
        self.rankLabel=[[UILabel alloc]init];
        self.rankLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_rankLabel];
        
        self.moneyLabel=[[UILabel alloc]init];
        self.moneyLabel.textAlignment=NSTextAlignmentCenter;

        [self addSubview:_moneyLabel];
        

        self.attachmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 90, 5, 80, 40)];
        _attachmentLabel.textAlignment= NSTextAlignmentRight;
        [self addSubview:_attachmentLabel];
#endif      
        int checkWidth=25;
        self.attachmentImg=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - checkWidth)/2, frame.size.height-checkWidth/2, checkWidth, checkWidth)];
//        _attachmentImg.layer.cornerRadius=checkWidth/2;
//        _attachmentImg.layer.borderWidth=0.5;
//        _attachmentImg.layer.borderColor=[UIColor orangeColor].CGColor;
        _attachmentImg.image =[UIImage imageNamed:@"mycheck"];
        _attachmentImg.hidden=YES;
//        _attachmentImg.backgroundColor=[UIColor whiteColor];
        [self addSubview:_attachmentImg];

        
        _tap=[[UITapGestureRecognizer alloc]init];
        
        [self addGestureRecognizer:_tap];
    }
    return  self;
}
-(void)layoutSubviews{
//    NSDictionary *attributes;
//    适配
//    if (ScreenFrame.size.width==320) {
//        _rankLabel.font = [UIFont systemFontOfSize:15];
//        _moneyLabel.font = [UIFont systemFontOfSize:15];
//        _attachmentLabel.font = [UIFont systemFontOfSize:15];
//        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
//
//    }else{
//    
//        //计算等级title的大小
//        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
//    }
//   
//    CGRect titleSize = [_rankLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //等级label
    _rankLabel.frame =CGRectMake(0,CGRectGetMaxY(_imageView.frame)+5,  _frame.size.width, 30);
//    moneylabel
    _moneyLabel.frame =CGRectMake(0, CGRectGetMaxY(_rankLabel.frame), _frame.size.width, 30);
    
}
-(void)setRankStr:(NSString *)rankStr{
    _rankStr =rankStr;
    _rankLabel.text=rankStr;

}
-(void)setMoneyStr:(NSString *)moneyStr{
    _moneyStr = moneyStr;
    _moneyLabel.text=moneyStr;
    
}
-(void)setAttachmentStr:(NSString *)attachmentStr{
    _attachmentStr=attachmentStr;
    _attachmentLabel.text = attachmentStr;
    
}

-(void)removeGesture{
    if (_tap) {
        [self removeGestureRecognizer:_tap];

    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
