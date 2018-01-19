//
//  LGScrollView.m
//  LGscrollView
//
//  Created by gujianming on 5/28/15.
//  Copyright (c) 2015 jamy. All rights reserved.
//

#import "LGScrollView.h"

// 获得RGB颜色
#define jamyColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface LGScrollView ()
{
    int curPage;
    int totalPage;
    UIScrollView *curScrollView;
    CGRect showFrame;
    NSArray *showImages;
    NSMutableArray *curImages;  // 存放当前滚动的三张图片
    
    UIPageControl *pageCtrl;
    UIView *superView;
    
    NSTimer *timer;
}
@end


@implementation LGScrollView


-(instancetype)initWIthFrame:(CGRect)frameSize showImages:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frameSize]) {
        showFrame = frameSize;
        showImages = [NSArray arrayWithArray:imageArray];
        curImages = [[NSMutableArray alloc] init];
        curPage = 1;
        totalPage = (int)imageArray.count;
        
        curScrollView = [[UIScrollView alloc] initWithFrame:frameSize];
        curScrollView.showsHorizontalScrollIndicator = NO;
        curScrollView.showsVerticalScrollIndicator = NO;
        curScrollView.pagingEnabled = YES;
        curScrollView.delegate = self;
        
        [curScrollView setContentSize:CGSizeMake(curScrollView.frame.size.width, curScrollView.frame.size.height * 3)];
        
          [self addSubview:curScrollView];
        
//        [self addPageCtrl];
//        [self addSubview:pageCtrl];
        [self refreshScrollView];
    }
    return self;
}

- (void)addPageCtrl
{
    UIPageControl *page = [[UIPageControl alloc] init];
    pageCtrl = page;
    pageCtrl.numberOfPages = totalPage;
    CGFloat centerX = showFrame.size.width * 0.5;
    CGFloat centerY = showFrame.size.height - 30;
    pageCtrl.center = CGPointMake(centerX, centerY);
    pageCtrl.bounds = CGRectMake(0, 0, 100, 30);
    pageCtrl.userInteractionEnabled = NO;
    
    // 2.设置圆点的颜色
    pageCtrl.currentPageIndicatorTintColor = jamyColor(253, 98, 42);
    pageCtrl.pageIndicatorTintColor = jamyColor(189, 189, 189);
}

-(void)refreshScrollView
{
    NSArray *subViews = [curScrollView subviews];
    if (subViews.count != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSArray *currentImages = [self getDisplayImagesWithCurPage:curPage];
    
    for (int i=0; i<3; i++) {
        UILabel *newsLabel = currentImages[i];
        newsLabel.frame = CGRectMake(0, -20 + 20*i, 270, 20);
        newsLabel.textColor=UIColorFromRGB(0x5d5d5d);
        [curScrollView addSubview:newsLabel];
    }

    [curScrollView setContentOffset:CGPointMake(0, showFrame.size.height)];
}


- (NSArray *)getDisplayImagesWithCurPage:(int)page
{
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
   
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[showImages objectAtIndex:pre-1]];
    [curImages addObject:[showImages objectAtIndex:curPage-1]];
    [curImages addObject:[showImages objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;     // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return (int)value;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
//    int x = aScrollView.contentOffset.x;
//    
//        // 往下翻一张
//        if(x >= (2*showFrame.size.width))
//        {
//            curPage = [self validPageValue:curPage+1];
//            [self refreshScrollView];
//        }
//        if(x <= 0)
//        {
//            curPage = [self validPageValue:curPage-1];
//            [self refreshScrollView];
//        }
    
        int y = aScrollView.contentOffset.y;
    
            // 往下翻一张
            if(y >= (2*showFrame.size.height))
            {
                curPage = [self validPageValue:curPage+1];
                [self refreshScrollView];
            }
            if(y <= 0)
            {
                curPage = [self validPageValue:curPage-1];
                [self refreshScrollView];
            }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGScrollView:didScrollToIndex:)]) {
        [self.delegate LGScrollView:self didScrollToIndex:curPage];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {

//    [curScrollView setContentOffset:CGPointMake(showFrame.size.width, 0) animated:YES];
    [curScrollView setContentOffset:CGPointMake(0, showFrame.size.height) animated:YES];
    [pageCtrl setCurrentPage:curPage - 1];
}



- (void)start
{
    [self addTimer];
}

- (void)stop
{
    [self killTimer];
}

- (void)addTimer
{
    if(timer == nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)killTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


- (void)autoScroll
{
//    [curScrollView scrollRectToVisible:CGRectMake(showFrame.size.width * 2, 0, showFrame.size.width, showFrame.size.height) animated:YES];
    [curScrollView scrollRectToVisible:CGRectMake(0, showFrame.size.height * 2, showFrame.size.width, showFrame.size.height) animated:YES];
    
    if (curPage == 4) {
        [pageCtrl setCurrentPage:0];
    }
    else
       [pageCtrl setCurrentPage:curPage];
}

@end
