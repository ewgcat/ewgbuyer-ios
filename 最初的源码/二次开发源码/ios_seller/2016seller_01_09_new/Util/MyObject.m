//
//  MyObject.m
//  SellerApp
//
//  Created by shiyuwudi on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyObject.h"
#import <ImageIO/ImageIO.h>

#define IMG_COUNT 30 //自定义图片数量
#define IMG_NAME_PREFIX @"loading"//自定义图片前缀
#define IMG_CHANGE_INTERVAL 0.045//图片更换间隔
#define toCF (__bridge CFTypeRef)//cf桥接
#define COVER_TIMEOUT 30.f//遮罩超时

@interface MyObject ()<UIScrollViewDelegate>

#pragma mark - 组件相关变量
@property (nonatomic,weak)UIButton *currentBtn;
@property (nonatomic,weak)UIScrollView *headNaviView;
@property (nonatomic,weak)UIScrollView *bottomScrollView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)CGFloat w;
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,weak)UIView *orangeBar;
@property (nonatomic,strong)NSArray *btnWArr;
@property (nonatomic,strong)NSArray *btnXArr;
@property (nonatomic,assign)BOOL isFewTitle;
@property (nonatomic,assign)CGFloat ratio;
@property (nonatomic,assign)CGFloat normalFontSize;
@property (nonatomic,assign)CGFloat selectedFontSize;

#pragma mark - 遮罩相关变量
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *bgView1;
@property (weak, nonatomic) IBOutlet UILabel *labelTi;

@property (copy, nonatomic)SYCompletionBlock completion;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic)NSInteger count;
@property (nonatomic, strong)NSArray *imageArray;

@property (nonatomic,copy)NSString *gifName;
@property (nonatomic, copy)NSString *gifPath;
@property (nonatomic, assign)NSInteger gifCount;
@property (nonatomic, strong)NSArray *gifImagesArray;

@end

@implementation MyObject

