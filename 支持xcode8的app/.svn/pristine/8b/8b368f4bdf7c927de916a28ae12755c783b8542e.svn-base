//
//  CycleScrollView.h
//  PagedScrollView
//
//

#import <UIKit/UIKit.h>

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

-(void)cycleScrollViewDidEndDecelerating:(CycleScrollView *)scrollView curPage:(NSInteger)curPage;

@end

@interface CycleScrollView : UIView

@property (nonatomic, weak)id<CycleScrollViewDelegate> delegate;
@property (nonatomic , readonly) UIScrollView *scrollView;
@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end