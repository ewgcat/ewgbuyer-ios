 //
//  ThreeDotView.m
//  My_App
//
//  Created by shiyuwudi on 15/12/21.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "ThreeDotView.h"
#import "MoreButton.h"
#import "FirstViewController.h"
#import "CustomActionSheet.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@interface ThreeDotView ()<CustomActionSheetDelegate,TencentSessionDelegate>

@property (nonatomic, weak)UIView *holder;

@end

@implementation ThreeDotView

static CGFloat bh = 40.f;
static CGFloat w = 120.f;

-(instancetype)initWithButtonCount:(NSInteger)count nc:(UINavigationController *)nc{
    if (self = [super init]) {
        
        //整个背景view
        UIView *holder = [[UIView alloc]init];
        _holder = holder;
        holder.backgroundColor=[UIColor blackColor];
        holder.alpha=0.8;
        [holder.layer setMasksToBounds:YES];
        [holder.layer setCornerRadius:4.0];
       
        self.curCount = 0;
        CGFloat h = 10 + bh * count;
        CGSize size = CGSizeMake(w-5, h);
        _holder.size = size;
        CGFloat x = ScreenFrame.size.width - w;
        CGFloat y = 64;
        _holder.origin = CGPointMake(x, y);
        
        self.nc = nc;
        
        UIImage *img = [UIImage imageNamed:@"square.png"];
        _tri = [[UIImageView alloc]initWithImage:img];
        _tri.alpha = 0.6;

        CGFloat tx = ScreenFrame.size.width - 10 - 14 - 3;
        CGFloat ty = 54;
        CGFloat tw = 14;
        CGFloat th = 10;
        _tri.frame = CGRectMake(tx, ty, tw, th);
        _tri.hidden=YES;
        [nc.view addSubview:_tri];
       
        
        UISwipeGestureRecognizer *swp1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        swp1.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swp1];
        UISwipeGestureRecognizer *swp2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        swp2.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swp2];
        UISwipeGestureRecognizer *swp3=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        swp3.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swp3];
        UISwipeGestureRecognizer *swp4=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        swp4.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swp4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        [self addSubview:holder];
        self.frame = nc.view.bounds;
        [nc.view addSubview:self];
        
        
    }
    return self;
}
-(void)tap{
    self.hidden = YES;
    _tri.hidden=YES;
    
}
-(void)insertMoreBtn:(MoreButton *)moreBtn{
    CGFloat bx = 0;
    CGFloat by =5+ 40 * _curCount;
    CGFloat bw = w;
    moreBtn.frame = CGRectMake(bx, by, bw-5, bh);
    moreBtn.backgroundColor=[UIColor clearColor];
    [_holder addSubview:moreBtn];
    _curCount += 1;
}
-(MoreButton *)homeBtn{
    MoreButton *btn = [MoreButton moreButtonWithTitle:@"首页" imageName:@"tabbar1.png"];
    [btn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(MoreButton *)shareBtn{
    MoreButton *btn = [MoreButton moreButtonWithTitle:@"分享" imageName:@"syShare"];
    [btn addTarget:self action:@selector(goShare:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)goHome:(id)sender{
    [self.nc popToRootViewControllerAnimated:YES];
     FirstViewController *first = [FirstViewController sharedUserDefault];
    first.tabBarController.selectedIndex=0;
    self.hidden = YES;
    _tri.hidden=YES;
    
}
-(void)goShare:(id)sender{
    NSArray *dataArray = self.dataArray;
    if (dataArray.count!=0) {
        CustomActionSheet* sheet = [[CustomActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:[CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_02.png"] title:@"微信联系人"],
                            [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_01.png"] title:@"微信朋友圈"],
                            [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_04.png"] title:@"新浪微博"],
                            [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_05.png"] title:@"QQ好友"],
                            [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_03.png"] title:@"QQ空间"],
                           nil]];
        sheet.delegate=self;
        [sheet showInView:self.vc.navigationController.view];

    }
    self.hidden = YES;
    _tri.hidden=YES;
}
#pragma mark -CustomActionSheetDelegate
-(void)choseAtIndex:(int)index{
    NSArray *dataArray = self.dataArray;
    ClassifyModel *classify = [dataArray objectAtIndex:0];
    if (index==0) {
        //微信好友
        if ([WXApi isWXAppInstalled]) {
            __block shareScene scene;
            scene = shareSceneFriends;
            [SYShopAccessTool sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:classify.detail_goods_photos_small];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您未安装微信客户端" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];

        }
    }else if (index==1) {
        //微信朋友圈
        if ([WXApi isWXAppInstalled]) {
            __block shareScene scene;
            scene = shareSceneTimeline;
            [SYShopAccessTool sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:classify.detail_goods_photos_small];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您未安装微信客户端" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];

        }
    }else if (index==2) {
        //新浪shareSceneWeiBo
        [SYShopAccessTool sharetoWeiboWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
    }else if (index==3) {
        //qq好友
        [self initTence];
         [SYShopAccessTool sharetoQQWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
        
    }else  if (index==4) {
        //qq空间
        [self initTence];
        [SYShopAccessTool sharetoQQTimelineWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
    }
}
-(void)initTence{
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:__TencentDemoAppid_ andDelegate:self];
    
}
#pragma mark -TencentSessionDelegate
-(void)tencentDidNotNetWork{


}
-(void)tencentDidLogin{


}
-(void)tencentDidNotLogin:(BOOL)cancelled{



}
@end