#pragma mark - 无数据视图
+(void)noDataViewIn:(UIView *)superview{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //图像
    UIImageView *nodataV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    CGFloat w1 = 0.5 * 318.0;
    CGFloat h1 = 0.5 * 278.0;
    CGFloat x1 = 0.5 * (ScreenFrame.size.width - w1);
    CGFloat y1 = 0.5 * (ScreenFrame.size.height - h1);
    nodataV.frame = CGRectMake(x1, y1, w1, h1);
    [superview insertSubview:nodataV atIndex:0];
    //文字
    NSString *title = @"抱歉,暂无数据";
    UILabel *nodataL = [[UILabel alloc]init];
    nodataL.text = title;
    CGFloat space = 44.f;
    CGFloat h = 20.f;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGFloat w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
    CGFloat x = 0.5 * (ScreenFrame.size.width - w);
    CGFloat y = space + nodataV.bottom;
    nodataL.frame = CGRectMake(x, y, w, h);
    nodataL.textColor = UIColorFromRGB(0xb9b9b9);
    nodataL.font = font;
    [superview insertSubview:nodataL atIndex:0];
//    });
}
+(UIView *)noDataViewOffset:(CGFloat)y2{
    UIView *view = [[UIView alloc]initWithFrame:ScreenFrame];
    UIImageView *nodataV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    CGFloat w1 = 0.5 * 318.0;
    CGFloat h1 = 0.5 * 278.0;
    CGFloat x1 = 0.5 * (ScreenFrame.size.width - w1);
    CGFloat y1 = 0.5 * (ScreenFrame.size.height - h1);
    y1 = y1 - y2;
    nodataV.frame = CGRectMake(x1, y1, w1, h1);
    [view addSubview:nodataV];
    //文字
    NSString *title = @"抱歉,暂无数据";
    UILabel *nodataL = [[UILabel alloc]init];
    nodataL.text = title;
    CGFloat space = 44.f;
    CGFloat h = 20.f;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGFloat w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
    CGFloat x = 0.5 * (ScreenFrame.size.width - w);
    CGFloat y = space + nodataV.bottom;
    nodataL.frame = CGRectMake(x, y, w, h);
    nodataL.textColor = UIColorFromRGB(0xb9b9b9);
    nodataL.font = font;
    [view addSubview:nodataL];
    
    return view;
}
+(UIView *)noDataView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenFrame];
    UIImageView *nodataV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    CGFloat w1 = 0.5 * 318.0;
    CGFloat h1 = 0.5 * 278.0;
    CGFloat x1 = 0.5 * (ScreenFrame.size.width - w1);
    CGFloat y1 = 0.5 * (ScreenFrame.size.height - h1);
    nodataV.frame = CGRectMake(x1, y1, w1, h1);
    [view addSubview:nodataV];
    //文字
    NSString *title = @"抱歉,暂无数据";
    UILabel *nodataL = [[UILabel alloc]init];
    nodataL.text = title;
    CGFloat space = 44.f;
    CGFloat h = 20.f;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGFloat w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
    CGFloat x = 0.5 * (ScreenFrame.size.width - w);
    CGFloat y = space + nodataV.bottom;
    nodataL.frame = CGRectMake(x, y, w, h);
    nodataL.textColor = UIColorFromRGB(0xb9b9b9);
    nodataL.font = font;
    [view addSubview:nodataL];
    
    return view;
}
+(UIView *)noDataViewForTableView:(UITableView *)tableView{
    UIView *view = [[UIView alloc]initWithFrame:tableView.frame];
    UIImageView *nodataV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    CGFloat w1 = 0.5 * 318.0;
    CGFloat h1 = 0.5 * 278.0;
    CGFloat x1 = 0.5 * (ScreenFrame.size.width - w1);
    CGFloat y1 = 0.5 * (tableView.height - h1-70);
    nodataV.frame = CGRectMake(x1, y1, w1, h1);
    [view addSubview:nodataV];
    //文字
    NSString *title = @"抱歉,暂无数据";
    UILabel *nodataL = [[UILabel alloc]init];
    nodataL.text = title;
    CGFloat space = 44.f;
    CGFloat h = 20.f;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGFloat w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
    CGFloat x = 0.5 * (ScreenFrame.size.width - w);
    CGFloat y = space + nodataV.bottom;
    nodataL.frame = CGRectMake(x, y, w, h);
    nodataL.textColor = UIColorFromRGB(0xb9b9b9);
    nodataL.font = font;
    [view addSubview:nodataL];
    
    return view;
}

