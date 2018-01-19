//
//  FirstIndexxCell.m
//  My_App
//
//  Created by barney on 16/4/28.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "FirstIndexxCell.h"

@interface FirstIndexxCell ()

@property (weak, nonatomic) UIImageView *imageVIew;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIButton *clearBtn;

@property (nonatomic, assign) int idx;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imageLocal;

@end

@implementation FirstIndexxCell
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv = [UIImageView new];
        UILabel *lbl = [UILabel new];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.imageVIew = iv;
        self.nameLabel = lbl;
        self.clearBtn = btn;
        
        [self.clearBtn addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:iv];
        [self addSubview:lbl];
        [self addSubview:btn];
        
        lbl.font = [UIFont systemFontOfSize:12.f];
        lbl.textColor = UIColorFromRGB(0x666666);
        lbl.textAlignment = NSTextAlignmentCenter;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateImage:) name:@"kaifanle" object:nil];
    }
    return self;
}
-(void)updateImage:(NSNotification *)notif{
    
    NSDictionary *userInfo = notif.userInfo;
    //网络请求下来的所有图片的数组，位置idx是在最下面指定的。
    NSArray *fan = userInfo[@"nidefan"];
    if (!fan || fan.count == 0)
    {
        //本地图片
        self.imageVIew.image = [UIImage imageNamed:self.imageLocal];
    } else
    {
        NSString *url = fan[_idx];
        [self.imageVIew sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:self.imageLocal]];
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w1 = 50; CGFloat h1= w1; CGFloat y1 = 10; CGFloat x1 = (self.width - w1) / 2;
    self.imageVIew.frame = CGRectMake(x1, y1, w1, h1);
    CGFloat x2 = 0;CGFloat h2 = 22; CGFloat y2 = (self.height - 10 - h1 - h2) / 2 + w1 + y1; CGFloat w2 = self.width;
    self.nameLabel.frame = CGRectMake(x2, y2, w2, h2);
    self.clearBtn.frame = self.bounds;
}
- (void)touched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(firstIndexxCell:didClickedWithTitle:)]) {
        [self.delegate firstIndexxCell:self didClickedWithTitle:self.title];
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.nameLabel.text = title;
}
+(instancetype)getMyViewWithImageLocal:(NSString *)imageLocal title:(NSString *)title idx:(int)idx{
    FirstIndexxCell *view = [[FirstIndexxCell alloc]init];
    view.imageLocal = imageLocal;
    view.title = title;
    view.idx = idx;
    return view;
}

+(NSArray *)getAllKindsOfButton{
    return @[[self myAttentionView],[self logisticsView],[self cloudPurchaseView],[self brandView],[self ticketView],[self saleView],[self groupPurchaseView],[self couponView],[self freeView]];
}

#pragma mark - 在这里新建按钮，保持队型

+(instancetype)myAttentionView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"1品牌街" title:@"品牌街" idx:0];
}
+(instancetype)logisticsView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"2积分商城" title:@"积分商城" idx:1];
}
+(instancetype)cloudPurchaseView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"3云购" title:@"e云购" idx:2];
}
+(instancetype)brandView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"brandNew" title:@"品牌" idx:2];
}
+(instancetype)ticketView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"4商品购" title:@"团购" idx:3];
}
+(instancetype)saleView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"5优惠券" title:@"免费领券" idx:4];
}
+(instancetype)groupPurchaseView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"6专题促销" title:@"促销" idx:5];
}
+(instancetype)couponView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"7中国馆" title:@"中国馆" idx:6];
}
+(instancetype)freeView{
    return [FirstIndexxCell getMyViewWithImageLocal:@"8全球馆" title:@"全球馆" idx:7];
}

@end
