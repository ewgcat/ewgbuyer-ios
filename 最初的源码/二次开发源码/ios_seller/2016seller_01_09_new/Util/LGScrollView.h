//
//  LGScrollView.h
//  LGscrollView
//
//  Created by gujianming on 5/28/15.
//  Copyright (c) 2015 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGScrollView;
@protocol LGScrollViewDelegate <NSObject>

@optional

- (void)LGScrollView:(LGScrollView *)LGScrollView didScrollToIndex:(int)index;

@end

@interface LGScrollView : UIView <UIScrollViewDelegate>

/*!
 *  代理方法
 */
@property (nonatomic, assign) id<LGScrollViewDelegate> delegate;

/*!
 *  初始化
 *
 *  @param frameSize  显示的大小
 *  @param imageArray 存放图片的数组
 *
 *  @return 当前对象
 */
-(instancetype)initWIthFrame:(CGRect)frameSize showImages:(NSArray *)imageArray;


/*!
 *   开启定时器，循环滚动
 */
-(void)start;


/*!
 *  停止定时器
 */
- (void)stop;
@end
