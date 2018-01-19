//
//  ThreeDotView.h
//  My_App
//
//  Created by shiyuwudi on 15/12/21.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@class MoreButton;

typedef NS_ENUM(NSUInteger, moreType) {
    moreTypeHomepage,//主页
    moreTypeShare,//分享
};

@interface ThreeDotView : UIView{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_parmissions;

}
@property (nonatomic, assign)NSInteger curCount;
@property (nonatomic, weak)UINavigationController *nc;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, weak)UIViewController *vc;
@property (nonatomic, weak)UIButton *bgBtn;
@property (nonatomic, weak)UIView *outView;
@property (nonatomic, retain)UIImageView *tri;

-(instancetype)initWithButtonCount:(NSInteger)count nc:(UINavigationController *)nc;
-(void)insertMoreBtn:(MoreButton *)moreBtn;
-(MoreButton *)homeBtn;
-(MoreButton *)shareBtn;

@end