#pragma mark - 自动创建顶部标签页,和配套的底部表视图
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView{
    [self sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:containerView headerHeight:44.f topMargin:0.f testColor:NO normalFontSize:15.f selectedFontSize:15.f];
}
-(void)sy_setSelectColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateSelected];
    }
}
-(void)sy_setNormalColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
-(void)sy_setScrollIndicatorColor:(UIColor *)color{
    _orangeBar.backgroundColor = color;
}
-(void)setFirstTableViewAs:(UITableView *)firstTableView{
    CGRect frame;
    //删除第一个tableView
    for (UIView *view in _bottomScrollView.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            frame = view.frame;
            [view removeFromSuperview];
            [_tableViewArray removeObjectAtIndex:0];
            break;
        }
    }
    //再添加
    firstTableView.frame = frame;
    [_bottomScrollView addSubview:firstTableView];
    [_tableViewArray insertObject:firstTableView atIndex:0];
}
-(void)setSecondTableViewAs:(UITableView *)secondTableView{
    CGRect frame;
    int num = 0;
    //删除第二个tableView
    for (int i=0;i<_bottomScrollView.subviews.count;i++){
        UIView *view = _bottomScrollView.subviews[i];
        if ([view isKindOfClass:[UITableView class]] ) {
            num ++;
            if (num == 2) {
                frame = view.frame;
                [view removeFromSuperview];
                [_tableViewArray removeObjectAtIndex:1];
                break;
            }
        }
    }
    //再添加
    secondTableView.frame = frame;
    [_bottomScrollView addSubview:secondTableView];
    [_tableViewArray insertObject:secondTableView atIndex:1];
}
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView headerHeight:(CGFloat)headerHeight topMargin:(CGFloat)topMargin testColor:(BOOL)testColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize{
    _curIndex = 0;
    _normalFontSize = normalFontSize;
    _selectedFontSize = selectedFontSize;
    _titleArr = titleArr;
    CGRect frame = containerView.frame;
    CGFloat w = frame.size.width;
    _w = w;
    CGFloat h = frame.size.height;
    //控件创建，设置frame
    UIScrollView *headNaviView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, w, headerHeight)];
    UIScrollView *bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+topMargin, w, h - headerHeight)];
    _bottomScrollView = bottomScrollView;
    
    _headNaviView = headNaviView;
    headNaviView.showsHorizontalScrollIndicator = NO;
    headNaviView.showsVerticalScrollIndicator = NO;
    
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.contentSize = CGSizeMake(w * titleArr.count, h - headerHeight);
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.delegate = self;
    
    NSMutableArray *btnArr = [NSMutableArray array];
    CGFloat headScrollViewW = 0;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:selectedFontSize]};
    NSMutableArray *btnWArr = [NSMutableArray array];
    NSMutableArray *btnXArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++) {
        //计算按钮宽度
        NSString *btnTitle = titleArr[i];
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, headerHeight);
        CGFloat btnW = [btnTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        btnW = btnW + 20;
        [btnWArr addObject:@(btnW)];
        if (i==titleArr.count-1) {
            //多加一个元素防止数组越界崩溃......
            [btnWArr addObject:@(btnW)];
        }
        [btnXArr addObject:@(headScrollViewW)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            btn.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        
        [btn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromRGB(0x373737) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
        [btnArr addObject:btn];
        _btnArr = btnArr;
        CGRect btnFrame = CGRectMake(headScrollViewW, 0, btnW, headerHeight);
        btn.frame = btnFrame;
        [headNaviView addSubview:btn];
        [btn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            _currentBtn = btn;
            btn.titleLabel.font = [UIFont systemFontOfSize:selectedFontSize];
        }
        headScrollViewW += btnW;
    }
    //按钮数量很少的情况
    if (headScrollViewW<_w) {
        _isFewTitle = YES;
        //只能在这里重新布局按钮
        CGFloat bX = 0;
        for (UIButton *btn in _btnArr) {
            //等比例放大宽度即可
            CGFloat ratio = _w / headScrollViewW;
            _ratio = ratio;
            CGRect fr = btn.frame;
            fr.size.width *= ratio;
            fr.origin.x = bX;
            btn.frame = fr;
            bX += fr.size.width;
        }
        headScrollViewW = w;
    }
    headNaviView.contentSize = CGSizeMake(headScrollViewW,0);
    headNaviView.backgroundColor=[UIColor whiteColor];
    _btnWArr = btnWArr;
    _btnXArr = btnXArr;
    //创建tableView
    NSMutableArray *tableViewArr = [NSMutableArray array];
    _tableViewArray = tableViewArr;
    for (int i = 0; i < titleArr.count; i ++) {
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(i * w, 0, w, h - headerHeight -44) style:UITableViewStylePlain];
        [tableViewArr addObject:tv];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            tv.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [bottomScrollView addSubview:tv];
    }
    
    UIView *orangeBar = [[UIView alloc]init];
    orangeBar.backgroundColor = UIColorFromRGB(0x2196f3);
    _orangeBar = orangeBar;
    UIButton *btn0 = btnArr[0];
    CGFloat btn0H = btn0.frame.size.height;
    CGFloat btn0W = btn0.frame.size.width;
    orangeBar.frame = CGRectMake(0, 0.95*btn0H, btn0W, 0.05*btn0H);
    
    //添加到父视图
    [headNaviView addSubview:orangeBar];
    [containerView addSubview:headNaviView];
    [containerView addSubview:bottomScrollView];
    
}
-(IBAction)naviBtnClicked:(id)sender{
    _currentBtn.selected = NO;
    _currentBtn = sender;
    _currentBtn.selected = YES;
    
    NSInteger index = [_btnArr indexOfObject:sender];
    _curIndex = index;
    CGPoint p = CGPointMake(_w * index, 0);
    [_bottomScrollView  setContentOffset:p animated:YES];
    
    UIButton *btn = sender;
    //当前按钮居中
    CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
    CGFloat offX = centerX - _w * 0.5;
    [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    //如果滚多了.....那就滚回去！
    if (offX<=0) {
        offX = 0;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }
    if (offX+_w>=_headNaviView.contentSize.width) {
        offX = _headNaviView.contentSize.width - _w;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomTableDidEndDecelating:)]) {
        [self.delegate bottomTableDidEndDecelating:self];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        if (_isFewTitle) {
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 =btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            //如果按钮较少,按比例放大指示条
            frame.origin.x *= _ratio;
            frame.size.width *= _ratio;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }else{
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 = btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x / _w;
        UIButton *btn = [_btnArr objectAtIndex:index];
        [self naviBtnClicked:btn];
        //当前按钮居中
        CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
        CGFloat offX = centerX - _w * 0.5;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        //如果滚多了.....那就滚回去！
        if (offX<=0) {
            offX = 0;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
        if (offX+_w>=_headNaviView.contentSize.width) {
            offX = _headNaviView.contentSize.width - _w;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
        
    }
}


#pragma mark - 遮罩
//初始化设置
-(void)awakeFromNib{
    self.count = -1;
    self.labelTi.layer.cornerRadius = self.labelTi.bounds.size.height * 0.5;
    [self.labelTi.layer setMasksToBounds:YES];
    self.labelTi.hidden = YES;
    self.bgView1.hidden = YES;
}
//gif路径和数量懒加载
-(NSString *)gifPath{
    if (!_gifPath&&_gifName) {
        _gifPath = [[NSBundle mainBundle]pathForResource:self.gifName ofType:@"gif"];
    }
    return _gifPath;
}
-(NSInteger)gifCount{
    if (_gifCount==0) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:self.gifName withExtension:@"gif"];
        CGImageSourceRef source = CGImageSourceCreateWithURL(toCF url, NULL);
        size_t const count = CGImageSourceGetCount(source);
        CFRelease(source);
        _gifCount = count;
    }
    return _gifCount;
}
//主要方法
+(void)reset{
    [self setGif:nil];
}
+(void)setGif:(NSString *)gifName{
    //清空懒加载数据
    [self sharedView].gifCount = 0;
    [self sharedView].gifPath = nil;
    [self sharedView].gifImagesArray = nil;
    //重置计数器
    [self sharedView].count = -1;
    //赋值
    [self sharedView].gifName = gifName;
}
-(NSArray *)imagesSplitFromGIF{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSURL *url = [[NSBundle mainBundle]URLForResource:self.gifName withExtension:@"gif"];
    //此处CF类型的url用的是桥接，所以不用释放
    CGImageSourceRef source = CGImageSourceCreateWithURL(toCF url, NULL);
    size_t const count = CGImageSourceGetCount(source);
    for (size_t i = 0; i < count; i++) {
        CGImageRef cfImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *uiImage = [UIImage imageWithCGImage:cfImage];
        [tempArr addObject:uiImage];
        //释放图片(不然内存暴涨!!别问我怎么知道的...)
        CFRelease(cfImage);
    }
    //释放图片源
    CFRelease(source);
    return tempArr;
}
+(void)failedPrompt:(NSString *)title{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self failedPromptInSuperView:root.view title:title];
}
+(void)failedPrompt1:(NSString *)title{
    UIWindow *root = [UIApplication sharedApplication].keyWindow;
    [self failedPromptInSuperView:root title:title];
}
+(void)failedPrompt:(NSString *)title complete:(SYCompletionBlock)completion{
    [self sharedView1].completion = completion;
    [MyObject failedPrompt:title];
}
+(void)failedPromptInSuperView:(UIView *)superView title:(NSString *)title{
    if (!title||[title isEqualToString:@""]) {
        return;
    }
    NSString *fatStr = [NSString stringWithFormat:@" %@  ",title];
    [self sharedView1].labelTi.text = fatStr;
    [self sharedView1].frame = superView.bounds;
    [superView addSubview:[self sharedView1]];
    [[self sharedView1]showMessage];
}
-(void)hideKeyboard{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.view endEditing:YES];
}
-(void)showMessage{
    [self hideKeyboard];
    self.labelTi.hidden = NO;
    self.labelTi.alpha = 1;
    [self hideMessage];
}
-(void)hideMessage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.labelTi.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.completion) {
                self.completion();
            }
        }];
    });
}
+(void)startLoading{
    [self sharedView].contentView.hidden = NO;
    [self sharedView].bgView.hidden = NO;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self startLoadingInSuperview:root.view];
}
+(void)endLoading{
    if ([self sharedView].timer.isValid) {
        [[self sharedView].timer invalidate];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedView] removeFromSuperview];
    });
}
+(void)startLoadingWithTitle:(NSString *)title{
    [self sharedView].statusLabel.text = title;
    [self startLoading];
}
+(void)startLoadingInSuperview:(UIView *)superview{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sharedView].frame = superview.bounds;
        [superview addSubview:[self sharedView]];
        [[self sharedView]startAnimating];
    });
}
-(void)startAnimating{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:IMG_CHANGE_INTERVAL target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [timer fire];
    [self performSelector:@selector(checkTimeout) withObject:nil afterDelay:COVER_TIMEOUT];
}
-(void)checkTimeout{
    if (self.timer.isValid) {
        [self.timer invalidate];
        [self removeFromSuperview];
    }
}
-(void)switchImage{
    UIImage *newImage = [self getNextImage];
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self.imageView setImage:newImage];
    });
}
-(UIImage *)getNextImage{
    NSInteger newCount = self.count + 1;
    NSInteger overCount;
    if (self.gifPath) {
        //gif
        overCount = self.gifCount;
    }else {
        //自定义多张图片
        overCount = IMG_COUNT;
    }
    
    if (newCount == overCount) {
        newCount = 0;
    }
    UIImage *newImg;
    if (self.gifPath) {
        //gif
        newImg = self.gifImagesArray[newCount];
    }else{
        //自定义多张图片
        newImg = self.imageArray[newCount];
    }
    self.count = newCount;
    return newImg;
}
//从xib加载单例视图
+(MyObject *)sharedView
{
    static MyObject *sharedView = nil;
    if(sharedView==nil){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"ProgressView" bundle:bundle];
        NSArray *nibViews = [nib instantiateWithOwner:self options:0];
        sharedView = nibViews[0];
        sharedView.loadingView.layer.cornerRadius = 9.f;
        sharedView.loadingView.layer.masksToBounds = YES;
    }
    return sharedView;
}
+(MyObject *)sharedView1
{
    static MyObject *sharedView1 = nil;
    if(sharedView1==nil){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"ProgressView1" bundle:bundle];
        NSArray *nibViews = [nib instantiateWithOwner:self options:0];
        sharedView1 = nibViews[0];
    }
    return sharedView1;
}
//图片数组懒加载
-(NSArray *)imageArray{
    if (!_imageArray) {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (int i= 0; i < IMG_COUNT; i++) {
            NSString *picName = [NSString stringWithFormat:@"%@%d",IMG_NAME_PREFIX,i];
            UIImage *img = [UIImage imageNamed:picName];
            [tempArr addObject:img];
        }
        _imageArray = tempArr;
    }
    return _imageArray;
}
-(NSArray *)gifImagesArray{
    if (!_gifImagesArray) {
        _gifImagesArray = [self imagesSplitFromGIF];
    }
    return _gifImagesArray;
}

@end
